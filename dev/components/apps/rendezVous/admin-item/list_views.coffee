import { View, CollectionView } from 'backbone.marionette'
import templateList from 'templates/rendezVous/admin-item/list.tpl'
import templateItem from 'templates/rendezVous/admin-item/item.tpl'
import templateNone from 'templates/rendezVous/admin-item/none.tpl'
import templateNew from 'templates/rendezVous/admin-item/new.tpl'


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
  behaviors: [SortList, FilterList]
  filterKeys: (model, criterion) ->
    date = model.get('date')
    idEntUser = model.get('idEntUser')
    words = criterion.split(" ")
    if words.length > 2
      return false
    if words.length == 1 and (date.indexOf(words[0]) isnt -1 or idEntUser.indexOf(words[0]) isnt -1)
      return true
    if (date.indexOf(words[0]) isnt -1 and idEntUser.indexOf(words[1]) isnt -1) or (date.indexOf(words[1]) isnt -1 and idEntUser.indexOf(words[0]) isnt -1)
      return true
    return false
}

NewPlageRendezVousView = View.extend {
  template: templateNew
  behaviors: [SubmitClicked, EditItem]
  initialize: ->
    @title = "Créer un nouveau préneau"
}

export { RendezVousCollectionView, NewPlageRendezVousView }
