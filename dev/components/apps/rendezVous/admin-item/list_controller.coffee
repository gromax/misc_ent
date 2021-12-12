import { MnObject } from 'backbone.marionette'
import { ListLayout, ListPanel } from 'apps/common/common_views.coffee'
import { RendezVousCollectionView, NewPlageRendezVousView } from 'apps/rendezVous/admin-item/list_views.coffee'
import { app } from 'app'

Controller = MnObject.extend {
  channelName: 'entities'
  list: (id, criterion)->
    app.trigger "loading:up"
    channel = @getChannel()
    require "entities/rendezVous.coffee"
    fetching = channel.request("rendezVous:offre:fetch", id)
    $.when(fetching).done( (offreRendezVous, itemsRendezVous)->
      listLayout = new ListLayout()
      listView = new RendezVousCollectionView {
        collection: itemsRendezVous
      }

      listPanel = new ListPanel {
        listView
        appTrigger: (v,c) -> app.trigger("admin:rendezVous:offre:filter", id, c)
        title: "Rendez-vous"
        filterCriterion:criterion
        showAddButton:true
      }

      listLayout.on "render", ->
        listLayout.getRegion('panelRegion').show(listPanel)
        listLayout.getRegion('itemsRegion').show(listView)

      listPanel.on "item:new", ->
        Item = require("entities/rendezVous.coffee").PlageItem
        newItem = new Item({ idOffre: id})
        view = new NewPlageRendezVousView {
          model: newItem
          listView: listView
          triggerOnSuccess: {route:"admin:rendezVous:offre:refresh", data:id}
        }
        #DatePicker # nécessaire au bon chargement
        app.regions.getRegion('dialog').show(view)


      app.regions.getRegion('main').show(listLayout)
    ).fail( (response)->
      app.trigger "data:fetch:fail", response
    ).always( ->
      app.trigger "loading:down"
    )
}

export controller = new Controller()
