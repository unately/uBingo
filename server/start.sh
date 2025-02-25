#!/usr/bin/env bash
############################################DESCRIPTION#################################################
#
# Start script to easily run your server pack. In order to run this script even easier, run the start.bat-file
# which was also shipped with this server pack.
#
# A start-script supporting Forge, NeoForge, Fabric, Quilt and LegacyFabric as well as their supported Minecraft
# versions.
#
# This script downloads and installs the Modloader server depending on the settings in the acompanying variables.txt
# which was also shipped with this server pack. Should no suitable Java installation be found and your $JAVA-variable
# be set to "java", then a suitable Java-installation will also be downloaded and provided to this server pack.
#
# You can let the server restart by setting RESTART to true in your variables.txt. More information about the
# various settings in said file. Go check it out.
#

# pause
# Pause script execution. User input in the form of any keyboard key-press is required to continue execution.
pause() {
  read -n 1 -s -r -p "Press any key to continue"
}

# crashServer(reason)
# Crash script execution with exit code 1. Print $1 to the console.
crashServer() {
  echo "${1}"
  pause
  exit 1
}

# commandAvailable(command)
# Check whether the command $1 is available for execution. Can be used in if-statements.
commandAvailable() {
  command -v "$1" > /dev/null 2>&1
}

# getJavaVersion
# Set $JAVA_VERSION by checking $JAVA using -fullversion. Only the major version is stored, e.g. 8, 11, 17, 21.
getJavaVersion() {
  JAVA_VERSION=$("${JAVA}" -fullversion 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
  if [[ "$JAVA_VERSION" -eq 1 ]];then
    JAVA_VERSION=$("${JAVA}" -fullversion 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f2)
  fi
}

# installJava
# Runs the companion-script "install_java.sh" to install the required Java version for this modded Minecraft server.
installJava() {
  echo "No suitable Java installation was found on your system. Proceeding to Java installation."
  . install_java.sh || crashServer "Java install-script failed. Install Java $RECOMMENDED_JAVA_VERSION manually or edit JAVA in your variables.env to point to a Java installation of said version."
  if ! commandAvailable "$JAVA";then
    crashServer "Java installation failed. Couldn't find $JAVA."
  fi
}

# downloadIfNotExist(fileToCheck,fileToDownload,downloadURL)
# Checks whether file $1 exists. If not, then it is downloaded from $3 and stored as $2. Can be used in if-statements.
downloadIfNotExist() {
  if [[ ! -s "${1}" ]]; then

    echo "${1} could not be found." >&2
    echo "Downloading ${2}" >&2
    echo "from ${3}" >&2

    if commandAvailable curl ; then
      curl -# -L -o "./${2}" "${3}"
    elif commandAvailable wget ; then
      wget --show-progress -O "./${2}" "${3}"
    else
      crashServer "[ERROR] wget or curl is required to download files."
    fi

    if [[ -s "${2}" ]]; then
      echo "Download complete." >&2
      echo "true"
    else
      echo "false"
    fi

  else
    echo "${1} present." >&2
    echo "false"
  fi
}

# runJavaCommand(command)
# Runs the command $1 using the Java installation set in $JAVA.
runJavaCommand() {
  # shellcheck disable=SC2086
  "$JAVA" ${1}
}

refreshBootstrap() {
  if [[ "${BOOTSTRAP_FORCE_FETCH}" == "true" ]]; then
    rm -f packwiz-installer-bootstrap.jar
  fi

  if [[ "${BOOTSTRAP_VERSION}" == "latest" ]]; then
    BOOTSTRAP_DOWNLOAD_URL="https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest/download/packwiz-installer-bootstrap.jar"
  else
    BOOTSTRAP_DOWNLOAD_URL="https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/${BOOTSTRAP_VERSION}/packwiz-installer-bootstrap.jar"
  fi

  downloadIfNotExist "packwiz-installer-bootstrap.jar" "packwiz-installer-bootstrap.jar" "${BOOTSTRAP_DOWNLOAD_URL}"
}

# setupFabric
# Download and install a Fabric server for $MODLOADER_VERSION. If the Fabric Launcher is available for $MINECRAFT_VERSION
# and $MODLOADER_VERSION, it is downloaded and used, otherwise the regular Fabric-installer is downloaded and used.
# Checks are also performed to determine whether Fabric is available for $MINECRAFT_VERSION and $MODLOADER_VERSION.
setupFabric() {
  echo ""
  echo "Running Fabric checks and setup..."

  FABRIC_INSTALLER_URL="https://maven.fabricmc.net/net/fabricmc/fabric-installer/${FABRIC_INSTALLER_VERSION}/fabric-installer-${FABRIC_INSTALLER_VERSION}.jar"
  FABRIC_CHECK_URL="https://meta.fabricmc.net/v2/versions/loader/${MINECRAFT_VERSION}/${MODLOADER_VERSION}/server/json"
  IMPROVED_FABRIC_LAUNCHER_URL="https://meta.fabricmc.net/v2/versions/loader/${MINECRAFT_VERSION}/${MODLOADER_VERSION}/${FABRIC_INSTALLER_VERSION}/server/jar"

  if commandAvailable curl ; then
    FABRIC_AVAILABLE="$(curl -LI ${FABRIC_CHECK_URL} -o /dev/null -w '%{http_code}\n' -s)"
  elif commandAvailable wget ; then
    FABRIC_AVAILABLE="$(wget --server-response ${FABRIC_CHECK_URL}  2>&1 | awk '/^  HTTP/{print $2}')"
  fi
  if commandAvailable curl ; then
    IMPROVED_FABRIC_LAUNCHER_AVAILABLE="$(curl -LI ${IMPROVED_FABRIC_LAUNCHER_URL} -o /dev/null -w '%{http_code}\n' -s)"
  elif commandAvailable wget ; then
    IMPROVED_FABRIC_LAUNCHER_AVAILABLE="$(wget --server-response ${IMPROVED_FABRIC_LAUNCHER_URL}  2>&1 | awk '/^  HTTP/{print $2}')"
  fi

  if [[ "$IMPROVED_FABRIC_LAUNCHER_AVAILABLE" == "200" ]]; then
    echo "Improved Fabric Server Launcher available..."
    echo "The improved launcher will be used to run this Fabric server."
    LAUNCHER_JAR_LOCATION="fabric-server-launcher.jar"
    downloadIfNotExist "fabric-server-launcher.jar" "fabric-server-launcher.jar" "${IMPROVED_FABRIC_LAUNCHER_URL}" >/dev/null
  elif [[ "${FABRIC_AVAILABLE}" != "200" ]]; then
    crashServer "Fabric is not available for Minecraft ${MINECRAFT_VERSION}, Fabric ${MODLOADER_VERSION}."
  elif [[ $(downloadIfNotExist "fabric-server-launch.jar" "fabric-installer.jar" "${FABRIC_INSTALLER_URL}") == "true" ]]; then

    echo "Installer downloaded..."
    LAUNCHER_JAR_LOCATION="fabric-server-launch.jar"
    runJavaCommand "-jar fabric-installer.jar server -mcversion ${MINECRAFT_VERSION} -loader ${MODLOADER_VERSION} -downloadMinecraft"

    if [[ -s "fabric-server-launch.jar" ]]; then
      rm -rf .fabric-installer
      rm -f fabric-installer.jar
      echo "Installation complete. fabric-installer.jar deleted."
    else
      rm -f fabric-installer.jar
      crashServer "fabric-server-launch.jar not found. Maybe the Fabric servers are having trouble. Please try again in a couple of minutes and check your internet connection."
    fi

  else
    echo "fabric-server-launch.jar present. Moving on..."
    LAUNCHER_JAR_LOCATION="fabric-server-launch.jar"
  fi

  SERVER_RUN_COMMAND="${JAVA_ARGS} -jar ${LAUNCHER_JAR_LOCATION} nogui"
}

# Glorious StackOverflow to the rescue: https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script/246128#246128
# This little snipped ensures we are working in the directory which contains this script.
SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
cd "${DIR}" >/dev/null 2>&1 || exit

# Check whether the path to this directory contains spaces. Spaces in the path are prone to cause trouble.
if [[ "${DIR}" == *" "*  ]]; then

    echo "WARNING! The current location of this script contains spaces. This may cause this server to crash!"
    echo "It is strongly recommended to move this server pack to a location whose path does NOT contain SPACES!"
    echo ""
    echo "Current path:"
    echo "${PWD}"
    echo ""
    echo -n "Are you sure you want to continue? (Yes/No): "
    read -r WHY

    if [[ "${WHY}" == "Yes" ]]; then
        echo "Alrighty. Prepare for unforseen consequences, Mr. Freeman..."
    else
        crashServer "User did not desire to run the server in a directory with spaces in its path."
    fi
fi

# It is not recommended to run the server using root as this introduces security risks to your system.
# Using your regular user is enough.
if [[ "$(id -u)" == "0" ]]; then
  echo "Warning! Running with administrator-privileges is not recommended."
fi

if [[ ! -s "variables.env" ]]; then
  crashServer "ERROR! variables.env not present. Without it the server can not be installed, configured or started."
fi

source "variables.env"

LAUNCHER_JAR_LOCATION="do_not_manually_edit"
SERVER_RUN_COMMAND="do_not_manually_edit"
JAVA_VERSION="do_not_manually_edit"
IFS="." read -ra SEMANTICS <<<"${MINECRAFT_VERSION}"

# If Java checks are desired, then the available Java version is compared to the one required by the Minecraft server.
# Should no Java be found, or an incorrect version be available, the required one is installed by running installJava.
if [[ "${SKIP_JAVA_CHECK}" == "true" ]]; then
  echo "Skipping Java version checks."
else
  if [[ "$JAVA" == "java" ]];then
    if ! commandAvailable "$JAVA" ; then
      installJava
    else
      getJavaVersion
      if [[ "$JAVA_VERSION" =~ [0-9]+ ]];then
        if [[ "$JAVA_VERSION" != "$RECOMMENDED_JAVA_VERSION" ]];then
          installJava
        fi
      else
        installJava
      fi
    fi
  else
    getJavaVersion
    echo "Detected ${SEMANTICS[0]}.${SEMANTICS[1]}.${SEMANTICS[2]} - Java ${JAVA_VERSION}"
    if [[ "$JAVA_VERSION" != "$RECOMMENDED_JAVA_VERSION" ]];then
      JAVA="java"
      installJava
    fi
  fi
fi

# Check and warn the user if a 32bit Java-installation is used. Realistically, this should happen less and less, but
# it does happen from time to time. Best to warn people about it.
"$JAVA" "-version" 2>&1 | grep -i "32-Bit" && echo "WARNING! 32-Bit Java detected! It is highly recommended to use a 64-Bit version of Java!"

refreshBootstrap
runJavaCommand "-jar packwiz-installer-bootstrap.jar -g $PACKWIZ_URL"
setupFabric

echo ""
if [[ ! -s "eula.txt" ]]; then

  echo "Mojang's EULA has not yet been accepted. In order to run a Minecraft server, you must accept Mojang's EULA."
  echo "Mojang's EULA is available to read at https://aka.ms/MinecraftEULA"
  echo "If you agree to Mojang's EULA then type 'I agree'"
  echo -n "Response: "
  read -r ANSWER

  if [[ "${ANSWER}" == "I agree" ]]; then
    echo "User agreed to Mojang's EULA."
    echo "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://aka.ms/MinecraftEULA)." > eula.txt
    echo "eula=true" >> eula.txt
  else
    crashServer "User did not agree to Mojang's EULA. Entered: ${ANSWER}. You can not run a Minecraft server unless you agree to Mojang's EULA."
  fi

fi

echo ""
echo "Starting server..."
echo "Minecraft version:              ${MINECRAFT_VERSION}"
echo "Modloader:                      ${MODLOADER}"
echo "Modloader version:              ${MODLOADER_VERSION}"
echo "Fabric Installer Version:       ${FABRIC_INSTALLER_VERSION}"
echo "Java Args:                      ${JAVA_ARGS}"
echo "Additional Args:                ${ADDITIONAL_ARGS}"
echo "Java Path:                      ${JAVA}"
echo "Wait For User Input:            ${WAIT_FOR_USER_INPUT}"
if [[ "${LAUNCHER_JAR_LOCATION}" != "do_not_manually_edit" ]];then
    echo "Launcher JAR:                   ${LAUNCHER_JAR_LOCATION}"
fi
echo "Run Command:       ${JAVA} ${ADDITIONAL_ARGS} ${SERVER_RUN_COMMAND}"
echo "Java version:"
"${JAVA}" -version
echo ""

# Depending on $RESTART the server runs in a loop, to make sure it comes right back up after crashing. Force exit can be
# achieved by hitting CTRL+C multiple times. Variables are not reloaded between server runs. Quit the script and re-run
# it if you wish to reload the variables.
while true
do
  runJavaCommand "${ADDITIONAL_ARGS} ${SERVER_RUN_COMMAND}"
  if [[ "${SKIP_JAVA_CHECK}" == "true" ]]; then
    echo "Java version check was skipped. Did the server stop or crash because of a Java version mismatch?"
    echo "Detected ${SEMANTICS[0]}.${SEMANTICS[1]}.${SEMANTICS[2]} - Java ${JAVA_VERSION}, recommended $RECOMMENDED_JAVA_VERSION."
  fi
  if [[ "${RESTART}" != "true" ]]; then
    echo "Exiting..."
      if [[ "${WAIT_FOR_USER_INPUT}" == "true" ]]; then
        pause
      fi
    exit 0
  fi
  echo "Automatically restarting server in 5 seconds. Press CTRL + C to abort and exit."
  sleep 5
done

echo ""
