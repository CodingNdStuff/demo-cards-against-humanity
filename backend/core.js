const Lobby = require("./models/Lobby");
const Statuses = require("./models/Statuses");
const { publishEncoded } = require("./mqtt_manager/mqtt");


let lobbies = new Map();

exports.createLobby = function (id, nickname, roundDuration, maxRoundNumber) {
    // const newLobbyId = _generateUniqueId(lobbies)

    const newLobbyId = "4jjjnpe6";
    const newLobby = new Lobby(newLobbyId, id, nickname, roundDuration, maxRoundNumber);
    lobbies.set(newLobbyId, newLobby);
    publishEncoded(newLobbyId, newLobby.getOpenLobbyData());
    return newLobbyId;
}

exports.joinLobby = function (lobbyId, playerId, nickname) {
    const currentLobbyData = lobbies.get(lobbyId)
    if (currentLobbyData == undefined) throw 404;
    currentLobbyData.addPlayer(playerId, nickname);
    publishEncoded(lobbyId, currentLobbyData.getOpenLobbyData());
}

exports.setPlayerReady = function (lobbyId, playerId) {
    const currentLobbyData = lobbies.get(lobbyId)
    if (currentLobbyData == undefined) throw 404;
    if (currentLobbyData.status != Statuses.open) throw 409;

    currentLobbyData.setPlayerReady(playerId);
    publishEncoded(lobbyId, currentLobbyData.getOpenLobbyData());

    if (currentLobbyData.checkAllReady()) {
        _startGame(currentLobbyData);
    }
}

exports.playCard = function (lobbyId, playerId, cardIds) {
    const currentLobbyData = lobbies.get(lobbyId)
    if (currentLobbyData == undefined) throw 404;
    if (currentLobbyData.status != Statuses.play) throw 409;
    if (cardIds.length != currentLobbyData.round.currentBlackCard.numberOfBlanks) throw 409;
    currentLobbyData.playCard(playerId, cardIds);
    currentLobbyData.setPlayerReady(playerId);
    publishEncoded(lobbyId, currentLobbyData.getOngoingLobbyData());
    if (currentLobbyData.checkAllReady()) {
        _startVoting(currentLobbyData);
    }
}

exports.deleteLobby = function (lobbyId) {
    const currentLobbyData = lobbies.get(lobbyId)
    if (currentLobbyData == undefined) throw 404;
    lobbies.delete(lobbyId);
    publishEncoded(lobbyId, "");
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



// ----------------------------------- HANDLING PHASE CHANGES --------------------------------------

_startGame = function (currentLobbyData) {
    console.log("Starting");
    currentLobbyData.status=Statuses.play;
    currentLobbyData.resetAllPlayerReady();
    currentLobbyData.refillHands();
    publishEncoded(currentLobbyData.id, currentLobbyData.getOngoingLobbyData());
    currentLobbyData.playerList.forEach(p => {
        publishEncoded(currentLobbyData.id+"/"+p.id, p.hand);
    });
}

_startVoting = function (currentLobbyData) {
    console.log("Voting");
    currentLobbyData.status=Statuses.voting;
    currentLobbyData.resetAllPlayerReady();
    console.log(currentLobbyData.round.playedCards);
    publishEncoded(currentLobbyData.id+"/voting", currentLobbyData.round.playedCards);

    //
    //   currentLobbyInfo.players.forEach((p)=>{
    //     console.log(lobbyId+"/"+p.id);
    //     let hand=[];
    //     for(let i=0;i<10;i++){
    //         hand.push(_drawWhite(lobbyId));
    //     }
    //     client.publish(lobbyId+"/"+p.id, JSON.stringify(hand, (key, value) => {
    //         if (typeof value === 'string') {
    //           return encodeURIComponent(value);
    //         }
    //         return value;
    //       }), { retain: true });
    //   });
}