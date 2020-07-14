# MattermostToRocketChat
a simple, not really comprehensive, script to convert a Mattermost json export file to a Rocket.Chat csv import zip file

i thought someone might be interested, so i shared it here. PRs welcome (would be great if the resulting zip import can be tested ;))
code is rough and written in a couple of minutes to transfer messages of a hand full of channels, so probably not the solution you were looking for if you have lots of channels with lots of members :D

# What it can do currently
- Import channels (with blacklist)
- Import messages of channels

# What it can't do currently
- Import users
- Import channel members (will be set to a default user(s), adding members must be done manually after import)
- Import direct messages

# Disclaimer
this script was more of a "proof of concept" NOT a comprehensive solution to migrate production data from one system to another.

use this script at your own risk!
i'm not resposible for any missing messages or failures/overwrites during import / export etc.

i just thought this might be a good starting point for someone

# Resources

- https://docs.rocket.chat/guides/administrator-guides/import/csv
- https://docs.mattermost.com/administration/bulk-export.html
