# CHANGE this template config.mk to what pi you have and your settings!
# rpi3 for Raspberry Pi 3; rpi2 for the version 2, zerow for ZeroW

BOARD = rpi4

# Hardware configuration
PLATFORM = v3-hdmi
SUFFIX = -box
OLED = 1
FAN = 1

# Target hostname
HOSTNAME = pikvm

# SSL cert dns name
SSLHOST = pikvm.lan

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
ROOT_PASSWD = $(shell echo -n 'root' | base64 -w0)

# SSH Authorized_keys for root
ROOT_SSH_AUTH_KEYS = $(shell base64 -w0 sshkeys)

# Web UI credentials: user=admin, password=<this>
WEBUI_ADMIN_PASSWD = $(shell echo -n 'admin' | base64 -w0)

# IPMI credentials: user=admin, password=<this>
IPMI_ADMIN_PASSWD = $(shell echo -n 'admin' | base64 -w0)

# SD card device
CARD = /dev/mmcblk0

# Set WIFI SSID
WIFI_ESSID = $(shell echo -n 'my-network' | base64 -w0)

# Set WIFI SSID Password
# Add '\' in front of your password, if it has special characters!
WIFI_PASSWD = $(shell echo -n 'P@$$word' | base64 -w0)

# Connect to Hidden SSID - yes or no
WIFI_HIDE_ESSID = $(shell echo -n 'no' | base64 -w0)
