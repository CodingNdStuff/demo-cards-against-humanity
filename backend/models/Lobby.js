const Deck = require("../card_management/cards");
const Player = require("./Player");
const Round = require("./Round");
const Statuses = require("./Statuses");

module.exports = class Lobby {
    constructor(lobbyId, playerId, nickname, roundDuration, maxRoundNumber) {
        this.id = lobbyId;
        this.status = Statuses.open;
        this.roundDuration = roundDuration;
        this.maxRoundNumber = maxRoundNumber;
        this.currentRound = 0;
        this.round = new Round()
        this.deck = new Deck()
        this.playerList = new Map([[playerId, new Player(playerId, nickname)]]);
        this.playerList.get(playerId).isMyTurn=true;
        this.round.currentBlackCard=this.deck.drawBlackCard;
    }
    
    getOpenLobbyData() {
        if (this.status != Statuses.open) throw 409
        const mappedPlayerList = Array.from(this.playerList.entries(),
            ([id, player]) => ({
                id,
                nickname: player.nickname,
                ready: player.isReady,
            }));
        return {
            "status": this.status,
            "roundDuration": this.roundDuration,
            "maxRoundNumber": this.maxRoundNumber,
            "players": mappedPlayerList,
        }
    }

    getOngoingLobbyData() {
        if (this.status == Statuses.open) throw 409
        const mappedPlayerList = Array.from(this.playerList.entries(),
            ([id, player]) => ({
                id,
                nickname: player.nickname,
                ready: player.isReady,
                score: player.score,
                isMyTurn: player.isMyTurn,
            }));
        return {
            "status": this.status,
            "roundDuration": this.roundDuration,
            "maxRoundNumber": this.maxRoundNumber,
            "currentRound":this.currentRound,
            "currentBlackCard": this.round.currentBlackCard,
            "players": mappedPlayerList,
        }
    }

    addPlayer(playerId, nickname){
        this.playerList.set(playerId, new Player(playerId, nickname));
    }

    setPlayerReady(playerId){
        const player = this.playerList.get(playerId);
        if(player == undefined) throw 404
        player.isReady=true;
    }

    resetAllPlayerReady(){
        this.playerList.forEach(p => {
            if(!p.isMyTurn)
            p.isReady = false;
        });
    }

    checkAllReady(){
        let everyOneReady = true;
        this.playerList.forEach(p => {
            if(!p.isReady) everyOneReady = false;
        });
        return everyOneReady;
    }

    playCard(playerId, cardIds){
        if (this.status != Statuses.play) throw 409
        const player = this.playerList.get(playerId);
        if(player == undefined) throw 404
        
        let playedCards = [];
        let found=0;
        let remainingCards = [];
        player.hand.forEach(c=>{
            if(cardIds.includes(c.id)){
                playedCards.push(c);
                found++;
            } else
                remainingCards.push(c); //todo
        });
        if(found != cardIds.length) throw 404
        const record = {
            "playerId":playerId,
            "playedCards":playedCards,
        }
        player.hand = remainingCards;
        this.round.playedCards.push(record);
    }

    nextBlackCard(){
        this.currentBlackCard=this.deck.drawBlackCard;
    }

    refillHands(){
        const max = 10;
        
        this.playerList.forEach((p)=>{
            let i;
            const missing= max-p.hand.length;
            for(i=0; i<missing; i++)
                p.hand.push(this.deck.drawWhiteCard); 
        })
    }
}

