removeDuplicates{
    *home="/$rodsZoneClient/home/$userNameClient/*coll"
    writeLine("stdout",*home);
    # Extract checksums for files in input directory, also retrieve COLL_NAME incase it is a nested collection.
    foreach(*crow in select DATA_CHECKSUM, COLL_NAME, DATA_NAME where COLL_NAME like '*home%'){
         *count = 0;
         *data = *crow.DATA_NAME;
         *loc = *crow.COLL_NAME;
         *csum = *crow.DATA_CHECKSUM;
         writeLine("stdout", "*csum");
         #*num = SELECT count(COLL_NAME) where DATA_CHECKSUM like '*csum';
         #Count how often you found the checksum in the whole iRODS instance, only when having read access
         foreach(*row in select COLL_NAME, DATA_NAME where DATA_CHECKSUM like '*csum'){
             *count = *count + 1;
         }
         writeLine("stdout","*csum for *data found *count times");
         # Delete original file when found somewhere else
         if(*count > 1){
             writeLine("stdout", "Delete: *loc/*data");
             msiDataObjUnlink("*loc/*data",*status);
         }
     writeLine("stdout", "--------");
     }
}

#*coll is the relative path to the iRODS home collection
input *coll="test"
output ruleExecOut
