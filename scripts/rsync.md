```shell
rsync --archive --acls --xattrs --hard-links --sparse --one-file-system \
--delete --delete-excluded --numeric-ids --progress --info=progress2 \
--human-readable --exclude-from=root.exclude --exclude=__pycache__
```
