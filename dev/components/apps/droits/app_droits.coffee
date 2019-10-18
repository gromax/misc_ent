import { app } from 'app'

Router = Backbone.Router.extend {
  routes: {
    "droits(/filter/criterion::criterion)": "list"
  }

  list: (criterion) ->
    if app.Auth.get("isAdmin")
      require("apps/droits/list/droits_list_controller.coffee").controller.list(criterion)
    else
      app.trigger("not:found")
}

router = new Router()

app.on "droits:list", ()->
  app.navigate("droits")
  router.list()

app.on "droits:filter", (criterion) ->
  if criterion
    app.navigate "droits/filter/criterion:#{criterion}"
  else
    app.navigate "droits"
