#!/bin/bash

#Backup locations

BACKUPDIR=/var/opt/gitlab/backups
BACKUPLOCATION=/home/ubuntu/backup
CONFIGBACKUP=/etc/gitlab/config_backup/


# NFS server details
NFS_SERVER="<server ip>"
NFS_USER="username"
NFS_PATH="/path/to/save"


#create configuration backup

gitlab-ctl backup-etc

mv $CONFIGBACKUP/*.tar $BACKUPLOCATION
sleep 10

#create repository backup

gitlab-backup create

#move backup to alternate location

mv $BACKUPDIR/*.tar $BACKUPLOCATION

sleep 5

scp -i /root/.ssh/id_rsa -P 8022 "$BACKUPLOCATION/*.tar" "${NFS_USER}@${NFS_SERVER}:${NFS_PATH}"


sleep 5

# Remove backups from gitlab server

rm -f $BACKUPLOCATION/*.tar
