### passport-mgive

[passport.js](http://passportjs.org/) strategy for the mGive public api

## Installation
```
npm install https://github.com/dhigginbotham/passport-mgive
```

# Usage

```
mGiveStrategy = require "passport-mgive"

passport.use new mGiveStrategy (username, password, done) ->
  @Auth username, password, (err, user) ->
    if err? done err, null else done null, user

app.post "/api/mgive",
  passport.authenticate "mgive", {failureRedirect: "/api/mgive", failureFlash: true}, (req, res) -> res.redirect "/"

```