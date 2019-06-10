Dspace study
===

This procect intent to study dspace functionalities,
document process and serves to other as a base to study.


# run

```bash
$ docker-compose up
```
# Create Admin User
```
$ /dspace/bin/dspace create-administrator -e fulando@test.com -f fulano -l silva-p xxx -c en
```

# Export & Import
[see more](https://wiki.duraspace.org/display/DSDOC5x/AIP+Backup+and+Restore)
Dspace uses API *(archival information packages)* for import and export format.

You will need combine some sort off commands.
To catch docker id wick dspace application are running:

```bash
$ docker ps -aqf "name=dspace6"
```
and compose with other commands
```bash
$ docker exec -it  $(docker ps -aqf "name=dspace6") 'your command here'
```


## to export
discovery first the site handle prefix

```bash
$ export DSPACE_SITEPREFIX=$(docker exec -it  $(docker ps -aqf "name=dspace6") cat /dspace/config/dspace.cfg | grep 'handle.prefix =' | awk '{ OFS=" "; print $3 }')

```
and will be printed a site prefix


```bash
$ docker exec -it  $(docker ps -aqf "name=dspace6") '/dspace/bin/dspace packager -u -d -a -t AIP -e test@test.edu -i $DSPACE_SITEPREFIX/0 /backups/backup-$(date +%Y-%m-%d-%H-%M-%S).zip'
```


## to restore
First unzip backup desired file
```bash
$ docker exec -it  $(docker ps -aqf "name=dspace6") unzip /backups/backup-2019-06-06.zip -d /tmp/aip
```

run pagacker restore to comunity level
```bash
$ docker exec -it  $(docker ps -aqf "name=dspace6") /dspace/bin/dspace packager -r -f -a -u -t AIP -e test@test.edu /tmp/aip/COMMUNITY\@123456789-1.zip 
```

## Fix metadata in batch
obs.:enter in container and run commands

```bash
mkdir -p /tmp/dspace

# export metadata to a file
/dspace/bin/dspace metadata-export -a -f /tmp/dspace/metadata-orig

# replace hostname in files
sed 's/localhost:8080/medoabsoluto.com.br/g'  /tmp/dspace/metadata-orig > /tmp/dspace/rooted

# remove references of xmlui and jspui (root only)
sed -i 's/medoabsoluto.com.br\/xmlui/medoabsoluto.com.br/g' /tmp/dspace/rooted
sed -i 's/medoabsoluto.com.br\/jspui/medoabsoluto.com.br/g' /tmp/dspace/rooted

# import new file
/dspace/bin/dspace metadata-import -f /tmp/dspace/rooted
```