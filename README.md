# minecraft-server-worlds-backup
Shell script to back up worlds from a minecraft server into zip file. Optionally upload the backup zip archive to a webDAV server.

## Dependencies
- zip
- curl (only if using WebDAV to upload zip archive)

## Basic Usage
```
./backup.sh -s <Server Root> -o <Output location>
```
### -s (server)
Locate minecraft server root, if not given, the script defaults to search current directory for ```world, world_nether, world_the_end```.
### -o (output)
Specify the output directory of the zip archive, if not given, the script will create ```world_backup``` directory and put the zip file there.

## WebDav Upload
To use to WebDAV upload feature, set following environment variables:

### ```MC_BACKUP_WEBDAV_ADRESS```
The Adress where zip file will be uploaded to.
The script will start the uploading process if this variable is set.

```export MC_BACKUP_WEBDAV_ADRESS="<Adrress>"```

Example

```export MC_BACKUP_WEBDAV_USER="https://my-webdav-server.com/backup"```

### ```MC_BACKUP_WEBDAV_USER```

The username of WebDAV server user.

```export MC_BACKUP_WEBDAV_USER="<username>"```

Example

```export MC_BACKUP_WEBDAV_USER="user1"```

### ```MC_BACKUP_WEBDAV_PASSWORD```

The password for the given WebDAV server user.

```export MC_BACKUP_WEBDAV_PASSWORD="<password>"```

Example

```export MC_BACKUP_WEBDAV_USER="password"```
