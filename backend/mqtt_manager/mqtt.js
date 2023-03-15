const mqtt = require('mqtt');
const Deck = require('../card_management/cards');
const core = require('../core');
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
    _updateLobbyAfterDisconnect(message);
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

exports.publishEncodedNoRetain = function (topic, genericObject) {
    if (client.disconnected) throw 500;
    client.publish(topic, JSON.stringify(genericObject, (key, value) => {
        if (typeof value === 'string') {
            return encodeURIComponent(value);
        }
        return value;
    }), { qos:0, retain: false });
}

exports.publishEmpty = function (topic) {
    if (client.disconnected) throw 500;
    client.publish(topic, null , { retain: true });
}



const _updateLobbyAfterDisconnect = function (message) {
    let [lobbyId, playerId] = JSON.parse(message).split("/");
    console.log("user "+playerId+" disconnected from lobby "+lobbyId); //to be removed
    core.handleDisconnection(lobbyId, playerId);
}