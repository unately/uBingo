# Copyright (c) 2025 Jqshuv
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# Step 1: Run packwiz refresh
echo "Refreshing packwiz..."
packwiz refresh

# Step 2: Run the Node.js patch script
echo "Running patch script..."
node scripts/patch.js

# Step 3: Run tests with pnpm
echo "Running tests with pnpm..."
pnpm test
