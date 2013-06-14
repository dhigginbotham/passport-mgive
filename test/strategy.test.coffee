passport = require "passport"
mGiveStrategy = require "../lib/strategy"

user =
  username: "illoquent@mgive.com"
  password: "mgive1"

strategy = new mGiveStrategy (username, password, done) ->
  if username == user.username then done null, user
  return done null, null

describe "passport-mgive", () ->
  it "should authenticate a user with the correct login/password", (endOfDesc) ->

    req =
      body: username: user.username, password: user.password
      url: "/api/mgive"
    # self = @
    # @Auth username, password, (err, user) ->
    #   if err? done err, null
    #   self.user = user if user?

    strategy.success = (user) ->
      user.should.eql "illoquent@mgive.com"
      endOfDesc()

    strategy.error = () ->
      endOfDesc new Error argurments

    strategy.authenticate req

