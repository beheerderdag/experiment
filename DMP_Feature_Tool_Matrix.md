### Data Management platform features and evaluation criterion


The goal of this table is to evaluate various tools that can be part of our data management platform solution. NOTE: the 
comparison is baesd on various functions and features that we encountered in research data management ecosystem. This is not 
a product review or feature comparison. We are trying to highligh the various components and strengths of each tool. Each 
use case and research data management need are unique and requires various customizations. 

We also have the following data management platform (DMP) features in mind: 

* One entry point to many storage services and data services
* Usable interface to compute services, policies defining and tracking data transitions
* Support for (automated) execution of data policies which define workflows and behaviour of data and users
* Data sharing of data between users of the Data Management Platform
* Policies and interfaces to share data with external users (secure, private) 
* Well defined transition between data storage locations and data application environments such as compute environments
* Well defined transition between active data and archived or published data

Software/tools that we are currently evaluating/researching. We do not have first hand experience with all of these so 
the notes and evaluation here are limited and based on our experience. 

1. [iRODS](https://irods.org/) 
Used for data virtualization, federation, discovery (from variety of storage resources), workflow automation via policy engine. 
2. [Denodo](https://www.denodo.com/en) 
Creates data virtualization layer by connecting various  structured data sources. Provides  unified access for consuming applications.
3. [CKAN](https://ckan.org/) 
Data portal, repository
4. [Figshare](https://figshare.com/) 
Digital repository 
5. [Immuta](https://www.immuta.com/) 
Focused on big data and data science applications (provides data management and portal solution) 
6. [Metadata Management for Applied Sciences (MASi)](https://www.sciencedirect.com/science/article/pii/S0167739X17305344) 
7. [Starfish](http://www.starfishstorage.com/) 
8. [StrongLink](https://www.strongboxdata.com/stronglink) 
9. [Clowder](https://clowder.ncsa.illinois.edu/) 






|                                | iRODS                                                                                                                                                         | Denodo                                                                                                                                  | CKAN                        | Figshare                  | Immuta                                                                                                                                                        | MASi                                | Starfish                                            | StrongLink                                                              |
|--------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|-----------------------------|---------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|-----------------------------------------------------|-------------------------------------------------------------------------|
| Description/Common usage       | Used for data virtualization, federation, discovery (from variety of storage resources),  workflow automation via policy engine.                              | Creates data virtualization layer by connecting various  structured data sources. Provides  unified access for consuming applications.  | Data portal  and repository | Digital Repository        | Similar to Denodo. Creates a virtual  layer for various data source and datasets.  Provides API to applications.  This also has a policy  enforcement point.  | Repository and  Metadata Management | Most similar  to iRODS.  provides a  middle layer.  | Combines  data virtualization,  metadata management,  with a AI layer.  |
| Open Source                    | Yes                                                                                                                                                           | No but  a free community version is available                                                                                           | Yes                         | No. Also  service based.  |                                                                                                                                                               |                                     | No                                                  | No                                                                      |
| Architecture/Infrastructure    | C++ source, SQL database backend                                                                                                                              | Java                                                                                                                                    |                             |                           |                                                                                                                                                               |                                     |                                                     |                                                                         |
| Metadata management            |                                                                                                                                                               |                                                                                                                                         |                             |                           |                                                                                                                                                               | METS                                |                                                     |                                                                         |
| Policy Enforcement             | Yes via iRODS rule  engine                                                                                                                                    | ?                                                                                                                                       |                             |                           | yes                                                                                                                                                           |                                     |                                                     |                                                                         |
| Layers  (data access, integration)  | Various plugin interfaces that are configurable can access various storage backends.,Data access is given by the iRODS native protocol and a commandline tool |                                                                                                                                         |                             |                           |                                                                                                                                                               |                                     |                                                     |                                                                         |
| Sharing/Publication            | Metalnx/YODA/iRODS ticket system/iRODS anonymous                                                                                                              |                                                                                                                                         |                             |                           |                                                                                                                                                               |                                     |                                                     |                                                                         |
| Processing and analysing tools |                                                                                                                                                               |                                                                                                                                         |                             |                           |                                                                                                                                                               |                                     |                                                     |                                                                         |
| Graphical Interface            | Not in the core  software. But can  used with YODA,  MetaLnx, WEBDAV.                                                                                         | Yes (java based  admin GUI and web  based user interface)                                                                               | Yes                         | Yes                       | Yes                                                                                                                                                           |                                     |                                                     |                                                                         |
