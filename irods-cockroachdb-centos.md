Install instruction for setting up the irods cockroachdb database plugin. 
https://github.com/irods/irods_database_plugin_cockroachdb

I am using a clean centos7 VM. This is with iRODS 4.2.3. 

## Prerequisite

If the installation does not come with dev tools install, 
``` yum groupinstall development tools``` 

NOTE: Get rid of system clang, cmake, and boost if they exist. The irods external package will provide this. 

## Install packages 
```
# yum install git 
# Install the public key and add the repository:
rpm --import https://packages.irods.org/irods-signing-key.asc
wget -qO - https://packages.irods.org/renci-irods.yum.repo | tee /etc/yum.repos.d/renci-irods.yum.repo

# yum install irods-server irods-devel irods-externals*

# yum install ninja-build python-devel
# yum install openss-devel 
# yum install unixODBC unixODBC-devel
```
This also requires some postgres package 
```
# yum install postgresql postgresql-devel postgresql-odbc.
```

## Build process 

Make sure we are using the irods cmake 

```
export PATH=/opt/irods-externals/cmake3.5.2-0/bin/:$PATH 
```


First we need to build irods_api_bulkreg_common 

```
git clone https://github.com/xu-hao/irods_api_bulkreg_common
```
Update CMakeLists.txt to the correct iRODS version (the git file has 4.3.0 dev version) 


```
find_package(IRODS 4.2.3 EXACT REQUIRED)
```

Then 
```
cd irods_api_bulkreg_common
mkdir build
cd build 
cmake .. -GNinja
```

If everything goes well you should see this 

```
-- Build files have been written to: /root/irods_api_bulkreg_common/build
```

Then build the package (in Centos it is ninja-build) 

```
root@145 build]# ninja-build package
[0/1] Run CPack packaging tool...
CPack: Create package using RPM
CPack: Install projects
CPack: - Install project: irods-api-plugin-bulkreg-common
CPack: Create package
CMake Warning (dev) at /opt/irods-externals/cmake3.5.2-0/share/cmake-3.5/Modules/CPackRPM.cmake:667 (list):
  Policy CMP0007 is not set: list command no longer ignores empty elements.
  Run "cmake --help-policy CMP0007" for policy details.  Use the cmake_policy
  command to set the policy and suppress this warning.  List has value = [
  ;].
Call Stack (most recent call first):
  /opt/irods-externals/cmake3.5.2-0/share/cmake-3.5/Modules/CPackRPM.cmake:1505 (cpack_rpm_prepare_content_list)
  /opt/irods-externals/cmake3.5.2-0/share/cmake-3.5/Modules/CPackRPM.cmake:1787 (cpack_rpm_generate_package)
  
This warning is for project developers.  Use -Wno-dev to suppress it.

CPackRPM: Will use GENERATED spec file: /root/irods_api_bulkreg_common/build/_CPack_Packages/Linux/RPM/SPECS/irods-api-plugin-bulkreg-common.spec
CPack: - package: /root/irods_api_bulkreg_common/build/irods-api-plugin-bulkreg-common-4.2.3-1.x86_64.rpm generated.
```

Now we can build the irods_database_plugin_cockroachdb
(again update the CMakeLists after the git clone to change iRODS version) 

```
git clone https://github.com/irods/irods_database_plugin_cockroachdb.git
cd irods_database_plugin_cockroachdb
mkdir build
cd build 
cmake .. -GNinja
ninja-build package
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/irods-externals/clang-runtime3.8-0/lib/


```

If no error you should see the rpm package. 


## Rpm install 

```
[root@145 build]# rpm -ivh irods-database-plugin-cockroachdb-4.2.3-1.x86_64.rpm 
Preparing...                          ################################# [100%]
Updating / installing...
   1:irods-database-plugin-cockroachdb################################# [100%]

=======================================================================

iRODS Postgres Database Plugin installation was successful.

To configure this plugin, the following prerequisites need to be met:
 - an existing database user (to be used by the iRODS server)
 - an existing database (to be used as the iCAT catalog)
 - permissions for existing user on existing database

Then run the following setup script:
  sudo python /var/lib/irods/scripts/setup_irods.py

=======================================================================
```

NOTE: yes, it says postgres but it is for cockroachdb. 


At this point we have the necessary irods component installed including the two plugins we just built 

```
[root@145 ~]# rpm -qa|grep irods|grep plugin
irods-api-plugin-bulkreg-common-4.2.3-1.x86_64
irods-database-plugin-cockroachdb-4.2.3-1.x86_64
```

Now, we need to install cockroachdb. 

## Cockroachdb install 

```
wget -qO- https://binaries.cockroachdb.com/cockroach-v2.0.4.linux-amd64.tgz | tar  xvz
cp -i cockroach-v2.0.4.linux-amd64/cockroach /usr/local/bin
```


## Insecure mode start 

At the moment we can test with insecure mode (iRODS consortium is working on fixing the code so we can us secure mode in 
cockroachdb: https://github.com/irods/irods_database_plugin_cockroachdb/issues/7) 

```

# cockroach start --insecure --background 
*
* WARNING: RUNNING IN INSECURE MODE!
* 
* - Your cluster is open for any client that can access <all your IP addresses>.
* - Any user, even root, can log in without providing a password.
* - Any user, connecting as root, can read or write any data in your cluster.
* - There is no network encryption nor authentication, and thus no confidentiality.
* 
* Check out how to secure your cluster: https://www.cockroachlabs.com/docs/v2.0/secure-a-cluster.html
*
 
# CockroachDB node starting at 2018-07-20 12:31:56.247401226 +0000 UTC (took 2.0s)
build:               CCL v2.0.4 @ 2018/07/16 20:25:32 (go1.10)
admin:               http://xxxxx.nl:8080
sql:                 postgresql://root@1xxxxx.surf-hosted.nl:26257?sslmode=disable
logs:                /data/cockroach-data/logs
temp dir:            /data/cockroach-data/cockroach-temp721572895
external I/O path:   /data/cockroach-data/extern
store[0]:            path=/data/cockroach-data
status:              initialized new cluster
clusterID:           d4d0acc1-d88c-4bdd-bfba-9b63c02897d7
nodeID:              1
```

check the node stat 

```
cockroach node status --insecure
```

This should give you a sql prompt. 
```
cockroach sql --insecure 
``` 

then create the icat database, irods user, grant permission. 

```
  create database icat; 
  create user irods ; 
  grant all on database icat to irods;
  ```
  

## Secure mode start 
(for later) 


```
 mkdir certs
 mkdir my-safe-directory
 cockroach cert create-ca --certs-dir=certs --ca-key=my-safe-directory/ca.key
 cockroach cert create-client root --certs-dir=certs --ca-key=my-safe-directory/ca.key
 cockroach cert create-node localhost $(hostname) --certs-dir=certs --ca-key=my-safe-directory/ca.key
 cockroach start --certs-dir=certs --host=localhost --http-host=localhost
```

SQL command line 
```
 cockroach sql --certs-dir=certs
 create database icat; 
  create user irods with password '<pass>>'
  grant all on database icat to irods;
 ```
 
 Now we are ready to run the irods setup script. 
 ## Run irods setup 
 
 This is your regular iRODS setup with cockroachdb information. Two caveats. a) For the ODBC driver select default PostgreSQL and b) when asked for db username and password just provide a bogus password. This is because of aforementioned issue with secure mode. 
 
 ```
 +-----------------------------------------+
| Configuring the database communications |
+-----------------------------------------+

You are configuring an iRODS database plugin. The iRODS server cannot be started until its database has been properly configured.

ODBC driver for cockroachdb [PostgreSQL]: 
Database server's hostname or IP address [localhost]: 
Database server's port [26257]: 
Database name [ICAT]: icat
Database username [irods]: 

-------------------------------------------
Database Type: cockroachdb
ODBC Driver:   PostgreSQL
Database Host: localhost
Database Port: 26257
Database Name: icat
Database User: irods
-------------------------------------------

```

If the installation is done right the setup script will recognize the cockroachdb setup and fill in the port information. And rest of inputs are here: https://github.com/irods/irods_database_plugin_cockroachdb/blob/master/packaging/localhost_setup_cockroachdb.input


then run iinit to use the irods client (server is localhost). 

# Quick perf test 

With 100k small files
```
mkdir 100k 
cd 100k 
dd if=/dev/zero of=masterfile bs=1 count=1000000
split -b 10 -a 11 masterfile
```
then iput with bulk (capture time) 

```
[root@145 data]# /usr/bin/time iput -rb -v 100k/
C- /tempZone/home/rods/100k:
C- /tempZone/home/rods/100k:
Bulk upload 50 files.
   xaaaaaaaaabx                    0.000 MB | 3.002 sec | 0 thr |  0.000 MB/s
Bulk upload 50 files.
   xaaaaaaaaadv                    0.000 MB | 2.627 sec | 0 thr |  0.000 MB/
   ````
   
