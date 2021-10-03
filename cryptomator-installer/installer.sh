#!/bin/bash
#
# instaler.sh
#
PATH_INSTALL=/opt/cryptomator
PATH_DESKTOP_ENTRIES=/usr/share/applications
CRYPTOMATOR_DOWNLOAD_URL=https://github.com/cryptomator/cryptomator/releases/download/1.5.17/cryptomator-1.5.17-x86_64.AppImage
REPO_INSTALLER_URL=https://raw.githubusercontent.com/franjsco/utils/main/cryptomator-installer/

log() {
    echo "[cryptomator-installer] - $(date '+%d/%m/%Y %H:%M:%S') - $1"
}


make_directory() {
    log "check if directory exists."

    if [[ -d "$PATH_INSTALL" ]] 
    then
        log "$PATH_INSTALL exists!"
        exit 1
    fi

    mkdir -p $PATH_INSTALL
}


download_cryptomator_files() {
    cd $PATH_INSTALL

    log "download cryptomator from official repo"
    # download AppImage from official repo
    wget $CRYPTOMATOR_DOWNLOAD_URL -O cryptomator.AppImage

    log "download desktop entry"
    # download desktop entry
    wget $REPO_INSTALLER_URL/cryptomator.desktop -O cryptomator.desktop
    
    log "download logo"
    # download logo
    wget $REPO_INSTALLER_URL/cryptomator-logo.svg -O cryptomator-logo.svg
}


make_as_executable() {
    chmod +x cryptomator.AppImage
}


copy_desktop_entry() {
    log "copy desktop entry into $PATH_DESKTOP_ENTRIES"
    cp cryptomator.desktop $PATH_DESKTOP_ENTRIES
}


uninstall() {
    log "remove cryptomator from opt dir"
    rm -rf $PATH_INSTALL

    log "remove desktop entry"
    rm $PATH_DESKTOP_ENTRIES/cryptomator.desktop
}


main() {
    MODE=$1

    echo "cryptomator-installer"
    echo -e "---------------------\n"

    if [[ -z $MODE ]]; then
        make_directory
        download_cryptomator_files
        make_as_executable
        copy_desktop_entry
    elif [[ $MODE == "uninstall" ]]; then
        uninstall
    else
        echo "Error: argument is not valid"
        exit 1
    fi    
}

main $1
