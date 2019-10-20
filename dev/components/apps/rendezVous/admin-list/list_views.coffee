import { View, CollectionView } from 'backbone.marionette'
import templateList from 'templates/rendezVous/admin-list/list.tpl'
import templateItem from 'templates/rendezVous/admin-list/item.tpl'
import templateNone from 'templates/rendezVous/admin-list/none.tpl'
import templateNew from 'templates/rendezVous/admin-list/new.tpl'
import { SortList, FilterList, DestroyWarn, FlashItem, SubmitClicked, EditItem } from 'apps/common/behaviors.coffee'
import { app } from 'app'

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
    "click": "show"
  }
}

OffreRendezVousCollectionView = CollectionView.extend {
  tagName: "table"
  className: "table table-hover"
  getTemplate: -> templateList
  childView: ItemView
  emptyView: NoItemView
  childViewContainer: "tbody"
  childViewEventPrefix: 'item'
  behaviors: [SortList, FilterList]
  filterKeys: ["idEntUser", "title", "filter", "description"]
}

NewOffreRendezVousView = View.extend {
  template: templateNew
  behaviors: [SubmitClicked, EditItem]
  initialize: ->
    @title = "Créer un nouveau type de RDV"
}

export { OffreRendezVousCollectionView, NewOffreRendezVousView }
