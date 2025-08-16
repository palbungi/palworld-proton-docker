#!/bin/bash
# Declare directories
serverDir=/palworld

function installServer() {
	echo -e "\033[32;1m>>> Doing a fresh install of the PalWorld Server <<<\033[0m"
	if [[ -n $WEBHOOK_ENABLED ]] && [[ $WEBHOOK_ENABLED == "true" ]]; then
	    send_webhook_notification "Installing server" "Server is being installed" "$WEBHOOK_INFO_COLOR"
	fi
	${STEAMCMD} +@sSteamCmdForcePlatformType windows +force_install_dir "$serverDir" +login anonymous +app_update 2394010 validate +quit
	wget -P "$serverDir"/Pal/Binaries/Win64 https://github.com/Okaetsu/RE-UE4SS/releases/download/experimental-palworld/UE4SS-Palworld.zip \
	    && unzip -q "$serverDir"/Pal/Binaries/Win64/UE4SS-Palworld.zip -d "$serverDir"/Pal/Binaries/Win64 \
	    && rm "$serverDir"/Pal/Binaries/Win64/UE4SS-Palworld.zip

	wget -P "$serverDir"/Pal/Binaries/Win64/ue4ss/Mods https://github.com/Okaetsu/PalSchema/releases/download/0.5.0/PalSchema_0.5.0.zip \
	    && unzip -q "$serverDir"/Pal/Binaries/Win64/ue4ss/Mods/PalSchema_0.5.0.zip -d "$serverDir"/Pal/Binaries/Win64/ue4ss/Mods \
	    && rm "$serverDir"/Pal/Binaries/Win64/ue4ss/Mods/PalSchema_0.5.0.zip

	# Turn off GuiConsole
	sed -i 's/GuiConsoleEnabled = 1/GuiConsoleEnabled = 0/' "$serverDir"/Pal/Binaries/Win64/UE4SS-settings.ini
	sed -i 's/GuiConsoleVisible = 1/GuiConsoleVisible = 0/' "$serverDir"/Pal/Binaries/Win64/UE4SS-settings.ini
	sed -i 's/GraphicsAPI = opengl/GraphicsAPI = dx11/' "$serverDir"/Pal/Binaries/Win64/UE4SS-settings.ini
}

# Function to update the gameserver
function updateServer() {
    # force an update and validation
    echo -e "\033[34;1m>>> Doing an update and validate of the gameserver files <<<\033[0m"
    send_webhook_notification "Updating server" "Server is being updated and validated" "$WEBHOOK_INFO_COLOR"
    ${STEAMCMD} +@sSteamCmdForcePlatformType windows +force_install_dir "$serverDir" +login anonymous +app_update 2394010 validate +quit
}

# Function to start supercronic and load crons from crontab
function setupCron() {
	echo -e "\033[32;1m>>> Creating crontab <<<\033[0m"
	echo "" >> crontab
	if [[ -n "$BACKUP_ENABLED" ]] && [[ $BACKUP_ENABLED == "true" ]]; then
        echo "$BACKUP_CRON_EXPRESSION /backup.sh" >> crontab
    fi
    /usr/local/bin/supercronic crontab &
}

function installMods() {
	echo -e "\033[32;1m>>> Installing Mods <<<\033[0m"
	cp -R /mods/dll/* "$serverDir"/Pal/Binaries/Win64/Mods
	cp -R /mods/pak/* "$serverDir"/Pal/Content/Paks
	cp -R /mods/Win64/* "$serverDir"/Pal/Binaries/Win64
}
