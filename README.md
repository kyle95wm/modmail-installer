# modmail-installer


This repo houses the script that allows you to install Modmail. You will need to have already installed python 3.7 and pip for python 3.7

# Getting started

Run the following commands:

`sudo apt update && sudo apt upgrade -y && sudo apt install software-properties-common python3.7 python3-pip git -y`

Once you've done that, run the modmail-installer.sh script by making it executable and then running it:
`chmod +x ./modmail-installer-ubuntu.sh && ./modmail-installer-ubuntu.sh`

Installation should complete without a hitch.

# Starting the bot and log-viewer

To start the bot, cd into the modmail folder and run: `pipenv run python3.7 bot.py`
To start the log viewer, cd into the logviewer folder and run: `pipenv run python3.7 app.py`

You may wish to add these as startup scripts or run them inside of `screen`, as closing out your terminal window will kill these scripts and make your bot and log viewer go offline.
