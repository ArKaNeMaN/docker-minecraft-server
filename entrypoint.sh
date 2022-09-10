#!/bin/bash

exit_handler () {
	# Execute the  shutdown commands
    echo "recieved SIGTERM stopping ${GAMESERVER}"
	./${GAMESERVER} stop
	exit 0
}

# Exit trap
echo "Loading exit trap."
trap exit_handler SIGTERM

echo -e "Welcome to the LinuxGSM Docker"
echo -e "================================================================================"
echo -e "GAMESERVER: ${GAMESERVER}"
echo -e "UID: $UID"
echo -e ""
echo -e "LGSM_GITHUBUSER: ${LGSM_GITHUBUSER}"
echo -e "LGSM_GITHUBREPO: ${LGSM_GITHUBREPO}"
echo -e "LGSM_GITHUBBRANCH: ${LGSM_GITHUBBRANCH}"
echo -e "LGSM_STOP_AFTER_INSTALL: ${LGSM_STOP_AFTER_INSTALL}"

echo -e ""
echo -e "Initalising"
echo -e "================================================================================"

# Correct permissions in home dir
echo "Update permissions for LinuxGSM."
sudo chown -R linuxgsm:linuxgsm /home/linuxgsm

# Copy linuxgsm.sh into homedir
# if [ ! -e ~/linuxgsm.sh ]; then
#     echo "copying linuxgsm.sh to /home/linuxgsm"
#     cp /linuxgsm.sh ~/linuxgsm.sh
# fi

# Setup game server
if [ ! -f "${GAMESERVER}" ]; then
    echo "Creating ./${GAMESERVER}."
   ./linuxgsm.sh ${GAMESERVER}
fi

# Install game server
if [ -z "$(ls -A -- "serverfiles")" ]; then
    echo "Installing ${GAMESERVER}."
    ./${GAMESERVER} auto-install

    if [ $LGSM_STOP_AFTER_INSTALL -ne "0" ]; then
        echo "Server installed, container will be stopped."
        exit 0
    fi
fi

# echo "Starting cron."
# sudo cron

# Update game server
# echo ""
# echo "update ${GAMESERVER}"
# ./${GAMESERVER} update

echo ""
echo "Start ${GAMESERVER}."
./${GAMESERVER} start
sleep 5
./${GAMESERVER} details

tail -f log/script/*

# with no command, just spawn a running container suitable for exec's
if [ $# = 0 ]; then
    tail -f /dev/null
else
    # execute the command passed through docker
    "$@"

    # if this command was a server start cmd
    # to get around LinuxGSM running everything in
    # tmux;
    # we attempt to attach to tmux to track the server
    # this keeps the container running
    # when invoked via docker run
    # but requires -it or at least -t
    tmux set -g status off && tmux attach 2> /dev/null
fi

exec "$@"
