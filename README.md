# Maestro Server #

Maestro Server is an open source software platform for management and discovery servers, apps and system for Hybrid IT. Can manage small and large environments, be able to visualize the latest multi-cloud environment state.

### Demo ###
To test out the demo, [Demo Online](http://demo.maestroserver.io "Demo Online")


# Maestro Server - WebSocket App #

It's websocket server with restfull hooks, maestro websocket use centrifugo project.

See [Centrifugo project](https://centrifugal.github.io/centrifugo/ "Centrifugo Project") 
                                                        |

## Build Setup

``` bash
# Generate config
docker run maestroserver/websocket-maestro centrifugo genconfig

# Run websocket
docker run -e MAESTRO_WEBSOCKET_SECRET='secret' -e MAESTRO_SECRETJWT='jwttoken' maestroserver/websocket-maestro

# Run centrifugo with admin enabled
docker run -e CENTRIFUGO_ADMIN='pass' -e CENTRIFUGO_ADMIN_SECRET='jwttoken' maestroserver/websocket-maestro
```

## WS Endpoints

Client Acess
``` javascript
var centrifuge = new Centrifuge('ws://{server}/connection/websocket');

centrifuge.subscribe("news", function(message) {
    console.log(message);
});

centrifuge.connect();
```

Backend Acess
``` javascript
import json
import requests

command = {
    "method": "publish",
    "params": {
        "channel": "maestro#${ID-USER}", 
        "data": {
            "notify": { // call notify
                "title": "<string>",
                "msg": "<string>",
                "type": "danger|warning|info|success"
            },
            "event": {
                "caller": "<string>" //custom event on client
            }
        }
    }
}

api_key = "${MAESTRO_WEBSOCKET_SECRET}"
data = json.dumps(command)
headers = {'Content-type': 'application/json', 'Authorization': 'apikey ' + api_key}
resp = requests.post("https://{server}/api", data=data, headers=headers)
print(resp.json())
```


## Websocker app - Architecture

![arch](http://docs.maestroserver.io/en/latest/_images/arch_ws.png)


### Env variables ###

| Env Variables             | Example          | Description                              |
|---------------------------|------------------|------------------------------------------|
| MAESTRO_WEBSOCKET_SECRET  | backSecretToken  | Token to authenticate backends apps      |
| MAESTRO_SECRETJWT         | frontSecretToken | Token to autheticate front end users     |
| CENTRIFUGO_ADMIN          | adminPassword    | Admin password                           |
| CENTRIFUGO_ADMIN_SECRET   | adminSecretToken | Token to autheticate administrator users |


PS: Admin only will be enabled if Centrifugo admin and centrifugo admin secret it's setup. 



### Contribute ###

Are you interested in developing Maestro Server, creating new features or extending them?

We created a set of documentation, explaining how to set up your development environment, coding styles, standards, learn about the architecture and more. Welcome to the team and contribute with us.

[See our developer guide](http://docs.maestroserver.io/en/latest/contrib.html)
