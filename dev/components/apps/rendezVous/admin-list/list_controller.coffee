import { MnObject } from 'backbone.marionette'
import { ListPanel, ListLayout } from 'apps/common/common_views.coffee'
import { RendezVousCollectionView, NewRendezVousView } from 'apps/rendezVous/admin-list/list_views.coffee'
import { app } from 'app'

Controller = MnObject.extend {
  channelName: 'entities'
  list: (criterion)->
    app.trigger "loading:up"
    channel = @getChannel()
    require "entities/rendezVous.coffee"
    fetching = channel.request("rendezVous:fetch")
    $.when(fetching).done( (items)->
      listLayout = new ListLayout()
      listView = new RendezVousCollectionView {
        collection: items
      }
      listPanel = new ListPanel {
        listView
        appTrigger: "admin:rendezVous:filter"
        title: "Types de rendez-vous"
        filterCriterion:criterion
        showAddButton:true
      }

      listLayout.on "render", ->
        listLayout.getRegion('panelRegion').show(listPanel)
        listLayout.getRegion('itemsRegion').show(listView)

      listPanel.on "item:new", ->
        Item = require("entities/rendezVous.coffee").Item
        newItem = new Item()
        view = new NewRendezVousView {
          model: newItem
          listView: listView
        }
        app.regions.getRegion('dialog').show(view)

      app.regions.getRegion('main').show(listLayout)
    ).fail( (response)->
      app.trigger "data:fetch:fail", response
    ).always( ->
      app.trigger "loading:down"
    )
}

export controller = new Controller()
