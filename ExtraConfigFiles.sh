#!/bin/bash
# Create folder for github repo
mkdir ~/github
cd ~/github

# Download repo
git clone https://github.com/RaulCalvoLaorden/configFiles
cd configFiles

# Exec script to create de symbolic files
bash sym.sh