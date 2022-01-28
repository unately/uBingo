git fetch
git pull
git pull --tags

rm pax & wget https://github.com/froehlichA/pax/releases/latest/download/pax && sudo chmod 0777 pax
sudo bash pax -y upgrade

git add .
git commit -am "✈️ Updated Mods"
git push 