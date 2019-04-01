CURRENTDIR=`pwd`
     PRIVKEY="$CURRENTDIR/privkey.pem"
     CERTIFICATE="$CURRENTDIR/certificate_only.pem"
     ctype="Content-Type:application/json"

     handledata="<linkL"

     curldata="{\"values\":[{\"index\":100,\"type\":\"HS_ADMIN\",
 \"data\":{\"value\":{\"index\":200,\"handle\":\"0.NA\/20.500.11953\",
        \"permissions\":\"011111110011\",
        \"format\":\"admin\"},\"format\":\"admin\"}},
        {\"index\":1,\"type\":\"url\",
        \"data\":\"$handledata\"}]}"

     PREFIX="MYPREFIX"
     PID_SERVER="https://hdl.handle.net.api/handles"
     CURL="curl"
     SUFFIX="handleXYDFKSFKFJ"


     $CURL -k --key $PRIVKEY --cert $CERTIFICATE -H "$ctype" -H
 'Authorization: Handle clientCert="true"' -X PUT --data "$curldata"
 "$PID_SERVER/$PREFIX/$SUFFIX"
