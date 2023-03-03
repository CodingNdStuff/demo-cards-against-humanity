const express = require('express');
const router = express.Router();
const { query, body, param, validationResult } = require('express-validator');
const mqtt = require('../mqtt_manager/mqtt');

router.post('/createLobby', [
    body('playerId').exists().isString().isLength({ min: 1, max: 32, }),
    body('nickname').exists().isString().isLength({ min: 1, max: 16, }),
    body('roundDuration').exists().isInt({ min: 15, max: 60, }),
    body('maxRoundNumber').exists().isInt({ min: 5, max: 15, }),
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
        lobbyId = mqtt.createLobby(lobbyData.playerId, lobbyData.nickname, lobbyData.roundDuration, lobbyData.maxRoundNumber);
    } catch (err) {
        if (err == 500)
            return res.status(500).end();
    }

    return res.status(201).json(lobbyId);
});

router.post('/setPlayerReady/:lobbyId/:playerId', [
    param('lobbyId').exists().isString().isLength({ min: 8, max: 8, }),
    param('playerId').exists().isString().isLength({ min: 1, max: 32, }),
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(422).json({ error: errors.array() });
    }
    const lobbyId = req.params.lobbyId;
    const playerId = req.params.playerId;
    try {
        mqtt.setPlayerReady(lobbyId, playerId);
    } catch (err) {
        if (err == 500)
            return res.status(500).end();
        if (err == 404)
            return res.status(404).end();
    }

    return res.status(201).json(lobbyId);
});

router.post('/joinLobby/:lobbyId', [
    param('lobbyId').exists().isString().isLength({ min: 8, max: 8, }),
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
        mqtt.joinLobby(lobbyId, playerId, nickname);
    } catch (err) {
        if (err == 500)
            return res.status(500).end();
        if (err == 404)
            return res.status(404).end();
    }

    return res.status(201).json(lobbyId);
});

module.exports = router;