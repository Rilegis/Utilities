#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# This script will automatically update the server, logging each time this script gets executed
# NOTE #1: Run this script as 'root' or using 'sudo'.
# NOTE #2: Use this script one time per week.
# Ex. Crontab: 0 5 * * 1 auto_update &> /dev/null

########## START USER-EDIT SECTION ##########
# Logfile infos
LOGFILE_LOCATION=/universal/path/to/logfile.log          ## Logfile location
########## STOP USER-EDIT SECTION ###########

####### DO NOT EDIT AFTER THIS POINT ########
# Insert start execution log in 'LOGFILE_LOCATION'
DATE=`date`             ## Get current date-time
echo "[$DATE] 'auto_update' started execution." >> $LOGFILE_LOCATION

apt-get update          ## Update package lists
apt-get full-upgrade -y ## Update currently installed packages
apt-get autoremove -y   ## Perform dependency cleanup

# Insert completed execution log in 'LOGFILE_LOCATION'
DATE=`date`             ## Get current date-time
echo "[$DATE] 'auto_update' completed execution." >> $LOGFILE_LOCATION