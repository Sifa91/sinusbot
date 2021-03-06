#!/bin/bash

if [ "$DEBUG" == "True" ] || [ "$DEBUG" == "true" ]; then
    set -xe
    sed -i 's/LogLevel.*/LogLevel = 10/g' "$SINUS_DIR/config.ini"
fi

echo "-> Checking if scripts directory is empty"
if [ ! -f "$SINUS_DATA_SCRIPTS/.docker-sinusbot-installed" ]; then
    echo "-> Copying original sinusbot scripts to volume ..."
    cp -af "$SINUS_DATA_SCRIPTS-orig/"* "$SINUS_DATA_SCRIPTS"
    touch "$SINUS_DATA_SCRIPTS/.docker-sinusbot-installed"
    echo "=> Sinusbot scripts copied."
else
    echo "=> Scripts directory is marked, scripts were already copied. Nothing to do."
fi

if [ -d "$SINUS_CONFIG" ]; then
    if [ ! -f "$SINUS_CONFIG/config.ini" ]; then
        cp -a "$SINUS_DIR/config.ini" "$SINUS_CONFIG/config.ini"
    fi
    rm -f "$SINUS_DIR/config.ini"
    ln -sf "$SINUS_CONFIG/config.ini" "$SINUS_DIR/config.ini"
    echo "=> Linked $SINUS_CONFIG/config.ini to $SINUS_DIR/config.ini."
fi

echo "=> Starting SinusBot (https://sinusbot.com) by Michael Friese ..."
exec "$SINUS_DIR/sinusbot" "$@"