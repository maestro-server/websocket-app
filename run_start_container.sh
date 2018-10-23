#!/bin/sh

VSECRET=${MAESTRO_SECRETJWT:='defaultSecretKey'}
VAPIPKEY=${MAESTRO_WEBSOCKET_SECRET:='wsSecretKey'}

VADMIN=$CENTRIFUGO_ADMIN
VADSECRET=$CENTRIFUGO_ADMIN_SECRET
VADMIN=${VADMIN:='-'}
VADSECRET=${VADSECRET:='-'}

jq -n\
 --arg secret $VSECRET\
 --arg api_key $VAPIPKEY\
 --arg admin_password $VADMIN\
 --arg admin_secret $VADSECRET\
 '{"secret":$secret, "api_key":$api_key, "admin_password":$admin_password, "admin_secret":$admin_secret}' > /config.json

if [ -z ${CENTRIFUGO_ADMIN} ] && [ -z ${CENTRIFUGO_ADMIN_SECRET} ]; 
    then 
        centrifugo -c /config.json
    else
        echo "Centrifugo Admin UP";
        centrifugo -c /config.json --admin
fi