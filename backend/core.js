const Lobby = require("./models/Lobby");
const Statuses = require("./models/Statuses");
const { publishEncoded, publishEncodedNoRetain, publishEmpty} = require("./mqtt_manager/mqtt");


let lobbies = new Map();

exports.createLobby = function (id, nickname, roundDuration, maxRoundNumber) {
    // const newLobbyId = _generateUniqueId(lobbies)

    const newLobbyId = _generateUniqueId(lobbies);
    const newLobby = new Lobby(newLobbyId, id, nickname, roundDuration, maxRoundNumber);
    lobbies.set(newLobbyId, newLobby);
    publishEncoded(newLobbyId, newLobby.getOpenLobbyData());
    return newLobbyId;
}

exports.joinLobby = function (lobbyId, playerId, nickname) {
    const currentLobbyData = lobbies.get(lobbyId)
    if (currentLobbyData == undefined) throw 404;
    if (!(currentLobbyData.status == Statuses.open)) throw 403;
    currentLobbyData.addPlayer(playerId, nickname);
    publishEncoded(lobbyId, currentLobbyData.getOpenLobbyData());
}

exports.setPlayerReady = function (lobbyId, playerId) {
    const currentLobbyData = lobbies.get(lobbyId)
    if (currentLobbyData == undefined) throw 404;
    if (!(currentLobbyData.status == Statuses.open ||
        currentLobbyData.status == Statuses.prep)) throw 409;

    currentLobbyData.setPlayerReady(playerId);
    if(currentLobbyData.status == Statuses.open)
        publishEncoded(lobbyId, currentLobbyData.getOpenLobbyData());
    else publishEncoded(lobbyId, currentLobbyData.getOngoingLobbyData());

    if (currentLobbyData.checkAllReady()) {
        if(currentLobbyData.status == Statuses.open)
            _startGame(currentLobbyData);
        if(currentLobbyData.status == Statuses.prep)
            _prep(currentLobbyData);
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

exports.voteWinner = function (lobbyId, playerId, votedPlayerId) {
    const currentLobbyData = lobbies.get(lobbyId)
    if (currentLobbyData == undefined) throw 404;
    if (currentLobbyData.status != Statuses.voting) throw 409;
    const oldWinner = currentLobbyData.playerList.get(playerId);
    const newWinner = currentLobbyData.playerList.get(votedPlayerId);
    if (oldWinner == undefined ||
        newWinner == undefined ||
        !oldWinner.isMyTurn) throw 403;

    oldWinner.isMyTurn=false;
    newWinner.isMyTurn=true;
    newWinner.score+=100;
    currentLobbyData.currentRound+=1;
    console.log("voting winner")
    if(currentLobbyData.currentRound<currentLobbyData.maxRoundNumber)
        _prep(currentLobbyData);
    else
        _close(currentLobbyData);

}

exports.deleteLobby = function (lobbyId) {
    const currentLobbyData = lobbies.get(lobbyId)
    if (currentLobbyData == undefined) throw 404;
    lobbies.delete(lobbyId);
    publishEncoded(lobbyId, "");
}

const _generateUniqueId = function (map) {
    const idLength = 5; // the length of the generated id
    let newId;

    // loop until a unique id is generated
    do {
        // generate a random string of alphanumeric characters
        newId = Math.random().toString(36).substr(2, idLength);
    } while (map.has(newId));

    return newId;
}



// ----------------------------------- HANDLING PHASE CHANGES --------------------------------------

_startGame = function (currentLobbyData) {
    console.log("Starting");
    currentLobbyData.status = Statuses.play;
    currentLobbyData.resetAllPlayerReady();
    currentLobbyData.refillHands();
    publishEncoded(currentLobbyData.id, currentLobbyData.getOngoingLobbyData());
    currentLobbyData.playerList.forEach(p => {
        publishEncoded(currentLobbyData.id + "/" + p.id, p.hand);
    });
}

_startVoting = function (currentLobbyData) {
    console.log("Voting");
    currentLobbyData.status = Statuses.voting;
    currentLobbyData.resetAllPlayerReady();
    let shuffledArray= _shuffleArray(currentLobbyData.round.playedCards);
    console.log(shuffledArray);
    publishEncoded(currentLobbyData.id, currentLobbyData.getOngoingLobbyData());
    publishEncoded(currentLobbyData.id + "/voting", shuffledArray);

    _checkVotingHostDisconnection(currentLobbyData);
}

_shuffleArray = function (array) {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
  }

_prep = function (currentLobbyData) {
    if(currentLobbyData.status == Statuses.voting){
        console.log("Prep");
        currentLobbyData.status = Statuses.prep;
        currentLobbyData.resetAllPlayerReady();
    }else if(currentLobbyData.status == Statuses.prep){
        console.log("next round is starting");
        currentLobbyData.status = Statuses.play;
        currentLobbyData.resetAllPlayerReady();
        currentLobbyData.refillHands();
        currentLobbyData.nextBlackCard();
        currentLobbyData.playerList.forEach(p => {
            publishEncoded(currentLobbyData.id + "/" + p.id, p.hand);
        });
    }
    publishEncoded(currentLobbyData.id, currentLobbyData.getOngoingLobbyData());
}

_close = function (currentLobbyData) {
    console.log("Closing");
    currentLobbyData.status = Statuses.closed;
    publishEncodedNoRetain(currentLobbyData.id, currentLobbyData.getOngoingLobbyData());
    publishEmpty(currentLobbyData.id);
    currentLobbyData.playerList.forEach(p => {
        publishEmpty(currentLobbyData.id + "/" + p.id);
    });
    publishEmpty(currentLobbyData.id + "/voting");
    lobbies.delete(currentLobbyData.id);
}


// handling disconnections

exports.handleDisconnection = (lobbyId, playerId)=> {
    console.log(lobbyId)
    console.log(playerId)
    if(lobbyId==undefined || playerId == undefined) return;
    const currentLobbyData = lobbies.get(lobbyId);
    console.log(currentLobbyData == undefined)
    if (currentLobbyData == undefined) return; //lobby already gone
    console.log("lobby exists")
    currentLobbyData.removePlayer(playerId);
    publishEmpty(currentLobbyData.id + "/" + playerId);
    console.log("player removed")
    console.log("players < 2 : ")
    console.log(currentLobbyData.getOnlinePlayersCount() < 2)
    console.log("Status not open : ")
    console.log(!(currentLobbyData.status == Statuses.open))
    if ( currentLobbyData.getOnlinePlayersCount() < 2 && !(currentLobbyData.status == Statuses.open)) {
        _close(currentLobbyData);
    }
}

_checkVotingHostDisconnection = function (currentLobbyData){ 
    //if the holder of the token disconnects, after 10 seconds a random player gets voted artificially
    if(currentLobbyData.getTurnHolder() != undefined) return;

    const core = require('./core');
    //artificially create a player voting itself
    let index = Math.floor(Math.random()*currentLobbyData.playerList.size);
    const mapIterator = currentLobbyData.playerList.values()
    for(let i=0;i<index-1;i++)
        mapIterator.next();
    player = mapIterator.next().value

    player.isMyTurn=true;
    setTimeout(function() {
        core.voteWinner(currentLobbyData.id, player.id, player.id);
    }, 10000);
     
}
