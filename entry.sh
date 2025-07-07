#!/bin/bash

function maybe_replace_wine()
{
    FOUND=$(dpkg --get-selections | grep "winehq-${WINE_REPLACE_REL}")
    if [ -z "${FOUND}" ]; then
        apt-get update
        apt-get remove --purge -y \
            winehq-${WINE_REL}=${WINE_VER} \
            wine-${WINE_REL}=${WINE_VER} \
            wine-${WINE_REL}-amd64=${WINE_VER} \
            wine-${WINE_REL}-i386=${WINE_VER}
        apt-get install -y --install-recommends --no-install-suggests \
            winehq-${WINE_REPLACE_REL} \
            wine-${WINE_REPLACE_REL} \
            wine-${WINE_REPLACE_REL}-amd64 \
            wine-${WINE_REPLACE_REL}-i386
        apt-get clean autoclean
        apt-get autoremove -y
    fi
}

function install()
{
    echo "Installing Risk of Rain 2 server..."
    "${STEAMCMD}" +force_install_dir "${STEAMAPPDIR}" +login anonymous +@sSteamCmdForcePlatformType windows +app_update "${STEAMAPPID}" +quit
}

function mount_mods()
{
    echo "Setting up mods..."
        rm -rf "${STEAMAPPDIR}/BepInEx"
        cp -r  "${MODDIR}/BepInEx"             "${STEAMAPPDIR}/BepInEx"
        cp     "${MODDIR}/doorstop_config.ini" "${STEAMAPPDIR}/doorstop_config.ini"
        cp     "${MODDIR}/winhttp.dll"         "${STEAMAPPDIR}/winhttp.dll"
        DLL="winhttp=n,b"
}

function execute()
{
    maybe_replace_wine
    echo "Check if application is already installed..."
    if [ ! -f "${STEAMAPPDIR}/Risk of Rain 2.exe" ]; then
        install
    else
        echo "Application already installed, skipping installation."
    fi

    echo "Generating server configuration..."
    envsubst < "default_config.cfg" > "${STEAMAPPDIR}/Risk of Rain 2_Data/Config/server.cfg"

    if [ "${R2_ENABLE_MODS}" = 1 ]; then
        mount_mods
    fi

    echo "Generating initial Wine configuration..."
    winecfg

    echo "Let's wait :)"
    sleep 5

    echo "Starting server..."
    WINEDLLOVERRIDES=${DLL} xvfb-run wine "${STEAMAPPDIR}/Risk of Rain 2.exe"
}


# Execute based on user input（if input nothing, run execute）
if [ -z "$1" ]; then
    # Redirect both stdout and stderr to stdout and to a file
    execute 2>&1 | tee "${STEAMAPPDIR}/entry.log" &
else
    case "$1" in
        install)
            install
            ;;
        mod)
            mount_mods
            ;;
        run)
            execute 2>&1 | tee "${STEAMAPPDIR}/entry.log" &
            ;;
        *)
            echo "Usage: $0 [install|mod|run]"
            exit 1
            ;;
    esac
fi
tail -f /dev/null

