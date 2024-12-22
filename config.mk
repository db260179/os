# CHANGE this template config.mk to what pi you have and your settings!
# rpi3 for Raspberry Pi 3; rpi2 for the version 2, zerow for ZeroW

BOARD = rpi4

# Hardware configuration
PLATFORM = v3-hdmi

# Target hostname
HOSTNAME = pikvm

# SSL cert dns name
SSLHOST = pikvm.smart

# Monit settings
MONITEMAIL = myemail@gmail.com
MONITEMAILFROM = fromemail@gmail.com
MONITMAILSERVER = smtp.gmail.com
MONITMAILPORT = 587

# en_GB, etc. UTF-8 only
LOCALE = en_GB

# See /usr/share/zoneinfo
TIMEZONE = Europe/London

# For SSH root user
ROOT_PASSWD = root

# SSH Authorized_keys for root
ROOT_SSH_AUTH_KEYS = "`cat sshkeys`"

# Web UI credentials: user=admin, password=<this>
WEBUI_ADMIN_PASSWD = admin

# IPMI credentials: user=admin, password=<this>
IPMI_ADMIN_PASSWD = admin

# SD card device
CARD = /dev/mmcblk0

# Set WIFI SSID
WIFI_ESSID = "my-network"

# Set WIFI SSID Password
# Add '\' in front of your password, if it has special characters!
WIFI_PASSWD = "P@$$word"

# Connect to Hidden SSID - yes or no
WIFI_HIDE_ESSID = "no"
