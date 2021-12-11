import { View, CollectionView } from 'backbone.marionette'
import templateList from 'templates/rendezVous/admin-item/list.tpl'
import templateItem from 'templates/rendezVous/admin-item/item.tpl'
import templateNone from 'templates/rendezVous/admin-item/none.tpl'
import templateNew from 'templates/rendezVous/admin-item/new.tpl'
import templatePanel from 'templates/rendezVous/admin-item/panel.tpl'

import { SortList, DestroyWarn, FlashItem, SubmitClicked, EditItem } from 'apps/common/behaviors.coffee'
import { app } from 'app'

PanelView = View.extend {
  template: templatePanel
  triggers: {
    "click button.js-new": "item:new"
  }
}

NoItemView = View.extend {
  template:  templateNone
  tagName: "tr"
  className: "table-warning"
}

ItemView = View.extend {
  tagName: "tr"
  template: templateItem
  behaviors: [DestroyWarn, FlashItem]
  triggers: {
    "click td a.js-edit": "edit"
  }
}

RendezVousCollectionView = CollectionView.extend {
  tagName: "table"
  className: "table table-hover"
  getTemplate: -> templateList
  childView: ItemView
  emptyView: NoItemView
  childViewContainer: "tbody"
  childViewEventPrefix: 'item'
  behaviors: [SortList]
}

NewCreneauRendezVousView = View.extend {
  template: templateNew
  behaviors: [SubmitClicked, EditItem]
  initialize: ->
    @title = "Créer un nouveau préneau"
}

export { RendezVousCollectionView, NewCreneauRendezVousView, PanelView }
