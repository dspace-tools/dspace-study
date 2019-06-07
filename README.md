Dspace study
===

This procect intent to study dspace functionalities,
document process and serves to other as a base to study.


# run

```bash
$ docker-compose up
```

And enter in url

[http://localhost:8080/xmlui](http://localhost:8080/xmlui)



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


to export
discovery first the site handle prefix

```bash
$ cat /dspace/config/dspace.cfg | grep 'handle.prefix =' | awk '{ OFS=" "; print $3 }'
```
and will be printed a site prefix


```bash
$ docker exec -it  $(docker ps -aqf "name=dspace6") /dspace/bin/dspace packager -u -d -a -t AIP -e test@test.edu -i <siteprefix>/0 /sitewide-aip-$(date +%Y-%m-%d-%H-%M-%S).zip
```


to restore

```bash
$ /dspace/bin/dspace packager -r -f -a -u -t AIP -e test@test.edu /backups/hp-lovecraft-repo/COMMUNITY\@123456789-1.zip 
```

Fix metadata

```bash
# export metadata to a file
/dspace/bin/dspace metadata-export -a -f /backups/metadata

# replace in files
cat /backups/metadata | sed 's/localhost:8080/medoabsoluto.com.br/g' > /backups/metadata-mod

# import new file
/dspace/bin/dspace metadata-import -f /backups/metadata-mod 
```