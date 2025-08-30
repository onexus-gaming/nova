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

git clone https://github.com/bakpakin/binser lib/temp
mkdir lib/binser
mv lib/temp/binser.lua lib/binser/init.lua
rm -rf lib/temp

git clone https://github.com/rxi/classic lib/temp
mkdir lib/classic
mv lib/temp/classic.lua lib/classic/init.lua
rm -rf lib/temp

echo "what should your game be titled?"
read -p "(e.g. Super Game) " game_title

echo "what should your game's identifier be?"
read -p "(e.g. supergame) " game_id

cat <<EOF > main.lua
nova = require "lib.nova"

nova.title = [[$game_title]]
nova.id = [[$game_id]]

-- your code here
EOF

cat <<EOF > conf.lua
function love.conf(t)
    t.window.title = [[$game_title]]
    t.identity = [[$game_id]]
end
EOF

echo "all done! follow the tutorial to get started."