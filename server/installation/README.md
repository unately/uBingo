---
description: This documentation will show you, how you create a server.
---

# ✈ Installation

## Prerequisites

* [Java >17](pre-install.md#java-17)
* [Internet connection](https://www.speedtest.net)
* Linux only: [curl](pre-install.md#curl)

## Using Docker

{% content-ref url="install-with-docker.md" %}
[install-with-docker.md](install-with-docker.md)
{% endcontent-ref %}

## On your own computer

{% tabs %}
{% tab title="Windows" %}
#### On a Windows PC

1. Open the latest release page [_here_](https://github.com/Unately/uBingo/releases/latest)_._
2. Download the serverpack by clicking on _**uBingo-Server-vX.X.X.zip**_.
3. Open the file and drag & drop all files into a folder, where you want to install the server.
4. Execute the _**startserver.bat**_ file ([_Click on Run Anyway_](../../tutorials/run-anyway-virus.md))
5. Now the server is installing, if you want do stop the server type in the opened console _**stop**_ and you can start the server again by doing step four again.
{% endtab %}

{% tab title="Linux" %}
#### On a Linux PC

* Open the Terminal.
* Then create a new folder using the following command.

```bash
mkdir uBingoServer && cd uBingoServer
```

* Open the latest release page [_here_](https://github.com/Unately/uBingo/releases/latest).
* Right click the **uBingo-Server-vX.X.X.zip** file and click on _Copy link._
* Go back in the Console and type the command. **But don't forget to change the link to your copied!**

```bash
wget YOUR_COPIED_LINK
```

* Unzip the file using the following command.

```bash
unzip uBingo-Server-v*.zip && rm uBingo-Server-*.zip && rm startserver.bat
```

* Make the bash file executable with the following command.

```bash
chmod +x startserver.sh
```

* Then you can execute the file using this command. _Or you can double click the file in the folder._

```bash
bash startserver.sh
```

* Now the server is installing, if you want do stop the server type in the opened console _**stop**_ and you can start the server again by doing step eight again.
{% endtab %}
{% endtabs %}

## On a dedicated Server.

{% tabs %}
{% tab title="Linux Server" %}
#### On a Linux Server

* Connect to your server via [ssh](../../tutorials/ssh.md).
* Then create a new folder using the following command.

```bash
mkdir uBingoServer && cd uBingoServer
```

* Open the latest release page [_here_](https://github.com/Unately/uBingo/releases/latest).
* Right click the **uBingo-Server-vX.X.X.zip** file and click on _Copy link._
* Go back in the Console and type the command. **But don't forget to change the link to your copied!**

```bash
wget YOUR_COPIED_LINK
```

* Unzip the file using the following command.

```bash
unzip uBingo-Server-v*.zip && rm uBingo-Server-*.zip && rm startserver.bat
```

* Make the bash file executable with the following command.

```bash
chmod +x startserver.sh
```

* Then you can execute the file using this command.

```bash
bash startserver.sh
```

* Now the server is installing, if you want do stop the server type in the opened console _**stop**_ and you can start the server again by doing step eight again.
{% endtab %}

{% tab title="Windows" %}
not done yet, <mark style="color:blue;background-color:blue;">ICEBOXED</mark>
{% endtab %}
{% endtabs %}
