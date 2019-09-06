import Backbone from 'backbone'
import Radio from 'backbone.radio'

Session = Backbone.Model.extend {
  urlRoot: "api/session"
  initialize: ->
    that = @
    # Hook into jquery
    # Use withCredentials to send the server cookies
    # The server must allow this through response headers
    $.ajaxPrefilter( ( options, originalOptions, jqXHR) ->
      options.xhrFields = {
        withCredentials: true
      }
    )

  parse: (logged)->
    if logged.type isnt "off"
      logged.logged_in = true
      logged.id = -1 # sinon l'élément est considéré nouveau et sa destruction ne provoque pas de requête DELETE
    else
      logged = {
        logged_in: false
        type:"off"
        displayName:"Déconnecté"
        login: ""
      }
    return logged

  getAuth: (callback)->
    # getAuth is wrapped around our router
    # before we start any routers let us see if the user is valid
    @fetch({
      success: callback
    })

  refresh: (data)->
    @set(@parse(data))

}

API = {
  getSession: (callback)->
    Auth = new Session()
    Auth.on "destroy", ()->
      @unset("id")
      channel = Radio.channel('entities')
      channel.request("data:purge")
      @set("adm",false)
    Auth.getAuth(callback)
    return Auth

}

channel = Radio.channel('entities')
channel.reply('session:entity', API.getSession )

module.exports = Session
