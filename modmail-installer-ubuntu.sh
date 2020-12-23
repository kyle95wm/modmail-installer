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
echo "We are about to set up your log viewer. Do you want to set up your log viewer on THIS machine? [y/n]. If you choose not to, you will be prompted to enter a Heroku app name. If you choose to have a local log viewer instead, you must enter your machine's IP address, followed by port 8000 (http://10.10.10.10:8000)"
read locallogs
if [ -z "$locallogs" ] || [ "$locallogs" == "y" ] || [ "$locallogs" == "Y" ] ; then
    git clone https://github.com/kyb3r/logviewer.git
    cd logviewer
    echo "Cloned LogViewer, Installing deps"
    pipenv install
    echo "Installed Deps Of LogViewer"
    cd ..
fi
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
if [ $locallogs == "y" ] || [ -z $locallogs ] ; then
    echo "Enter LOG_URL [This is the ip and port of your vps which was mentioned earlier.]"
    read lu
    echo LOG_URL=$lu >>.env
fi
if [ $locallogs == "n" ] || [ $locallogs == "N" ] ; then
    echo "Enter LOG_URL [This is the APP NAME of your Heroku log viewe application. You do not need to include the full URL, just your app's name.]"
    read lu
    echo LOG_URL=https://$lu.herokuapp.com >>.env
fi
if [ -z "$locallogs" ] || [ "$locallogs" == "y" ] || [ "$locallogs" == "Y" ] ; then
    echo "Completed Setup for modmail, now settings for logviewer"
    cd ..
    cd logviewer
    touch .env
    echo CONNECTION_URI=$uri >>.env
fi
echo "Completed Setup! Before you try to run your apps, run: 'source .profile' in your home folder."
exit 0
