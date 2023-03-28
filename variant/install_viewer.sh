#!/usr/bin/env bash

set -o nounset  # exit on uninitialised variable
set -o errexit  # exit on error
#set -o xtrace   # debug mode

# install_viewer.sh - Install script for Visual Paradign
#
# Jurgen Verhasselt - https://gitlab.com/sjugge/docker/visual-paradigm

echo "Installing VP-Viewer FREE VP project browser"
wget https://www.visual-paradigm.com/downloads/vpviewer/Visual_Paradigm_Project_Viewer_Linux64.sh --show-progress
chmod +x Visual_Paradigm_Project_Viewer_Linux64.sh
./Visual_Paradigm_Project_Viewer_Linux64.sh
#rm Visual_Paradigm_Project_Viewer_Linux64.sh
