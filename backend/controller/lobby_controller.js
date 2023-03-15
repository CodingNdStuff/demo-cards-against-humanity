const express = require('express');
const router = express.Router();
const { query, body, param, validationResult } = require('express-validator');
const core = require('../core');

router.post('/createLobby', [
    body('playerId').exists().isString().isLength({ min: 1, max: 32, }),
    body('nickname').exists().isString().isLength({ min: 1, max: 16, }),
    body('roundDuration').exists().isInt({ min: 15, max: 60, }),
    body('maxRoundNumber').exists().isInt({ min: 1, max: 15, }), //todo change to 5
], async (req, res) => {
    /*
    {
        "playerId":"sdq12d",
        "nickname":"wood",
        "roundDuration":25,
        "maxRoundNumber":10,
    }
     */
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(422).json({ error: errors.array() });
    }

    const lobbyData = req.body;
    let lobbyId;
    try {
        lobbyId = core.createLobby(lobbyData.playerId, lobbyData.nickname, lobbyData.roundDuration, lobbyData.maxRoundNumber);
    } catch (err) {
        return res.status(500).end();
    }

    return res.status(201).json(lobbyId);
});

router.post('/setPlayerReady/:lobbyId/:playerId', [
    param('lobbyId').exists().isString().isLength({ min: 5, max: 5, }),
    param('playerId').exists().isString().isLength({ min: 1, max: 32, }),
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(422).json({ error: errors.array() });
    }
    const lobbyId = req.params.lobbyId;
    const playerId = req.params.playerId;
    try {
        core.setPlayerReady(lobbyId, playerId);
    } catch (err) {
        if (err == 404)
            return res.status(404).end();
        return res.status(500).end();
    }

    return res.status(201).end();
});

router.post('/joinLobby/:lobbyId', [
    param('lobbyId').exists().isString().isLength({ min: 5, max: 5, }),
    body('playerId').exists().isString().isLength({ min: 1, max: 32, }),
    body('nickname').exists().isString().isLength({ min: 1, max: 16, }),
], async (req, res) => {
    /*
    {
        "playerId":"sdq12d",
        "nickname":"wood",
    }
     */
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(422).json({ error: errors.array() });
    }
    const lobbyId = req.params.lobbyId;
    const playerId = req.body.playerId;
    const nickname = req.body.nickname;
    try {
        core.joinLobby(lobbyId, playerId, nickname);
    } catch (err) {   
        if (err == 404)
            return res.status(404).end();
        if (err == 403)
            return res.status(404).end();
        return res.status(500).end();
    } 

    return res.status(201).end();
});


// router.get('/drawBlack/:lobbyId', [
//     param('lobbyId').exists().isString().isLength({ min: 5, max: 5, }),
// ], async (req, res) => {
//     const errors = validationResult(req);
//     if (!errors.isEmpty()) {
//         return res.status(422).json({ error: errors.array() });
//     }

//     const lobbyId = req.params.lobbyId;
//     let card;
//     try {
//         card = mqtt.drawBlack(lobbyId);
//     } catch (err) {
//         if (err == 500)
//             return res.status(500).end();
//         if (err == 404)
//             return res.status(404).end();
//     }
//     return res.status(200).json(card);
// });

// router.get('/drawWhite/:lobbyId', [
//     param('lobbyId').exists().isString().isLength({ min: 5, max: 5, }),
// ], async (req, res) => {
//     const errors = validationResult(req);
//     if (!errors.isEmpty()) {
//         return res.status(422).json({ error: errors.array() });
//     }

//     const lobbyId = req.params.lobbyId;
//     let card;
//     try {
//         card = mqtt.drawWhite(lobbyId);
//     } catch (err) {
//         if (err == 500)
//             return res.status(500).end();
//         if (err == 404)
//             return res.status(404).end();
//     }
//     return res.status(200).json(card);
// });

router.post('/playCard/:lobbyId/:playerId', [
    param('lobbyId').exists().isString().isLength({ min: 5, max: 5, }),
    param('playerId').exists().isString().isLength({ min: 1, max: 32, }),
    body('cardIds').exists().isArray().custom((value) => {
        const allIntegers = value.every((item) => Number.isInteger(item));
        if (!allIntegers) {
          throw new Error(`${fieldName} must contain only integers`);
        }
        return true;
      }),
], async (req, res) => {
    /*
    {
        "cardId":123,
    }
     */
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(422).json({ error: errors.array() });
    }
    const lobbyId = req.params.lobbyId;
    const playerId = req.params.playerId;
    const cardIds = req.body.cardIds;
    try {
        core.playCard(lobbyId, playerId, cardIds);
    } catch (err) {
        if (err == 404)
            return res.status(404).end();
        return res.status(500).end();
    }
    return res.status(201).end();
});

router.post('/voteWinner/:lobbyId/:playerId', [
    param('lobbyId').exists().isString().isLength({ min: 5, max: 5, }),
    param('playerId').exists().isString().isLength({ min: 1, max: 32, }),
    body('votedPlayerId').exists().isString().isLength({ min: 1, max: 32, }),
], async (req, res) => {
    /*
    {
        "votedPlayerId":123,
    }
     */
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(422).json({ error: errors.array() });
    }
    const lobbyId = req.params.lobbyId;
    const playerId = req.params.playerId;
    const votedPlayerId = req.body.votedPlayerId;
    try {
        core.voteWinner(lobbyId, playerId, votedPlayerId);
    } catch (err) {
        if (err == 404)
            return res.status(404).end();
        if (err == 403)
            return res.status(403).end();
        return res.status(500).end();
        
    }
    return res.status(201).end();
});

module.exports = router;