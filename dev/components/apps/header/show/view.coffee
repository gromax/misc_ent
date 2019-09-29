import { View } from 'backbone.marionette'
import header_tpl from 'templates/header/show/header-navbar.tpl'
import { app } from 'app'

HeaderView = View.extend {
  template: header_tpl
  triggers: {
    "click a.js-home": "home:show"
    "click a.js-logout": "home:logout"
  }

  initialize: (options) ->
    options = options ? {};
    @auth = _.clone(app.Auth.attributes)

  templateContext: ->
    isOff = not @auth.logged_in
    {
      isOff: isOff
      displayName: if isOff then "Déconnecté" else @auth.displayName
      isAdmin: @auth.isAdmin
      version: app.version
    }

  logChange: ->
    @initialize()
    @render()

  onHomeShow: (e) ->
    app.trigger "home:show"

  onHomeLogout: (e) ->
    app.trigger "home:logout"

  spin: (set_on) ->
    if set_on
      $("span.js-spinner", @$el).html("<i class='fa fa-spinner fa-spin'></i>")
    else
      $("span.js-spinner", @$el).html("")
}

export { HeaderView }
