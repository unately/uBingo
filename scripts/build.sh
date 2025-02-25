#!/usr/bin/env bash

# Copyright (c) 2025 Jqshuv
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

VERSION=$(jq -r '.version' package.json)

rm -rf build
mkdir -p build

# Run patcher script
./scripts/patcher.sh

# Export the modpack
packwiz modrinth export --output build/uBingo-$VERSION.mrpack

# Export the server
zip -r build/uBingo-$VERSION-server.zip server/*
