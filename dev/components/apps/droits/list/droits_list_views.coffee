import { View, CollectionView } from 'backbone.marionette'
import templateList from 'templates/droits/list/list.tpl'
import templateItem from 'templates/droits/list/item.tpl'
import templateNone from 'templates/droits/list/none.tpl'
import templateNew from 'templates/droits/list/new.tpl'
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
}

DroitsCollectionView = CollectionView.extend {
  tagName: "table"
  className: "table table-hover"
  getTemplate: -> templateList
  childView: ItemView
  emptyView: NoItemView
  childViewContainer: "tbody"
  childViewEventPrefix: 'item'
  behaviors: [SortList, FilterList]
  filterKeys: ["idEntUser", "idDroit"]
}

NewDroitView = View.extend {
  template: templateNew
  behaviors: [SubmitClicked, EditItem]
  initialize: ->
    @title = "Accorder un nouveau droit"
}

export { DroitsCollectionView, NewDroitView }
