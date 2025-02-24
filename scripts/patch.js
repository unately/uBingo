// Copyright (c) 2025 Jqshuv
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

const fs = require('fs');

function setNestedKey(obj, keyPath, value) {
	const keys = keyPath.split('.');
	let current = obj;

	for (let i = 0; i < keys.length - 1; i++) {
	  const key = keys[i];
	  if (!current[key]) current[key] = {};
	  current = current[key];
	}

	current[keys[keys.length - 1]] = value;
}

const changes = [
  {
	file: 'config/sodium-options.json',
	replace: [
	  {
		key: 'notifications.has_cleared_donation_button',
		value: false
	  },
	  {
		key: 'notifications.has_seen_donation_prompt',
		value: false
	  }
	]
  },
  {
	file: 'config/yet-another-minecraft-bingo/config.json',
	replace: [
	  {
		key: 'statsHostId',
		value: ""
	  }
	]
  }
];


changes.forEach(change => {
	const filePath = change.file;
  
	// JSON-Datei lesen
	if (fs.existsSync(filePath)) {
	  const rawData = fs.readFileSync(filePath, 'utf-8');
	  let jsonData;
  
	  try {
		jsonData = JSON.parse(rawData);
	  } catch (error) {
		console.error(`Fehler beim Parsen von ${filePath}:`, error);
		return;
	  }
  
	  // Änderungen anwenden
	  change.replace.forEach(({ key, value }) => {
		setNestedKey(jsonData, key, value);
	  });
  
	  // Geänderte JSON-Datei speichern
	  fs.writeFileSync(filePath, JSON.stringify(jsonData, null, 2));
	  console.log(`Datei ${filePath} erfolgreich aktualisiert.`);
	} else {
	  console.error(`Datei nicht gefunden: ${filePath}`);
	}
});
