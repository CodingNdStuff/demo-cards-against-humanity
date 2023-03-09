const mqtt = require('mqtt');
const Deck = require('../card_management/cards');
const clientId = 'mqttjs_server'// + Math.random().toString(16).substr(2, 8);
const host = 'ws://localhost:8080';

var options = {
    keepalive: 30,
    clientId: clientId,
    clean: true,
    reconnectPeriod: 1000,
    connectTimeout: 30 * 1000,
    will: {
        topic: 'willTopic',
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
let cards = new Map();

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

client.on('message', (topic, message) => {
    const playerId = JSON.parse(message);
    _updateLobbyAfterDisconnect(playerId);
});

//
client.subscribe("willTopic");
//

exports.publishEncoded = function (topic, genericObject) {
    if (client.disconnected) throw 500;
    client.publish(topic, JSON.stringify(genericObject, (key, value) => {
        if (typeof value === 'string') {
            return encodeURIComponent(value);
        }
        return value;
    }), { retain: true });
}



const _updateLobbyAfterDisconnect = function (playerId) {
    // for (let [lobbyId, lobby] of lobbies) {
    //     let playerIndex = lobby.players.findIndex(player => player.id === playerId);
    //     if (playerIndex !== -1) {
    //         lobby.players.splice(playerIndex, 1);
    //         if (lobby.players.length === 0) {
    //             lobbies.delete(lobbyId);
    //         }
    //         client.publish(lobbyId, "", { retain: false });
    //         return lobbyId;
    //     }
    // }
    console.log("user $playerId disconnected");
}