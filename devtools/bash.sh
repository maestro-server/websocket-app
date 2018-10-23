
VSECRET=${MAESTRO_SECRETJWT:='defaultSecretKey'}
VAPIPKEY=${MAESTRO_WEBSOCKET_SECRET:='wsSecretKey'}

s="secret|api_key|admin_password|admin_secret
${VSECRET}|${VAPIPKEY}|${CENTRIFUGO_ADMIN}|${CENTRIFUGO_ADMIN_PASS}"

jq -Rn '
( input  | split("|") ) as $keys |
( inputs | split("|") ) as $vals |
[[$keys, $vals] | transpose[] | {key:.[0],value:.[1]}] | from_entries
' <<< "$s" > config.json