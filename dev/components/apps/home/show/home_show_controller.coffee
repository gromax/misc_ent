import { MnObject } from 'backbone.marionette'
import { OffPanel, OnPanel, NotFoundView } from 'apps/home/show/home_views.coffee'
import { AlertView } from 'apps/common/common_views.coffee'
import { app } from 'app'

Controller = MnObject.extend {
  channelName: "entities"

  notFound: ->
    view = new NotFoundView()
    app.regions.getRegion('main').show(view)

  showOffHome: ->
    view = new OffPanel()
    app.regions.getRegion('main').show(view)

  showOnHome: ->
    view = new OnPanel { model: app.Auth }
    app.regions.getRegion('main').show(view)

  casloginfailed:  ->
    view = new AlertView {
      title:"Échec de l'authentification !"
      message:"L'authentification par l'ENT a échoué."
    }
    app.regions.getRegion('main').show(view)
}

export controller = new Controller()

