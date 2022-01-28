git fetch
git pull

rm pax & wget -q https://github.com/froehlichA/pax/releases/latest/download/pax && sudo chmod 0777 pax
sudo ./pax -y upgrade

git add .
git commit -am "✈️ Updated Mods"
git push 