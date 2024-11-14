# Global variables
APP=webodm_cleaner
APP_DIR=dist
BUILD_FILES=__main__.py
BUILD_DIR=build
INSTALL_DIR=/usr/local/bin
CONFIG_DIR=/usr/local/etc
CONFIG_FILE=cleaner.json

# Include the .mk files
include build.mk
include install.mk
include service.mk

# Main targets
all: prepare requirements app
install-all: install service

.PHONY: all install-all prepare requirements app install service rmservice uninstall