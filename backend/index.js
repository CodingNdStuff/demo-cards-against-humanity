'use strict';


var http = require('http');
var cors = require('cors');
const { validationResult, body, param } = require('express-validator');
var SERVER_PORT = 3001;
const express = require('express');
/** Authentication-related imports **/
var passport = require('passport');
var session = require('express-session');

const app=express();

/** Set up and enable Cross-Origin Resource Sharing (CORS) **/


var corsOptions = {
    origin: 'http://localhost:3000',
    credentials: true,
  };
  
  
/*** Passport ***/
  
// Serializing in the session the user object given from LocalStrategy(verify).
passport.serializeUser(function (user, cb) { // this user is id + username + name 
    cb(null, user);
});
  
// Starting from the data in the session, we extract the current (logged-in) user.
passport.deserializeUser(function (user, cb) { // this user is id + email + name 
    // if needed, we can do extra check here (e.g., double check that the user is still in the database, etc.)
    // e.g.: return userDao.getUserById(id).then(user => cb(null, user)).catch(err => cb(err, null));
    return cb(null, user); // this will be available in req.user
});
  
  
/*** Defining authentication verification middleware ***/
  
const isLoggedIn = (req, res, next) => {
if(req.isAuthenticated()) {
        return next();
    }
    return res.status(401).json({error: 'Not authorized'});
}

/*** Defining JSON validator middleware ***/

// var filmSchema = JSON.parse(fs.readFileSync(path.join('.', 'json_schemas', 'film_schema.json')).toString());
// var userSchema = JSON.parse(fs.readFileSync(path.join('.', 'json_schemas', 'user_schema.json')).toString());
// var reviewSchema = JSON.parse(fs.readFileSync(path.join('.', 'json_schemas', 'review_schema.json')).toString());
// var validator = new Validator({ allErrors: true });
// validator.ajv.addSchema([userSchema, filmSchema, reviewSchema]);
// const addFormats = require('ajv-formats').default;
// addFormats(validator.ajv);
// var validate = validator.validate;

//routers
app.use(express.json());
const lobbyController=require("./controller/lobby_controller");
app.use("/api",lobbyController);

// Creating the session


app.use(cors(corsOptions));
app.use(session({
    secret: "shhhhh... it's a secret!",
    resave: false,
    saveUninitialized: false,
  }));
app.use(passport.authenticate('session'));


app.listen(SERVER_PORT, () => {
    console.log(`Server running on port ${SERVER_PORT}`)
});

module.exports = app