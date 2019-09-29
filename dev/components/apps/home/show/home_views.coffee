import { View, CollectionView } from 'backbone.marionette'
import off_tpl from 'templates/home/show/home-off.tpl'
import on_tpl from 'templates/home/show/home-on.tpl'
import notFound_tpl from 'templates/home/show/home-off.tpl'
import { app } from 'app'

NotFoundView = View.extend {
  className: "jumbotron"
  template: notFound_tpl
}

OffPanel = View.extend {
  className: "jumbotron"
  template: off_tpl
  triggers: {
    "click a.js-login": "home:login"
  }
  onHomeLogin: (e) ->
    app.trigger("home:login")

  templateContext: ->
    {
      version: app.version
    }
}

OnPanel = View.extend {
  className: "jumbotron"
  template: on_tpl
  triggers: {
  }

}

export {
  OffPanel
  OnPanel
  NotFoundView
}
