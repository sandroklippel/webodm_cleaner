# Building rules
requirements: requirements.txt
	rm -rf $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)
	python3 -m pip install -r requirements.txt --target $(BUILD_DIR)

app: $(BUILD_FILES) requirements
	rm -rf $(APP_DIR)
	mkdir -p $(APP_DIR)
	cp -p $(BUILD_FILES) $(BUILD_DIR)
	python3 -m zipapp -p "/usr/bin/env python3" -o "$(APP_DIR)/$(APP)" $(BUILD_DIR)

prepare:
	groupadd odm
	useradd -r -g odm -s /sbin/nologin -c "odm services" odm