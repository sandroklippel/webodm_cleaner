# Installation rule
install: $(APP_DIR)/$(APP)
	install -u -p "$(APP_DIR)/$(APP)" $(INSTALL_DIR)
	install -u -p -m 0440 -o odm -g odm $(CONFIG_FILE) $(CONFIG_DIR)

uninstall: $(INSTALL_DIR)/$(APP)
	rm -f "$(INSTALL_DIR)/$(APP)"