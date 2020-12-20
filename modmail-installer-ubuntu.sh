#!/bin/bash

# This script will assist in installing Modmail to a dedicated server/VPS.
# Keep in mind that you will still require a Heroku logviewer
# THIS SCRIPT IS CURRENTLY A PROOF OF CONCEPT AND MAY NOT WORK AS EXPECTED.

# VARS
setyp_type= # This is the type of guild setup for the bot. Possible choices are "single" or "staff"
token= #the bot's token
log_url=https://example.com # User can set this later
main_server= # the main server for the bot
staff_server= # If using a staff server setup, this is the ID that will be used
owner_id= # the user ID of the owner of the bot. The ID set here will be given level 5 permissions for the bot
connect_uri= # Mongo URI
github_token= # Github token for updating the bot. Not sure if this is needed for local hosting?
##########################################################
# Checks
if [ "$PWD" != "$HOME" ] ; then
    echo "Hey, could you please move this script to your home folder ($HOME) and try again?"
    exit 1
fi

if [ "$(id -u)" == "0" ] ; then
    echo "Uhhhhh you might not want to run this as root!"
    echo "Running this as root is not required. Please try running this as something other than root and try again."
    exit 1
fi

if [ -f "$PWD"/.modmail-installed ] ; then
    echo "Modmail is already installed on this server!"
    exit 1
fi
if [ ! -f "$PWD"/.modmail-installer-init ] ; then
    echo "Welcome to the Modmail installer! This installer will walk you through the process of installing the bot to this server. Please keep in mind that you will still need to deploy a log viewer to Heroku for this to work. You will be asked about it later on in this installation."
    echo "PLEASE NOTE: There may be some cases where your sudo password is required. Please keep an eye out for this and try not to step too far away from your machine, as to not miss this."

    # We create a file that will skip the above prompts if the script needs to be re-ran for whatever reason
    # Files like these will be created throughout the installation as sort of "checkpoints" which will later be cleaned up.
    touch "$PWD"/.modmail-installer-init
fi


# First let's install Python 3.7 with pip
if [ ! -f "$PWD"/.modmail-installer-python-install ] ; then
    sudo apt update
    sudo apt upgrade -y
    sudo apt install software-properties-common -y
    sudo apt install python3.7 python3-pip -y
    if [ "$(python3.7 --version)" ] && [ "$(pip3 --version)" ] ; then
        # If this succeeds, we make a new checkpoint
        touch "$PWD"/.modmail-installer-python-install
    else
        echo "Seems something went wrong with the installation of either Python or Pip. Please re-run this script to try again!"
        exit 1
    fi
echo "Finished installing python and pip! Please re-run this script to wrap things up."
exit 0
fi

# Clone the repo for Modmail
if ! "dpkg -L git" ; then
    sudo apt install git -y
fi
git clone https://github.com/kyb3r/modmail
cd "$PWD"/modmail/
echo "Awesome! We've just clone the git repo! You will now be asked a series of questions. Please fill them out with accurate details."
read -rp "Please respond with either the word single OR staff, for your server setup: " setup_type
# We'll take the .env.example contents and set them based on responses after this
read -rp "What is your bot's token?: " token
read -rp "Please input the URL for your log viewer. The correct format would be https://log-viewer-name.herokuapp.com: " log_url
read -rp "Please input the server ID for the main server you will be having the bot on.: " main_server
if [ $setup_type == "staff" ] ; then
    read -rp "Please input your staff server ID: " staff_server
fi
read -rp "Please input your user ID. This is the ID that will be given owner permissins for the bot: " owner_id
read -rp "Lastly, please provide your full mongo connection URI according to the installation guide: " connect_uri
echo "Thank you! That's all the information I will need for now."
if [ ! -f "$PWD"/.modmail-installer-env-set ] ; then
# We will now input all of this into a new .env file
touch $HOME/modmail/.env
    if [ $setup_type == "staff" ] ; then
cat > $HOME/modmail/.env <<EOF
TOKEN=$token
LOG_URL=$log_url
GUILD_ID=$main_server
MODMAIL_GUILD_ID=$staff_server
OWNERS=$owner_id
CONNECTION_URI=$connect_uri
EOF
    fi
    if [ $setup_type == "single" ] ; then
cat > $HOME/modmail/.env <<EOF
TOKEN=$token
LOG_URL=$log_url
GUILD_ID=$main_server
OWNERS=$owner_id
CONNECTION_URI=$connect_uri
EOF
    fi
touch "$PWD"/.modmail-installer-env-set
echo "All done! Now, please re-run this script for one final time. Before you do this, please run: source .profile"
exit 1
fi
pip3 install pipenv pipenv install
echo "All done! You can now run your bot by cd'ing to the modmail directory (cd modmail/) and running the folowing command: pipenv run python3.7 bot.py"
touch "$PWD"/.modmail-installed
