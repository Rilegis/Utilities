#!/bin/sh

# DISCLAIMER: THIS IS A WORK IN PROGRESS SCRIPT, IT IS NOT MEANT TO BE USED IN PRODUCTION, YET.

########## START USER-EDIT SECTION ##########
SOURCE_LOCATION=/usr/data/mc_server                     ## Source directory (IMPORTANT: Path without trailing '/')
BACKUP_LOCATION=/usr/data/backups                       ## Backup directory (IMPORTANT: Path without trailing '/')
BACKUP_RETAIN_DAYS=15                                   ## Number of days to keep local tarball archives
########## STOP USER-EDIT SECTION ###########

####### DO NOT EDIT AFTER THIS POINT ########
while true
do
  # Sleep for 30 minutes......why am i even commenting this?
  echo [`date`] "Waiting 30m for next backup execution..."
  sleep 30m
  echo [`date`] "Backup in progress..."

  # Create a filename suffix
  FILENAME_SUFFIX=`date +%F-%H-%M`

  # Execute server backup
  mkdir -p $BACKUP_LOCATION/mc_server # Make sure the backup location exists
  rsync -a --delete $SOURCE_LOCATION/ $BACKUP_LOCATION/mc_server # Generates a synced backup

  # Archive synced backup into tarball for redundancy
  tar -czf mc_server_$FILENAME_SUFFIX.tar.gz $BACKUP_LOCATION/mc_server

  # Delete tarballs archives that are older than 'BACKUP_RETAIN_DAYS' days
  find $BACKUP_LOCATION -type f  -name "mc_server_*.tar.gz" -mtime +$BACKUP_RETAIN_DAYS -exec rm {} \;

  echo [`date`] "Backup completed."
done