#!/bin/bash -e

# Cups PDF docker volume setup
chmod 777 /var/spool/cups-pdf/ANONYMOUS
chown root:lpadmin /var/spool/cups-pdf/ANONYMOUS

# Set user "admin" passsword
echo -e "${ADMIN_PASSWORD}\n${ADMIN_PASSWORD}" | passwd admin

# Do stuff
if [ ! -f /etc/cups/cupsd.conf ]; then
  cp -rpn /etc/cups-skel/* /etc/cups/
fi

exec "$@"