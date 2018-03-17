<h3>How does irods handle silent file corruption?

<h4> Create a test file </h4>

```
$ dd if=/dev/urandom of=file.img bs=1M count=10
10+0 records in
10+0 records out
10485760 bytes (10 MB) copied, 2.09992 s, 5.0 MB/s
```

Upload the file in demoResc with checksum verification 
```
$ iput -Kv -R demoResc file.img
   file.img                       10.000 MB | 0.210 sec | 0 thr | 47.687 MB/s
   
   $ ils -L file.img
  testuser              0 demoResc     10485760 2018-03-16.11:04 & file.img
    75e7238f29718e3ab0f562f24b059b21    generic    /var/irods/Vault/home/testuser/file.img
```

Replication this file to another resource 

```
$ irepl -vR demoResc1 /SURFsaraTest01Zone/home/testuser/file.img
   file.img                       10.000 MB | 0.152 sec | 3 thr | 65.583 MB/s
 ```
  
We check the file --- the checksum matches. 
  
```  
$ ils -L file.img
  testuser              0 demoResc     10485760 2018-03-16.11:04 & file.img
    75e7238f29718e3ab0f562f24b059b21    generic    /var/irods/Vault/home/testuser/file.img
  testuser              1 DeomResc1    10485760 2018-03-16.11:05 & file.img
    75e7238f29718e3ab0f562f24b059b21    generic    /Cache/Vault/DemoResc1/home/testuser/file.img 
```
   
  To simulate file corrupton/bitroot as root user do the following. Here we are corrupting one of the replicas 
  by writing 128k of bad data 
  ```
    dd seek=5k if=/dev/zero of=/Cache/Vault/DemoResc1/home/testuser/file.img bs=1k count=128 conv=notrunc
  ```
    
  After this write the checksum of the file in the physical location changed: 
  
  ```
  root# md5sum /Cache/Vault/DemoResc1/home/testuser/file.img 
d4b1b46daa6b56a5fd128e3c7f67fddd  file.img
````
 Now check the status in irods. The corrupted file was the replica in DemoResc1. But the ICAT does not know about this 
 corruption as it stored the original checksum. 
 
  ```
  $ ils -L file.img
  perf              0 demoResc     10485760 2018-03-16.11:04 & file.img
    75e7238f29718e3ab0f562f24b059b21    generic    /var/irods/Vault/home/perf/file.img
  perf              1 PerfResc     10485760 2018-03-16.11:05 & file.img
    75e7238f29718e3ab0f562f24b059b21    generic    /eudatCache/Vault/PerfResc/home/perf/file.img
   ```
   
   Now via iget we try to download the file 
   
   ```
   $ iget -K file.img file.rot
   ```
   Thus gets us the file from demoResc which is not corrupted, the download is successful. However, if we try to get the file from *DemoResc1* we receive this:
   
   ```
  iget -K file.img file.rot -R DemoResc1 -f
  remote addresses: 127.0.0.1 ERROR: rcDataObjGet: checksum mismatch error for file.rot, status = -314000 status = -314000 USER_CHKSUM_MISMATCH
  remote addresses: 127.0.0.1 ERROR: getUtil: get error for file.rot status = -314000 USER_CHKSUM_MISMATCH
   ```


Without the verification it will download the data. Let's pick the corrupt one 
```
iget -v -R DemoResc1 /SURFsaraTest01/home/perf/file.img file.rot
   file.img                       10.000 MB | 0.078 sec | 0 thr | 128.936 MB/s
 ```
 
 Compare with my original local file 
 
 ```
$ md5sum file.rot 
d4b1b46daa6b56a5fd128e3c7f67fddd  file.rot

$ md5sum file.img 
75e7238f29718e3ab0f562f24b059b21  file.img
```

## Other commands to retrieve and write data
- *irsync* shows the same behaviour as *iget*. If used with the -K flag rotten data will not be synchronised
- *irepl*: This command poses a problem. We can define our rotten resource as source resource and replicate to all other resources or, even worse, use this one to update all other replicas. The command does not come with a *-K* option to first force checksunm verfication.
 ```sh
 irepl -S iarchive-centosResource -R robin file.img
 ```
## Conclusions
- Whenever possible users should either use the on-the-fly checksum verification when synchronising or downloading data. If that is not possible a more elaborate workflow which hecks the checksum on the destination with the checksum stored in the iCAT needs to be implemeneted.
- The iRODS system itself does not notice when data in the backend is changed. Hence, data intregrity checks on a regular basis between the metadata stored in the iCAT and the backend storage system are needed.
