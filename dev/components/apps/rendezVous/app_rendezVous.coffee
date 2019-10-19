import { app } from 'app'

Router = Backbone.Router.extend {
  routes: {
    "admin/rendezVous/list(/filter/criterion::criterion)": "list"
  }

  list: (criterion) ->
    if 1 in app.Auth.get("droits")
      require("apps/rendezVous/admin-list/list_controller.coffee").controller.list(criterion)
    else
      app.trigger("not:found")
}

router = new Router()

app.on "admin:rendezVous:list", ->
  app.navigate("admin/rendezVous/list")
  router.list()

app.on "admin:rendezVous:filter", (criterion) ->
  if criterion
    app.navigate "admin/rendezVous/list/filter/criterion:#{criterion}"
  else
    app.navigate "admin/rendezVous/list"
