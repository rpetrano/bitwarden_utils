install:
	install -o root         -g root         -m 644 bitwarden_backup.service /etc/systemd/system/
	install -o root         -g root         -m 644 bitwarden_backup.timer   /etc/systemd/system/
	install -o root         -g root         -m 640 default                  /etc/default/bitwarden_backup
	install -o bitwarden_rs -g bitwarden_rs -m 750 bitwarden_backup.sh      /usr/local/bin/

	@echo
	@echo Done!
	@echo To enable the backup, run:
	@echo systemctl daemon-reload
	@echo systemctl enable --now bitwarden_backup.timer

uninstall:
	rm -f /etc/systemd/system/bitwarden_backup.service
	rm -f /etc/systemd/system/bitwarden_backup.timer
	rm -f /etc/default/bitwarden_backup
	rm -f /usr/local/bin/bitwarden_backup.sh

	systemctl disable bitwarden_backup.timer
