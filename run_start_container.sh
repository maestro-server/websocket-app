#!/bin/sh

VSECRET=${MAESTRO_SECRETJWT:='defaultSecretKey'}
VAPIPKEY=${MAESTRO_WEBSOCKET_SECRET:='wsSecretKey'}

VADMIN=$CENTRIFUGO_ADMIN
VADSECRET=$CENTRIFUGO_ADMIN_SECRET
VADMIN=${VADMIN:='-'}
VADSECRET=${VADSECRET:='-'}

CWPATH="/config.json"

jq -n\
 --arg secret $VSECRET\
 --arg api_key $VAPIPKEY\
 --arg admin_password $VADMIN\
 --arg admin_secret $VADSECRET\
 '{"secret":$secret, "api_key":$api_key, "admin_password":$admin_password, "admin_secret":$admin_secret}' > $CWPATH


if [ -z ${CENTRIFUGO_TLSAUTO} ];
    then
        echo "-> TlsAuto disabled"
    else
        echo "-> TlsAuto enabled"
        TMPJ=$(jq '.tls_autocert=true | .tls_autocert_cache_dir = "\/tmp\/certs" | .tls_autocert_http=true ' $CWPATH)
        echo $TMPJ > $CWPATH
fi

if [ -z ${CENTRIFUGO_DEVTLS} ];
    then
        echo "-> DevTls disabled"
    else
        echo "-> DevTls enabled"
        TMPJ=$(jq '.tls=true | .tls_key="\/tmp\/certs\/server.key" | .tls_cert="\/tmp\/certs\/server.crt"' $CWPATH)
        echo $TMPJ > $CWPATH
fi

if [ -z ${CENTRIFUGO_ADMIN} ] && [ -z ${CENTRIFUGO_ADMIN_SECRET} ]; 
    then 
        centrifugo -c $CWPATH
    else
        echo "-> Centrifugo Admin UP";
        centrifugo -c $CWPATH --admin
fi