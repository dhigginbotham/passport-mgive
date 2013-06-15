### passport-mgive

[passport.js](http://passportjs.org/) strategy for the mGive public api

## Installation
```
npm install https://github.com/dhigginbotham/passport-mgive
```

# Usage

```
mGiveStrategy = require "passport-mgive"

app.post "/api/mgive",
  passport.authenticate "mgive", {failureRedirect: "/api/mgive", failureFlash: true}, (req, res) -> res.redirect "/"

```

passport = require "passport" # require passport.js
mGiveStrategy = require "./strategy" # require mgive passport.js strategy

##Serializing / Deserializing Users
```
passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (obj, done) ->
  done null, obj
```

##Passport.js strategy middleware
this is the strategy initializer / verify method

`username` - required `String` to test login, defaults to 
`req.body||query.username

`password` - required `String` to test login, defaults to 
`req.body||query.password

`done err, body` is a callback for verify
    
####example:
```    
passport.use new mGiveStrategy (username, password, done) ->

  @Auth username, password, (err, auth) ->
    if err? then return done err, null

    User.findOne username: username, (err, user) ->
      if err? then return done err, null
      if user?
        # creating our update object with `Object.create`
        # in theory it should only be cast as an `Object`
        # once, however we may need to refactor this later
        # as a FCF
        updateUser =
          last_login: new Date auth.updated_time
          mgive: auth

        # firing `User.update`
        User.update username: username, updateUser, (err) ->
          if err? then return done err, null 
          if user? then return done null, user
      else
        # there's no user found, so we'll create one here
        # based on our expectations of how the object will
        # look
        user = new User
          username: username
          mgive: auth
          type: "mgive"
          admin: true

        # firing `User.save`, this should work -- otherwise some
        # data somewhere is missing, check the `user` object
        # above
        user.save (err, newUser) ->
          if err? then return done err, null
          if newUser? then return done null, newUser
```
