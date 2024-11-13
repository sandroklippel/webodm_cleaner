APP=webodm_cleaner
APP_DIR=dist
BUILD_FILES=__main__.py
BUILD_DIR=build
INSTALL_DIR=/usr/local/bin

requirements: requirements.txt
	mkdir -p $(BUILD_DIR)
	python3 -m pip install -r requirements.txt --target $(BUILD_DIR)

app: $(BUILD_FILES) requirements
	mkdir -p $(APP_DIR)
	rm -f "$(APP_DIR)/$(APP)"
	cp -p $(BUILD_FILES) build
	python3 -m zipapp -p "/usr/bin/env python3" -o "$(APP_DIR)/$(APP)" $(BUILD_DIR)

install: $(APP_DIR)/$(APP)
	install -p "$(APP_DIR)/$(APP)" $(INSTALL_DIR)

uninstall: $(INSTALL_DIR)/$(APP)
	rm -f "$(INSTALL_DIR)/$(APP)"

venv:
	bash -c '[ -d venv ] || python3 -m venv venv'
	venv/bin/pip3 install -r requirements.txt
	venv/bin/pip3 install jupyterlab

prepare:
	groupadd odm
	useradd -r -g odm -s /sbin/nologin -c "odm services" odm

service: webodm_cleaner.service webodm_cleaner.timer
	cp webodm_cleaner.service /etc/systemd/system
	cp webodm_cleaner.timer /etc/systemd/system
	systemctl daemon-reload
	systemctl enable webodm_cleaner.service
	systemctl start webodm_cleaner.service
	systemctl enable webodm_cleaner.timer
	systemctl start webodm_cleaner.timer

rmservice:
	systemctl stop webodm_cleaner.timer
	systemctl stop webodm_cleaner.service
	systemctl disable webodm_cleaner.timer
	systemctl disable webodm_cleaner.service
	rm -rf /etc/systemd/system/webodm_cleaner.timer
	rm -rf /etc/systemd/system/webodm_cleaner.service
	systemctl daemon-reload