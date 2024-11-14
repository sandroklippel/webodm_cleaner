# Global variables
APP=webodm_cleaner
APP_DIR=dist
BUILD_FILES=__main__.py
BUILD_DIR=build
INSTALL_DIR=/usr/local/bin
CONFIG_DIR=/usr/local/etc
CONFIG_FILE=cleaner.json

.PHONY: all install-all requirements app prepare install service uninstall rmservice 

# Main targets
all: requirements app
install-all: prepare install service

# Include the .mk files
include build.mk
include install.mk
include service.mk