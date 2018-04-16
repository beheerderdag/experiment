removeOld{
    *home="/$rodsZoneClient/home/$userNameClient/*coll"
    writeLine("stdout",*home);
    foreach(*crow in select DATA_CREATE_TIME, COLL_NAME, DATA_NAME where COLL_NAME like '*home%'){
        *time = double(*crow.DATA_CREATE_TIME);
        # datetime has a bug see iRODS github
        #*ftime = datetimef(*time, "%Y %m %d %H:%M:%S");
        *data = *crow.DATA_NAME;
        *loc = *crow.COLL_NAME;
        writeLine("stdout", "*loc/*data created *time");
        msiHumanToSystemTime(*now, *num_now);
        writeLine("stdout", "Today *num_now");
        # delete if older than a month
        if(*num_now-*time > 2629743){
            writeLine("stdout", "Delete: *loc/*data");
            msiDataObjUnlink("*loc/*data",*status);
        }
     writeLine("stdout", "--------");
     }
}

# coll needs to be relative to home collection
input *coll="test", *now="2018-04-17"
output ruleExecOut
