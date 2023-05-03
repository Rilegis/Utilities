# Sources:
# https://gitlab.com/ydkn/docker-cups
# https://github.com/olbat/dockerfiles/tree/master/cupsd

# Base image
# See https://hub.docker.com/_/debian/tags for ARCH tags.
ARG ARCH=
FROM $ARCH/debian:testing-slim

# Environmental variables
ENV ADMIN_PASSWORD=admin

# Packages needed for CUPS to run;
# Includes CUPS itself, a lot of printer drivers and utilities.
RUN apt-get update \
  && apt-get install -y \
  sudo \
  usbutils \
  cups \
  cups-bsd \
  cups-filters \
  foomatic-db-compressed-ppds \
  printer-driver-all \
  openprinting-ppds \
  hpijs-ppds \
  hp-ppd \
  hplip \
  printer-driver-cups-pdf \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Create print user with correct groups and authorizations
RUN adduser \
  --home /home/admin \
  --shell /bin/bash \
  --gecos "admin" \
  --disabled-password admin \
  && adduser admin sudo \
  && adduser admin lp \
  && adduser admin lpadmin

# Disable sudo password checking
RUN echo 'admin ALL=(ALL:ALL) ALL' >> /etc/sudoers

# Enable access to CUPS
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid) \
  && echo "ServerAlias *" >> /etc/cups/cupsd.conf

# Copy /etc/cups for skeleton usage
RUN cp -rp /etc/cups /etc/cups-skel

# Add entrypoint
ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "docker-entrypoint.sh" ]

# Default command
CMD ["cupsd", "-f"]

# Mounted volumes
VOLUME ["/etc/cups"]

# Exposed ports
EXPOSE 631