git fetch
git pull
git pull --tags

rm pax & curl https://github.com/froehlichA/pax/releases/latest/download/pax -O pax && sudo chmod 0777 pax
./pax -y upgrade

git add .
git commit -am "✈️ Updated Mods"
git push 