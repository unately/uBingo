git fetch
git pull
git pull --tags

rm pax & curl https://github.com/froehlichA/pax/releases/latest/download/pax -O pax && chmod 0777 pax
sudo bash pax -y upgrade

git add .
git commit -am "✈️ Updated Mods"
git push 