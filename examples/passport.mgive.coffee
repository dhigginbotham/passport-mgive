
# Author: [David Higginbotham](davehigginbotham@gmail.com)
# License: MIT

passport = require "passport" # require passport.js
mGiveStrategy = require "./strategy" # require mgive passport.js strategy

### Serializing / Deserializing Users ###
passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (obj, done) ->
  done null, obj

### passport.js strategy middleware ###
# 
# this is the strategy initializer / verify method
# 
#   `username` - required `String` to test login, defaults to 
#   `req.body||query.username
#   
#   `password` - required `String` to test login, defaults to 
#   `req.body||query.password
#   
#   `done err, body` is a callback for verify
#   
# example:
#   
#  app.post "/api/mgive",
#    passport.authenticate "mgive", {failureRedirect: "/api/mgive", failureFlash: true}, (req, res) -> res.redirect "/"

passport.use new mGiveStrategy (username, password, done) ->
  @Auth username, password, (err, user) ->
    if err? done err, null else done null, user
