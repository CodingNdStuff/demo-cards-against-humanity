

module.exports = class CardsList{
    #listBlack = [...blackCards];
    #listWhite = [...whiteCards];
    constructor() {
      }

    get drawBlackCard(){
        let index=Math.floor(Math.random()*this.#listBlack.length);
        const card=this.#listBlack.at(index);
        this.#listBlack.splice(index,1);
        console.log(index);
        console.log(this.#listBlack.length);
        console.log(card);
        return card;
    }

    get drawWhiteCard(){
        let index=Math.floor(Math.random()*this.#listWhite.length);
        const card=this.#listWhite.at(index);
        this.#listWhite.splice(index,1);
        console.log(index);
        console.log(this.#listWhite.length);
        console.log(card);
        return card;
    }
}

blackCards = [
    {
        "id": 1,
        "text": "News - Naufragio a Napoli, la reazione della Meloni: _ ",
        "numberOfBlanks": 1,
    }, {
        "id": 2,
        "text": "Hello, your computer has _",
        "numberOfBlanks": 1,
    }, {
        "id": 3,
        "text": "Se solo qualcuno mi avesse presentato _ prima che iniziassi l'università.",
        "numberOfBlanks": 1,
    }, {
        "id": 4,
        "text": "L'unica cosa peggiore del debugging di un'applicazione Android è _ ",
        "numberOfBlanks": 1,
    }, {
        "id": 5,
        "text": "Quando finalmente capisci come risolvere quella fastidiosa NullPointerException, _",
        "numberOfBlanks": 1,
    }, {
        "id": 6,
        "text": "L'unica cosa peggiore della scrittura del codice è il debug di _ ",
        "numberOfBlanks": 1,
    }, {
        "id": 7,
        "text": "Perché lo sviluppatore di androidi è stato bocciato? _",
        "numberOfBlanks": 1,
    }, {
        "id": 8,
        "text": "In uno scioccante colpo di scena, si è scoperto che _ era la vera causa dell'interruzione del wifi in tutto il campus.",
        "numberOfBlanks": 1,
    }, {
        "id": 9,
        "text": "Il dipartimento informatico dell'università è riuscito a risolvere il problema utilizzando _ come soluzione temporanea.",
        "numberOfBlanks": 1,
    }, {
        "id": 10,
        "text": "Dopo aver passato la notte in bianco, ho finalmente finito il mio saggio su _ e l'ho consegnato al mio professore.",
        "numberOfBlanks": 1,
    }, {
        "id": 11,
        "text": "Dopo anni di studio, ho finalmente capito che la chiave del successo accademico è _.",
        "numberOfBlanks": 1,
    }, {
        "id": 12,
        "text": "Se si vuole sopravvivere alla stagione degli esami, è necessario avere a portata di mano una scorta costante di _.",
        "numberOfBlanks": 1,
    }, {
        "id": 13,
        "text": "Non pensavo di poter sopravvivere a _ fino a quando non ho scoperto _",
        "numberOfBlanks": 2,
    }, {
        "id": 14,
        "text": "Dopo mesi di duro lavoro, ho finalmente conseguito la laurea in _",
        "numberOfBlanks": 1,
    }, {
        "id": 15,
        "text": "Il segreto per ottenere buoni voti è non sottovalutare mai il potere di _",
        "numberOfBlanks": 1,
    }, {
        "id": 16,
        "text": "L'unica cosa più stressante degli esami finali è _",
        "numberOfBlanks": 1,
    }, {
        "id": 17,
        "text": "Dopo anni di studio sotto la guida del mio professore, ho capito che la sua più grande debolezza è _.",
        "numberOfBlanks": 1,
    }
]

whiteCards = [
    {
        "id": 1,
        "text": "Donga",
    },
]