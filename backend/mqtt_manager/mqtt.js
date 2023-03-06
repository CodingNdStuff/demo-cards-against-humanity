const mqtt = require('mqtt');
const CardsList = require('../card_management/cards');
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

exports.createLobby = function (id, nickname, roundDuration, maxRoundNumber) {
    if (client.disconnected) throw 500;
    // const newLobbyId = _generateUniqueId(lobbies)

    const newLobbyId = "4jjjnpe6"
    const newLobby = {
        "status": "open",
        "roundDuration": roundDuration,
        "maxRoundNumber": maxRoundNumber,
        "players": [
            {
                "id": id,
                "nickname": nickname,
                "ready": false,
            },
        ],
    }
    lobbies.set(newLobbyId, newLobby);

    // const blackCardsList= new CardsList();
    cards.set(newLobbyId, new CardsList());
    //
    client.publish(newLobbyId, JSON.stringify(lobbies.get(newLobbyId)), { retain: true });
    return newLobbyId;
}
exports.setPlayerReady = function (lobbyId, playerId) {
    if (client.disconnected) throw 500;
    if (lobbies.get(lobbyId) == undefined) throw 404;
    found = false;
    lobbies.get(lobbyId).players.forEach(element => {
        if (found) return;
        if (element.id == playerId) {
            element.ready = true;
            found = true;
        }
    });
    if (!found) throw 404;
    client.publish(lobbyId, JSON.stringify(lobbies.get(lobbyId)), { retain: true });
    if (_checkAllReady(lobbyId)) _startGame(lobbyId);
}

exports.joinLobby = function (lobbyId, playerId, nickname) {
    if (client.disconnected) throw 500;
    if (lobbies.get(lobbyId) == undefined) throw 404;
    lobbies.get(lobbyId).players.push({
        "id": playerId,
        "nickname": nickname,
        "ready": false,
    });
    client.publish(lobbyId, JSON.stringify(lobbies.get(lobbyId)), { retain: true });
}

_checkAllReady = function (lobbyId) {
    for (p of lobbies.get(lobbyId).players) {
        if (p.ready == false) return false;
    }
    return true;
}

_startGame = function (lobbyId) {
    console.log("Starting");
    const currentLobbyInfo = lobbies.get(lobbyId);
    const playersData=currentLobbyInfo.players.map((p) =>
    ({
        "id": p.id,
        "nickname": p.nickname,
        "isMyTurn": false,
        "ready": false,
        "score": 0,
    }));
    let index = Math.floor(Math.random()*playersData.length);
    playersData[index]["isMyTurn"]=true;
    const newLobby = {
        "status": "initial",
        "roundDuration": currentLobbyInfo.roundDuration,
        "maxRoundNumber": currentLobbyInfo.maxRoundNumber,
        "currentRound": 0,
        "currentBlackCard": _drawBlack(lobbyId),
        "players": playersData,
    }
    lobbies.set(lobbyId, newLobby);
    client.publish(lobbyId, JSON.stringify(lobbies.get(lobbyId)), { retain: true });
}

_drawBlack = function (lobbyId) {
    if (client.disconnected) throw 500;
    if (lobbies.get(lobbyId) == undefined || cards.get(lobbyId) == undefined) throw 404;
    const card = cards.get(lobbyId).drawBlackCard;
    if (card == undefined) throw 404;
    console.log(card);
    return card;
}

exports.drawWhite = function (lobbyId) {
    if (client.disconnected) throw 500;
    if (lobbies.get(lobbyId) == undefined || cards.get(lobbyId) == undefined) throw 404;
    const card = cards.get(lobbyId).drawWhiteCard;
    if (card == undefined) throw 404;
    return card;
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

const _updateLobbyAfterDisconnect = function (playerId) {
    for (let [lobbyId, lobby] of lobbies) {
        let playerIndex = lobby.players.findIndex(player => player.id === playerId);
        if (playerIndex !== -1) {
            lobby.players.splice(playerIndex, 1);
            if (lobby.players.length === 0) {
                lobbies.delete(lobbyId);
            }
            client.publish(lobbyId, "", { retain: false });
            return lobbyId;
        }
    }
}