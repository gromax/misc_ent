import { MnObject } from 'backbone.marionette'
import { ListPanel, ListLayout } from 'apps/common/common_views.coffee'
import { OffreRendezVousCollectionView, NewOffreRendezVousView } from 'apps/rendezVous/admin-list/list_views.coffee'
import { app } from 'app'

Controller = MnObject.extend {
  channelName: 'entities'
  list: (criterion)->
    app.trigger "loading:up"
    channel = @getChannel()
    require "entities/rendezVous.coffee"
    fetching = channel.request("rendezVous:offres:fetch:list")
    $.when(fetching).done( (items)->
      listLayout = new ListLayout()
      listView = new OffreRendezVousCollectionView {
        collection: items
      }

      listPanel = new ListPanel {
        listView
        appTrigger: "admin:offresRendezVous:filter"
        title: "Propositions de rendez-vous"
        filterCriterion:criterion
        showAddButton:true
      }

      listLayout.on "render", ->
        listLayout.getRegion('panelRegion').show(listPanel)
        listLayout.getRegion('itemsRegion').show(listView)

      listPanel.on "item:new", ->
        Item = require("entities/rendezVous.coffee").OffreItem
        newItem = new Item()
        view = new NewOffreRendezVousView {
          model: newItem
          listView: listView
        }
        app.regions.getRegion('dialog').show(view)

      listView.on "item:show", (item) ->
        app.trigger("admin:rendezVous:offre", item.model.get("id"))

      app.regions.getRegion('main').show(listLayout)
    ).fail( (response)->
      app.trigger "data:fetch:fail", response
    ).always( ->
      app.trigger "loading:down"
    )
}

export controller = new Controller()
