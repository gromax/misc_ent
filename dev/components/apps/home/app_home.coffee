import { app } from 'app'

Router = Backbone.Router.extend {
  routes: {
    "" : "showHome"
    "home" : "showHome"
    "logout" : "logout"
    "casloginfailed": "casloginfailed"
  }
  showHome: ->
    controller = require("apps/home/show/home_show_controller.coffee").controller
    if app.Auth.get("logged_in")
      controller.showOnHome()
    else
      controller.showOffHome()
  logout: ->
    self = @
    if app.Auth.get("logged_in")
      closingSession = app.Auth.destroy()
      $.when(closingSession).done( (response)->
        # En cas d'échec de connexion, l'api server renvoie une erreur
        # Le delete n'occasione pas de raffraichissement des données
        # Il faut donc le faire manuellement
        app.Auth.refresh(response)
        self.showHome()
      ).fail( (response)->
        alert("Erreur inconnue. Essayez à nouveau ou prévenez l'administrateur [code #{response.status}/024]");
      )
  casloginfailed: ->
    if app.Auth.get("logged_in")
      app.trigger("notFound")
    else
      require("apps/home/show/home_show_controller.coffee").controller.casloginfailed()
}

router = new Router()

app.on "home:show", ->
  app.navigate("home")
  router.showHome()

app.on "home:logout", ->
  router.logout()
  app.trigger("home:show")
