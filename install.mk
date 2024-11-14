# Install targets (needs root)

prepare:
	groupadd odm || true
	useradd -r -g odm -s /sbin/nologin -c "odm services" odm || true

install: $(APP_DIR)/$(APP) prepare
	install -p "$(APP_DIR)/$(APP)" $(INSTALL_DIR)
	install -p -m 0440 -o odm -g odm $(CONFIG_FILE) $(CONFIG_DIR)

uninstall: $(INSTALL_DIR)/$(APP)
	rm -f "$(INSTALL_DIR)/$(APP)"