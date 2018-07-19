Install instruction for setting up the irods cockroachdb database plugin. 
https://github.com/irods/irods_database_plugin_cockroachdb

I am using a clean centos7 VM. This is with iRODS 4.2.3. 

## Prerequisite

If the installation does not come with dev tools install, 
``` yum groupinstall development tools``` 

NOTE: Get rid of system clang, cmake, and boost if they exist. The irods external package will provide this. 

## Install packages 
````
# yum install git 

# yum install irods-server irods-devel irods-externals*

# yum install ninja-build 
# yum install openss-devel 
# yum install unixODBC unixODBC-devel
````
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
```

If no error you should see the rpm package. 
