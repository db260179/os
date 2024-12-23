-include config.mk

PLATFORM ?= v3-hdmi
SUFFIX ?=
export BOARD ?= rpi4
export PROJECT ?= pikvm-os.$(PLATFORM)$(SUFFIX)
export STAGES ?= __init__ os pikvm-repo pistat watchdog rootdelay ro pikvm restore-mirrorlist __cleanup__
export NC ?=

export HOSTNAME ?= pikvm
export SSLHOST ?=
export LOCALE ?= en_GB
export TIMEZONE ?= Europe/London
export ARCH_DIST_REPO_URL ?= http://de3.mirror.archlinuxarm.org
BUILD_OPTS ?=

WIFI_HIDE_ESSID ?=
WIFI_ESSID ?=
WIFI_PASSWD ?=
WIFI_IFACE ?= wlan0

ROOT_PASSWD ?= root
ROOT_SSH_AUTH_KEYS ?=
WEBUI_ADMIN_PASSWD ?= admin
IPMI_ADMIN_PASSWD ?= admin

MONITEMAIL ?=
MONITEMAILFROM ?=
MONITMAILSERVER ?=
MONITMAILPORT ?=

export DISK ?= $(shell pwd)/disk/$(word 1,$(subst -, ,$(PLATFORM))).conf
export CARD ?= /dev/null
export IMAGE_XZ ?=

DEPLOY_USER ?= root


# =====
SHELL = /usr/bin/env bash
_BUILDER_DIR = ./.pi-builder/$(PLATFORM)-$(BOARD)$(SUFFIX)

define optbool
$(filter $(shell echo $(1) | tr A-Z a-z),yes on 1)
endef

define fv
$(shell curl --silent "https://files.pikvm.org/repos/arch/$(BOARD)/latest/$(1)")
endef


# =====
all:
	@ echo "Available commands:"
	@ echo "    make                # Print this help"
	@ echo "    make os             # Build OS with your default config"
	@ echo "    make shell          # Run Arch-ARM shell"
	@ echo "    make image          # Build image (/images) to burn to SD card later"
	@ echo "    make install        # Install rootfs to partitions on $(CARD)"
	@ echo "    make image          # Create a binary image for burning outside of make install"
	@ echo "    make scan           # Find all RPi devices in the local network"
	@ echo "    make clean          # Remove the generated rootfs"
	@ echo "    make clean-all      # Remove the generated rootfs and pi-builder toolchain"


shell: $(_BUILDER_DIR)
	$(MAKE) -C $(_BUILDER_DIR) shell


os: $(_BUILDER_DIR)
	rm -rf $(_BUILDER_DIR)/stages/arch/{pikvm,pikvm-otg-console}
	cp -a stages/arch/{pikvm,pikvm-otg-console} $(_BUILDER_DIR)/stages/arch
	$(MAKE) -C $(_BUILDER_DIR) os \
		BUILD_OPTS=' $(BUILD_OPTS) \
			--build-arg PLATFORM=$(PLATFORM) \
			--build-arg OLED=$(call optbool,$(OLED)) \
			--build-arg VERSIONS=$(call fv,ustreamer)/$(call fv,kvmd)/$(call fv,kvmd-webterm)/$(call fv,kvmd-fan) \
			--build-arg FAN=$(call optbool,$(FAN)) \
			--build-arg WIFI_HIDE_ESSID=$(WIFI_HIDE_ESSID) \
			--build-arg WIFI_ESSID=$(WIFI_ESSID) \
			--build-arg WIFI_PASSWD=$(WIFI_PASSWD) \
			--build-arg WIFI_IFACE=$(WIFI_IFACE) \
			--build-arg ROOT_PASSWD=$(ROOT_PASSWD) \
			--build-arg ROOT_SSH_AUTH_KEYS="'$(ROOT_SSH_AUTH_KEYS)'" \
			--build-arg WEBUI_ADMIN_PASSWD=$(WEBUI_ADMIN_PASSWD) \
			--build-arg IPMI_ADMIN_PASSWD=$(IPMI_ADMIN_PASSWD) \
			--build-arg NEW_HTTPS_CERT=$(shell uuidgen) \
			--build-arg SSLHOST=$(SSLHOST) \
			--build-arg MONITEMAIL=$(MONITEMAIL) \
			--build-arg MONITEMAILFROM=$(MONITEMAILFROM) \
			--build-arg MONITMAILSERVER=$(MONITMAILSERVER) \
			--build-arg MONITMAILPORT=$(MONITMAILPORT) \
		'

$(_BUILDER_DIR):
	mkdir -p `dirname $(_BUILDER_DIR)`
	git clone --depth=1 https://github.com/db260179/pi-builder.git $(_BUILDER_DIR)


update: $(_BUILDER_DIR)
	cd $(_BUILDER_DIR) && git pull --rebase
	git pull --rebase


install: $(_BUILDER_DIR)
	$(MAKE) -C $(_BUILDER_DIR) install


image: $(_BUILDER_DIR)
	$(eval _dated := $(PLATFORM)-$(BOARD)$(SUFFIX)-$(shell date +%Y%m%d).img)
	$(eval _latest := $(PLATFORM)-$(BOARD)$(SUFFIX)-latest.img)
	$(eval _suffix = $(if $(call optbool,$(IMAGE_XZ)),.xz,))
	mkdir -p images
	$(MAKE) -C $(_BUILDER_DIR) image IMAGE=$(shell pwd)/images/$(_dated)
	cd images && ln -sf $(_dated)$(_suffix) $(_latest)$(_suffix)
	cd images && ln -sf $(_dated)$(_suffix).sha1 $(_latest)$(_suffix).sha1


scan: $(_BUILDER_DIR)
	$(MAKE) -C $(_BUILDER_DIR) scan


clean: $(_BUILDER_DIR)
	$(MAKE) -C $(_BUILDER_DIR) clean


clean-all:
	- $(MAKE) -C $(_BUILDER_DIR) clean-all
	rm -rf $(_BUILDER_DIR)
	- rmdir `dirname $(_BUILDER_DIR)`


upload:
	rsync -rl --progress images/ $(DEPLOY_USER)@files.pikvm.org:/var/www/files.pikvm.org/images
