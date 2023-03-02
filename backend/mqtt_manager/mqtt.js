const mqtt = require('mqtt');
const { map } = require('..');
const clientId = 'mqttjs_server'// + Math.random().toString(16).substr(2, 8);
const host = 'ws://localhost:8080';

var options = {
    keepalive: 30,
    clientId: clientId,
    clean: true,
    reconnectPeriod: 1000,
    connectTimeout: 30 * 1000,
    will: {
        topic: 'WillMsg',
        payload: 'Server Connection Closed abnormally..!',
        qos: 0,
        retain: false
    },
    rejectUnauthorized: false
}

console.log('connecting mqtt server');
const client = mqtt.connect(host, options);


//-----------------


let lobbies = new Map();

client.on('error', function (err) {
    console.log(err);
    client.end();
})

client.on('connect', async function () {
    console.log('server connected:' + clientId);
})

client.on('close', function () {
    console.log(clientId + ' server disconnected');
})

exports.createLobby = function (id, nickname, roundDuration, maxRoundNumber) {
    // const newLobbyId = _generateUniqueId(lobbies)
    const newLobbyId = "4jjjnpe6"
    const newLobby = {
        "open" : true,
        "roundDuration": roundDuration,
        "maxRoundNumber": maxRoundNumber,
        "currentRound": 0,
        "currentBlackCard": null,
        "players": [
            {
                "id": id,
                "nickname": nickname,
                "ready":false,
            },
        ],
    }
    lobbies.set(newLobbyId , newLobby );
    console.log(lobbies.get("4jjjnpe6"))
    client.publish(newLobbyId, JSON.stringify(lobbies.get(newLobbyId)), {retain:true});
    return newLobbyId;
}
exports.setPlayerReady=function(lobbyId, playerId){
    found=false;
    if(lobbies.get(lobbyId)==undefined) return;
    lobbies.get(lobbyId).players.forEach(element => {
        if(found) return;
        if(element.id==playerId){
            element.ready=true;
            found=true;
        }
    });
    if(!found) return;
    client.publish(lobbyId, JSON.stringify(lobbies.get(lobbyId)), {retain:true});
    // lobbies.set(lobbyId)
}

exports.joinLobby=function(lobbyId, playerId, nickname){
    console.log(lobbies.get(lobbyId))
    if(lobbies.get(lobbyId)==undefined) return;
    lobbies.get(lobbyId).players.push({
        "id": playerId,
        "nickname": nickname,
        "ready":false,
    });
    client.publish(lobbyId, JSON.stringify(lobbies.get(lobbyId)), {retain:true});
    console.log("added "+nickname);
    console.log(lobbies.get(lobbyId))
}

const _generateUniqueId = function (list) {
    const idLength = 8; // the length of the generated id
    let newId;

    // loop until a unique id is generated
    do {
        // generate a random string of alphanumeric characters
        newId = Math.random().toString(36).substr(2, idLength);
    } while (list.some(item => item.id === newId));

    return newId;
}