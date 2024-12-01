#!/bin/bash

LOCAL_BACKUP_DIR="/mysqldump/daily"

# NFS server details
NFS_SERVER="<server ip>"
NFS_USER="username"
NFS_PATH="/path/to/save"


# Get a list of all databases
#DATABASES=$(mysql -e "SHOW DATABASES;" | grep -Ev "(Database|mysql|performance_schema|information_schema|sys)")

# Loop through each database and create a backup
#for DB_NAME in ${DATABASES}; do
    DB_NAME="test"
    BACKUP_FILE="${LOCAL_BACKUP_DIR}/${DB_NAME}_backup_$(date +%Y%m%d).sql"

    # Dump database without authentication
    mysqldump "${DB_NAME}" > "${BACKUP_FILE}"

    # Compress the backup file
    gzip "${BACKUP_FILE}"

    # Copy to NFS server using scp
   scp -i /root/.ssh/id_rsa -P 8022 "${BACKUP_FILE}.gz" "${NFS_USER}@${NFS_SERVER}:${NFS_PATH}"


# Clean up local backup file
    rm "${BACKUP_FILE}.gz"

    echo "Backup for ${DB_NAME} completed and old files removed."
#done
