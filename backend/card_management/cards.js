const black_cards = require("./black_cards");
const white_cards = require("./white_cards");


module.exports = class Deck{
    #listBlack = [...black_cards,...blackCards];
    #listWhite = [...white_cards,...whiteCards];
    constructor() {
    }

    get drawBlackCard(){
        let index=Math.floor(Math.random()*this.#listBlack.length);
        const card=this.#listBlack.at(index);
        this.#listBlack.splice(index,1);
        console.log(card);
        return card;
    }

    get drawWhiteCard(){
        let index=Math.floor(Math.random()*this.#listWhite.length);
        const card=this.#listWhite.at(index);
        this.#listWhite.splice(index,1);
        console.log(card);
        return card;
    }
}

blackCards = [
    {
        "id": 1001,
        "text": "News - Naufragio a Napoli, la reazione della Meloni: _ .",
        "numberOfBlanks": 1,
    }, {
        "id": 1002,
        "text": "Hello, your computer has _ .",
        "numberOfBlanks": 1,
    }, {
        "id": 1003,
        "text": "Se solo qualcuno mi avesse presentato _ prima che iniziassi l'università.",
        "numberOfBlanks": 1,
    }, {
        "id": 1004,
        "text": "L'unica cosa peggiore del debugging di un'applicazione Android è _ .",
        "numberOfBlanks": 1,
    }, {
        "id": 1005,
        "text": "Quando finalmente capisci come risolvere quella fastidiosa NullPointerException, _ .",
        "numberOfBlanks": 1,
    }, {
        "id": 1006,
        "text": "L'unica cosa peggiore della scrittura del codice è il debug di _ .",
        "numberOfBlanks": 1,
    }, {
        "id": 1007,
        "text": "Perché lo sviluppatore di androidi è stato bocciato? _ .",
        "numberOfBlanks": 1,
    }, {
        "id": 1008,
        "text": "In uno scioccante colpo di scena, si è scoperto che _ era la vera causa dell'interruzione del wifi in tutto il campus.",
        "numberOfBlanks": 1,
    }, {
        "id": 1009,
        "text": "Il dipartimento informatico dell'università è riuscito a risolvere il problema utilizzando _ come soluzione temporanea.",
        "numberOfBlanks": 1,
    }, {
        "id": 1010,
        "text": "Dopo aver passato la notte in bianco, ho finalmente finito il mio saggio su _ e l'ho consegnato al mio professore.",
        "numberOfBlanks": 1,
    }, {
        "id": 1011,
        "text": "Dopo anni di studio, ho finalmente capito che la chiave del successo accademico è _ .",
        "numberOfBlanks": 1, 
    }, {
        "id": 1012,
        "text": "Se si vuole sopravvivere alla stagione degli esami, è necessario avere a portata di mano una scorta costante di _ .",
        "numberOfBlanks": 1,
    }, {
        "id": 1013,
        "text": "Non pensavo di poter sopravvivere a _ fino a quando non ho scoperto _ .",
        "numberOfBlanks": 2,
    }, {
        "id": 1014,
        "text": "Dopo mesi di duro lavoro, ho finalmente conseguito la laurea in _ .",
        "numberOfBlanks": 1,
    }, {
        "id": 1015,
        "text": "Il segreto per ottenere buoni voti è non sottovalutare mai il potere di _ .",
        "numberOfBlanks": 1,
    }, {
        "id": 1016,
        "text": "L'unica cosa più stressante degli esami finali è _ .",
        "numberOfBlanks": 1,
    }, {
        "id": 1017,
        "text": "Dopo anni di studio sotto la guida del mio professore, ho capito che la sua più grande debolezza è _ .",
        "numberOfBlanks": 1,
    }
]

whiteCards = [
    {
        "id": 1001,
        "text": "Donga",
    },{
        "id": 1002,
        "text": "Obamna",
    },
]