#!/bin/bash

# Set the date
date=$(date +"%Y%m%d-%H%M")

# Backup location on your fs - Pay attention, you have to register repository via elasticsearch.yml properties path.repo["/path/to/my/backup/folder"]
# *** MODIFY HERE ***
backup_location='/path/to/my/backup/folder'

# Backup name registered
# *** MODIFY HERE ***
repository_name='mybackup'

# tar folder - used to crate tar.gz of the files
# *** MODIFY HERE ***
tar_directory='/path/to/my/targz-folder'

echo ------ Starting job $date ------

# S3 bucket name
# *** MODIFY HERE ***
full_s3_path="s3://myBucket/"

echo 'Producing backup...'

# Set the location of where backups will be stored
backup_name="snapshot-${date}"
backup_full_name="${backup_location}/${backup_name}"
tar_full_name="${backup_name}.tar.gz"


curl -X PUT "localhost:9200/_snapshot/${repository_name}/${backup_name}?wait_for_completion=true"

echo 'Backup complete with full path ->'$backup_full_name

# Set a value to be used to find all backups with the same name
find_backup_name="${tar_directory}/${backup_name}*.gz"
# Delete files older than the number of days defined
find $find_backup_name -mtime +$days -type f -delete

echo 'Deletion complete'

echo 'Making tar...'
tar -czvf ${tar_directory}/${tar_full_name} ${backup_location}/*

echo Starting copy $tar_full_name to $full_s3_path

# Setup the right policy to profile to PUT object on the specific bucket and modify the profile name
# *** MODIFY HERE ***
aws s3 cp ${tar_directory}/$tar_full_name $full_s3_path --profile myprofile
echo Completed S3 upload on $full_s3_path

echo -e "------ completed job $date ------\n\n"
