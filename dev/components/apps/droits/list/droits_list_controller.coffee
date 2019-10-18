import { MnObject } from 'backbone.marionette'
import { ListPanel, ListLayout } from 'apps/common/common_views.coffee'
import { DroitsCollectionView, NewDroitView } from 'apps/droits/list/droits_list_views.coffee'
import { app } from 'app'

Controller = MnObject.extend {
  channelName: 'entities'
  list: (criterion)->
    app.trigger "loading:up"
    channel = @getChannel()
    require "entities/droits.coffee"
    fetching = channel.request("droits:fetch")
    $.when(fetching).done( (items)->
      listLayout = new ListLayout()
      listView = new DroitsCollectionView {
        collection: items
      }
      listPanel = new ListPanel {
        listView
        appTrigger: "droits:filter"
        title: "Droits"
        filterCriterion:criterion
        showAddButton:true
      }

      listLayout.on "render", ->
        listLayout.getRegion('panelRegion').show(listPanel)
        listLayout.getRegion('itemsRegion').show(listView)

      listPanel.on "item:new", ->
        Item = require("entities/droits.coffee").Item
        newItem = new Item()
        view = new NewDroitView {
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
