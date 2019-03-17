# es-s3-backup
Painless Elasticsearch backup to S3

Elasticsearch automatic backup to S3.

There's also IAM policy example to run shell script from a configured AWS cli environment.

Before you start:

1. be sure you have [AWS cli](https://docs.aws.amazon.com/en_us/cli/latest/userguide/cli-chap-install.html) installed for your envornment and configured with AWS access & secret;
2. be sure to set the right policy on your IAM user to run script;
3. Setup the elasticsearch.yml to register your FS repository path on the PATH section of **elasticsearch.yml**
``path.repo: /home/elasticsearch_backups
``  
and reload the engine with          
``service elasticsearch restart
``  
or equivalent for you OS;
4. Register your backup running 
`` curl -X PUT "localhost:9200/_snapshot/mybackup" -H 'Content-Type: application/json' -d'{"type": "fs","settings": {"location": "/path/to/my/backup/folder","compress": true}}'
``  
5. Modify the script;
6. Enjoy :).