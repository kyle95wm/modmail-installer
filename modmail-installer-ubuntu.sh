#!/bin/bash
if ! which python3.7 && ! which pipenv ; then
    echo "You don't seem to have python3.7 or pip installed. Please install the following packages through apt: software-properties-common, python3.7, python3-pip, git"
    echo "Once finished, run: source .profile"
    exit 1
fi
echo "Script Started"
pip3 install pipenv
echo "Installing modmail"
git clone https://github.com/kyb3r/modmail.git
echo "Done! Installing Deps"
# We'll make sure to update our $PATH to include pipenv's location
source $HOME/.profile
cd modmail
if ! which pipenv ; then
	echo "ERROR! Looks like I had trouble finding pipenv's binary. It might not be in your PATH variable. Try to source your .profile file in your home folder by running: source .profile, then try again"
	exit 1
fi
pipenv install
echo "Installed Deps!"
cd ..
git clone https://github.com/kyb3r/logviewer.git
cd logviewer
echo "Cloned LogViewer, Installing deps"
pipenv install
echo "Installed Deps Of LogViewer"
cd ..
cd modmail
touch .env
echo "Enter TOKEN [Your discord bot's token.]"
read token
echo TOKEN=$token >>.env
echo "Enter GUILD_ID [The id for the server you are hosting this bot for.]"
read gid
echo GUILD_ID=$gid >>.env
echo "Enter MODMAIL_GUILD_ID [This is only used if you have a staff server. If you don't have one, just press ENTER.]"
read mgid
if [ ! -z "$mgid" ] ; then
    echo MODMAIL_GUILD_ID=$mgid >>.env
fi
echo "Enter Owner ID's [Comma separated user IDs of people that are allowed to use owner only commands. (eval and update).]"
read own
echo OWNERS=$own >>.env
echo "Enter CONNECTION_URI [Mongo DB connection URI for self-hosting your data.]"
read uri
echo CONNECTION_URI=$uri >>.env
echo "Enter LOG_URL [This can be the ip and port of your vps which you will set later]"
read lu
echo LOG_URL=$lu >>.env
echo "Completed Setup for modmail, not settings for logviewer"
cd ..
cd logviewer
touch .env
echo CONNECTION_URI=$uri >>.env
echo "Completed Setup!"
exit 0
