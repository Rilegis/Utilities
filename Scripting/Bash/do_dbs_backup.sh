#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# This script will automatically backs up every DB from MySQL or MariaDB
# NOTE: Use this script every 6 hours (preferably)
# Ex. Crontab: 0 */6 * * * do_dbs_backup

########## START USER-EDIT SECTION ##########
# Logfile infos
LOGFILE_LOCATION=/universal/path/to/logfile.log          ## Logfile location

# Backup infos
BACKUP_LOCATION=/universal/path/to/backup/location       ## Backup directory
BACKUP_RETAIN_DAYS=15                                    ## Number of days to keep local backup copy

# Login infos
USERNAME=username
PASSWORD=password

USE_SSL=false
SSL_CERTS_LOCATION=/universal/path/to/ssl_certs          ## Location of SSL certificates
SSL_CA=$SSL_CERTS_LOCATION/ca-cert.pem
SSL_CERT=$SSL_CERTS_LOCATION/client-cert.pem
SSL_KEY=$SSL_CERTS_LOCATION/client-key.pem
########## STOP USER-EDIT SECTION ###########

####### DO NOT EDIT AFTER THIS POINT ########
# Insert start execution log in 'LOGFILE_LOCATION'
DATE=`date`             ## Get current date-time
echo "[$DATE] 'do_dbs_backup' started execution." >> $LOGFILE_LOCATION

# Create backup location
mkdir -p $BACKUP_LOCATION

# Get database list
if [ "$USE_SSL" = false ]; then
    OUTPUT=`mysql -u $USERNAME -p$PASSWORD -e "SHOW DATABASES;"`
elif [ "$USE_SSL" = true ]; then
    OUTPUT=`mysql --ssl-ca=$SSL_CA --ssl-cert=$SSL_CERT --ssl-key=$SSL_KEY -u $USERNAME -p$PASSWORD -e "SHOW DATABASES;"`
fi

DATABASES=`echo $OUTPUT | cut -d " " -f2-`

# Foreach database create a backup file
SUFFIX=`date +%F-%H-%M`
if [ "$USE_SSL" = false ]; then
    for DB in $DATABASES
    do
        mkdir $BACKUP_LOCATION/$DB
        mysqldump -u $USERNAME \
            -p$PASSWORD $DB \
            --single-transaction --quick --lock-tables=false > $BACKUP_LOCATION/$DB/$DB-$SUFFIX.sql
    done
elif [ "$USE_SSL" = true ]; then
    for DB in $DATABASES
    do
        mkdir $BACKUP_LOCATION/$DB
        mysqldump --ssl-ca=$SSL_CA \
            --ssl-cert=$SSL_CERT \
            --ssl-key=$SSL_KEY \
            -u $USERNAME \
            -p$PASSWORD $DB \
            --single-transaction --quick --lock-tables=false > $BACKUP_LOCATION/$DB/$DB-$SUFFIX.sql
    done
fi

# Remove files older than 'BACKUP_RETAIN_DAYS' days
for DIRS in $DATABASES
do
    find $BACKUP_LOCATION/$DIRS -type f -mtime +$BACKUP_RETAIN_DAYS -exec rm {} \;
done

# Insert completed execution log in 'LOGFILE_LOCATION'
DATE=`date`             ## Get current date-time
echo "[$DATE] 'do_dbs_backup' completed execution." >> $LOGFILE_LOCATION