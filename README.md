# VSFTPD Server in a Docker

This vsftpd docker image is based on official CentOS 7 image and comes with following features:  

  * Virtual users
  * Passive mode (`ports 21100-21110`)
  * Logging to a file or STDOUT
  * Anonymous account access (defined by user on docker run `true/false`)

### Environmental Variables

|LOG_STDOUT||
|---|---|
|Default:|`LOG_STDOUT=false`|
|Accepted values:|`true` or `false`|
|Description:|Output vsftpd log through STDOUT, so that it can be accessed through the [container logs](https://docs.docker.com/reference/commandline/logs/).|

|ANONYMOUS_ACCESS||
|---|---|
|Default:|`ANONYMOUS_ACCESS=false`|
|Accepted values:|`true` or `false`|
|Description:|Grants access to user `anonymous` need to have access to files in `/var/ftp/pub` directory.|

|UPLOADED_FILES_WORLD_READABLE||
|---|---|
|Default:|`UPLOADED_FILES_WORLD_READABLE=false`|
|Accepted values:|`true` or `false`|
|Description:|Changes the permmissions of uploaded files to `rw- r-- r--`. This makes files readable by other users.|

| PASV_MIN_PORT & PASV_MAX_PORT ||
|-------------------------------|---|
| Default:                      ||
| Accepted values:              |`port number`|
| Description:                  |Passive Mode Port Numbers|

Passive Mode Port Numbers

|CUSTOM_PASSIVE_ADDRESS||
|---|---|
|Default:|`CUSTOM_PASSIVE_ADDRESS=false`|
|Accepted values:|`ip address` or `false`|
|Description:|Passive Address that gets advertised by vsftpd when responding to PASV command. This is useul when running behind a proxy, or with docker swarm.|


### Basic usage

    docker run \
      --name vsftpd \
      -d \
      elastic2ls/vsftp

example output of `docker logs vsftpd`

```
[VSFTPD 11:00:46] Created home directory for user: alex
[VSFTPD 11:00:46] Updated /etc/vsftpd/virtual_users.txt
[VSFTPD 11:00:46] Updated vsftpd database
[VSFTPD 11:00:46] Fixed permissions for newly created user: alex
[VSFTPD 11:00:46] VSFTPD daemon starting
```

### Custom usage

    docker run \
      --name vsftpd \
      -d \
      -e USERS=1000 upload|PASSWORD1|/opt/ftp/shared/ \
      -e ANONYMOUS_ACCESS=false \
      -p 20-21:20-21 \
      -p 21100-21110:21100-21110 \
      elastic2ls/vsftpd

example output of `docker logs vsftpd`

```
[VSFTPD 11:04:43] Enabled access for anonymous user.
[VSFTPD 11:04:43] Created home directory for user: upload
[VSFTPD 11:04:43] Updated /etc/vsftpd/virtual_users.txt
[VSFTPD 11:04:43] Updated vsftpd database
[VSFTPD 11:04:43] Fixed permissions for newly created user: upload
[VSFTPD 11:04:43] VSFTPD daemon starting
```

Docker troubleshooting
======================

Use docker command to see if all required containers are up and running:
```
$ docker ps
```

Check logs of docker container:
```
$ docker logs vsftpd
```

Sometimes you might just want to review how things are deployed inside a running
 container, you can do this by executing a _bash shell_ through _docker's
 exec_ command:
```
docker exec -ti vsftpd /bin/bash
```