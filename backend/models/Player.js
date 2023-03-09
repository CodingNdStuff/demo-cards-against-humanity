module.exports = class Player{
    constructor(id, nickname){
        this.id=id;
        this.nickname=nickname;
        this.isReady=false;
        this.isMyTurn=false;
        this.score=0;
        this.hand=[];
    }
}