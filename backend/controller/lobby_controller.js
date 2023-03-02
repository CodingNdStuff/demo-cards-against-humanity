const express = require('express');
const router = express.Router();
const { query, body, param, validationResult } = require('express-validator');
const mqtt = require('../mqtt_manager/mqtt');
router.post('/createLobby', async (req, res) => {
    /*
    {
        "id":"sdq12d",
        "nickname":"wood",
        "roundDuration":25,
        "maxRoundNumber":10,
    }
     */

    const lobbyData = req.body;
    const lobbyId = mqtt.createLobby(lobbyData.playerId, lobbyData.nickname, lobbyData.roundDuration, lobbyData.maxRoundNumber);
    return res.status(201).json(lobbyId);
});

router.post('/setPlayerReady/:lobbyId/:playerId', async (req, res) => {
    /*
    {
        "playerId":"sdq12d",
        "nickname":"wood",
        "roundDuration":25,
        "maxRoundNumber":10,
    }
     */
    const lobbyId= req.params.lobbyId;
    const playerId= req.params.playerId;

    mqtt.setPlayerReady(lobbyId, playerId);
    return res.status(201).json(lobbyId);
});

router.post('/joinLobby/:lobbyId', async (req, res) => {
    /*
    {
        "playerId":"sdq12d",
        "nickname":"wood",
    }
     */
    const lobbyId= req.params.lobbyId;
    const playerId= req.body.playerId;
    const nickname= req.body.nickname;

    mqtt.joinLobby(lobbyId, playerId, nickname);
    return res.status(201).json(lobbyId);
});
module.exports = router;