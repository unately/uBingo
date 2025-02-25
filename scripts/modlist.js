// Copyright (c) 2025 Jqshuv
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

const fs = require('fs');
const toml = require('toml');

const mods = [];

fs.readdirSync('mods').forEach(async file => {
	if (file.endsWith('.pw.toml')) {
		const rawData = fs.readFileSync(`mods/${file}`, 'utf-8');
		let parsedData = toml.parse(rawData);
		mods.push(parsedData);
  	}
});

mods.sort((a, b) => a.name.localeCompare(b.name));

async function processMods(mods) {
    // Sort mods by name
    mods.sort((a, b) => a.name.localeCompare(b.name));

    // Fetch member data for each mod
    const modInfoPromises = mods.map(async mod => {
        const data = await fetch(`https://api.modrinth.com/v2/project/${mod.update.modrinth["mod-id"]}/members`);
        const json = await data.json();
        const members = json.map(member => member.user);

        let output = `[${mod.name}](https://modrinth.com/mod/${mod.update.modrinth["mod-id"]})`;

        if (members.length === 1) {
            output += ` by [${members[0].username}](https://modrinth.com/user/${members[0].id})</br>`;
        } else if (members.length > 1) {
            const membersP = members.map(member => `[${member.username}](https://modrinth.com/user/${member.id})`);
            const last = membersP.pop();
            output += ` by ${membersP.join(", ")} and ${last}</br>`;
        }

        return output;
    });

    // Wait for all fetch operations to complete
    const results = await Promise.all(modInfoPromises);

    // Log each result line by line
    results.forEach(result => console.log(result));
}

processMods(mods);
