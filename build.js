// Copyright (c) 2024 Joshua Schmitt
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

const fs = require('fs');
const { exec } = require('child_process');

try {
    fs.readdirSync('./config');
} catch (err) {
    fs.mkdirSync('./config');
}

fs.readdir('./.pakku', (err, files) => {
    for (const fileone of files) {
        // if filetype is folder
        fs.readdir(`./.pakku/${fileone}`, (err, files) => {
            for (const file of files) {
                if (file == 'config') {
                    fs.readdir(`./.pakku/${fileone}/config`, (err, files) => {
                        console.log(files);
                        for (const file of files) {
                            fs.cp(`./.pakku/${fileone}/config/${file}`, `./config/${file}`, { recursive: true },  (err) => {
                                if (err) {
                                    console.log(err);
                                }
                            })
                        }
                    })
                }
            }
        })
    }
})

fs.rmdirSync('./build', { recursive: true });

exec('java -jar pakku.jar export', (err, stdout, stderr) => {
    if (err) {
        console.log(err);
    }
    console.log(stdout);
    console.log(stderr);
})
