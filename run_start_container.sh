#!/bin/sh

VSECRET=${MAESTRO_SECRETJWT:='defaultSecretKey'}
VAPIPKEY=${MAESTRO_WEBSOCKET_SECRET:='wsSecretKey'}

VADMIN=$CENTRIFUGO_ADMIN
VADSECRET=$CENTRIFUGO_ADMIN_SECRET
VADMIN=${VADMIN:='-'}
VADSECRET=${VADSECRET:='-'}

TLSPORT=${CENTRIFUGO_TLS_PORT:=':80'}

TLSKEY=${CENTRIFUGO_TLS_KEY:='"/tmp/certs/server.key"'}
TLSCERT=${CENTRIFUGO_TLS_CERT:='"/tmp/certs/server.crt"'}

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
        TMPJ=$(jq '.tls_autocert=true | .tls_autocert_cache_dir = "\/tmp\/certs"' $CWPATH)
        echo $TMPJ > $CWPATH
fi

if [ -z ${CENTRIFUGO_TLSAUTO_HTTP} ];
    then
        echo "-> TlsAuto HTTP disabled"
    else
        echo "-> TlsAuto HTTP enabled"
        TMPJ=$(jq --arg port $TLSPORT '.tls_autocert=true | .tls_autocert_cache_dir = "\/tmp\/certs" | .tls_autocert_http=true | .tls_autocert_http_addr=$port ' $CWPATH)
        echo $TMPJ > $CWPATH
fi

if [ -z ${CENTRIFUGO_TLS} ];
    then
        echo "-> Custom TLS disabled"
    else
        echo "-> Custom TLS enabled"
        TMPJ=$(jq ".tls=true | .tls_key=$TLSKEY | .tls_cert=$TLSCERT" $CWPATH)
        echo $TMPJ > $CWPATH
fi

if [ -z ${CENTRIFUGO_ADMIN} ] && [ -z ${CENTRIFUGO_ADMIN_SECRET} ]; 
    then 
        centrifugo -c $CWPATH
    else
        echo "-> Centrifugo Admin UP";
        centrifugo -c $CWPATH --admin
fi