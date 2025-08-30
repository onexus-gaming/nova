#!/bin/bash

VER="0.1.0"
YEAR=2025

echo "nova installer v$VER"
echo "onexus, $YEAR"

echo "use git for version control? (repository must already be set up)"
read -p "[y/N] " use_git
case "$use_git" in
    "y"|"Y")
        git submodule add https://github.com/onexus-gaming/nova lib/nova
    ;;
    *)
        git clone https://github.com/onexus-gaming/nova lib/nova
    ;;
esac