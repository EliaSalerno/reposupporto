#!/usr/bin/env bash

set -o nounset  # exit on uninitialised variable
set -o errexit  # exit on error
#set -o xtrace   # debug mode

# install.sh - Install script for Visual Paradign
#
# Jurgen Verhasselt - https://gitlab.com/sjugge/docker/visual-paradigm

wget -q https://www.visual-paradigm.com/downloads/vp/Visual_Paradigm_Linux64.sh --show-progress
chmod +x Visual_Paradigm_Linux64.sh
./Visual_Paradigm_Linux64.sh
#rm Visual_Paradigm_Linux64.sh
