import { app } from 'app'

Router = Backbone.Router.extend {
  routes: {
    "admin/rendezVous/offres/list(/filter/criterion::criterion)": "list"
    "admin/rendezVous/offres/:id": "showOffreItem"
    "admin/rendezVous/offres/:id(/filter/criterion::criterion)": "showOffreItem"
  }

  list: (criterion) ->
    if 1 in app.Auth.get("droits")
      require("apps/rendezVous/admin-list/list_controller.coffee").controller.list(criterion)
    else
      app.trigger("not:found")

  showOffreItem: (id, criterion) ->
    if app.Auth.get("type") isnt "off"
      require("apps/rendezVous/admin-item/list_controller.coffee").controller.list(id, criterion)
    else
      app.trigger("not:found")
}

router = new Router()

app.on "admin:rendezVous:offres:list", ->
  app.navigate("admin/rendezVous/offres/list")
  router.list()

app.on "admin:rendezVous:offre", (id) ->
  app.navigate("admin/rendezVous/offres/#{id}")
  router.showOffreItem(id)

app.on "admin:rendezVous:offre:filter", (id, criterion) ->
  if criterion
    app.navigate "admin/rendezVous/offres/#{id}/filter/criterion:#{criterion}"
  else
    app.navigate "admin/rendezVous/offres/#{id}"

app.on "admin:rendezVous:offre:refresh", (id) ->
  router.showOffreItem(id)

app.on "admin:rendezVous:offres:filter", (criterion) ->
  if criterion
    app.navigate "admin/rendezVous/offres/list/filter/criterion:#{criterion}"
  else
    app.navigate "admin/rendezVous/offres/list"
