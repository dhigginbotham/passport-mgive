# Author: [David Higginbotham](davehigginbotham@gmail.com)
# License: MIT

passport = require "passport"
request = require "request"
util = require "util"

### BadRequestError ###
# handles bad requests with custom messages, borrowed from passport.js (local) thanks!
# 
#  `message` - error message string
BadRequestError = (message) ->
  Error.call @
  Error.captureStackTrace @, arguments.callee
  @name = "BadRequestError"
  @message = message || null

BadRequestError::__proto__ = Error::

### mGive Strategy ###
# passport.js strategy stores username, accessToken, sessionId
Strategy = (options, verify) ->
  
  if typeof options == "function"
    verify = options
    options = {}

  options.tokenURL = options.tokenURL || "http://services.mobileaccord.com/api.ashx?responseType=json&op=login"

  passport.Strategy.call @
  
  @name = "mgive"
  @passAuthentication = options.passAuthentication || true
  @username = options.username || "username"
  @password = options.password || "password"
  @verify = verify
  @

# inherit our `Strategy object with passport.Strategy`
util.inherits Strategy, passport.Strategy

### Strategy::authenticate ###
# passport.js authenticate prototype
Strategy::authenticate = (req, options) ->

  options = options || {};
  
  if req.body? && req.body[options.username || "username"] then @username = req.body[options.username || "username"]
  if req.body? && req.body[options.password || "password"] then @password = req.body[options.password || "password"]

  if req.query? && req.query[options.username || "username"] then @username = req.query[options.username || "username"]
  if req.query? && req.query[options.password || "password"] then @password = req.query[options.password || "password"]

  return @fail new BadRequestError options.badRequestMessage || "Missing credentials" if !@username or !@password

  self = @

  verified = (err, user, info) ->
    if err? then return self.error err
    if !user then return self.fail info
    self.success user, info
  
  # run `self.verify` to ensure this user is okay'd
  if @passAuthentication == true then self.verify self.username, self.password, verified
  else return @fail "Unauthorized"

### Strategy::userProfile ###
# this extends the initial object, sorts some things around
# 
#  example session object should look like:
# 
#  ```
#  session = {}
#  session.passport = {}
#  session.passport.user = {}
#  session.passport.provider = "mgive"
#  session.passport.username = "username"
#  session.passport.sessionId = "sessionId"
#  session.passport.accessToken = "accessToken"
#  session.flash = {}
# 
# Strategy::userProfile = (req, done) ->
#   self = @
#   try
#     @Auth @username, @password, (err, user) ->
#       return done err, null if err?
#       return done null, user
#   catch err
#     return done err, null
#  ```

### Strategy::Auth ###
# do auth to ensure user credentials and create userprofile
Strategy::Auth = (username, password, done) ->

  self = @

  request
    method: "POST"
    uri: "http://services.mobileaccord.com/api.ashx?responseType=json&op=login&username=#{username}&password=#{password}"
    (err, r, body) ->
      if err? then return done err, null
      if body? then self._body = JSON.parse body
      if body? then return done null, self._body

module.exports = Strategy
