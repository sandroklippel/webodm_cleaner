# Service rules
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