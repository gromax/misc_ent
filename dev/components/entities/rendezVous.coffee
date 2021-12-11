import Radio from 'backbone.radio'

OffreItem = Backbone.Model.extend {
  urlRoot: "api/rendezVous/offres"

  defaults: {
    idEntUser: ""
    emailUser: ""
    title: ""
    description: ""
    filter: ""
    rdvTime: 30
  }

  parse: (data) ->
    if (data.id)
      data.id = Number(data.id)
    if (data.rdvTime)
      data.rdvTime = Number(data.rdvTime)
    return data

  validate: (attrs, options) ->
    errors = {}
    if not attrs.idEntUser
      errors.idEntUser = "Ne doit pas être vide"
    if not attrs.title
      errors.title = "Ne doit pas être vide"
    if not attrs.description
      errors.description = "Ne doit pas être vide"
    if attrs.emailUser
      reEmail = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
      if not reEmail.test(attrs.emailUser)
        errors.emailUser = "L'email n'est pas valide"
    if not _.isEmpty(errors)
      return errors

}

OffresCollection = Backbone.Collection.extend {
  url: "api/rendezVous/offres"
  model: OffreItem
  comparator: "idEntUser"
}

RendezVousItem = CreneauItem = Backbone.Model.extend {
  urlRoot: "api/rendezVous/item"
  toJSON: ->
    data = @attributes
    data.date = data.dateFr.replace(/([0-9]{2})\/([0-9]{2})\/([0-9]{4}) ([0-9]{2}):([0-9]{2}):([0-9]{2})/,"$3-$2-$1 $4:$5:$6")
    _.pick(data, "id", "idOffre", "date", "idEntUser", "description")
  parse: (data) ->
    if data.id
      data.id = Number(data.id)
    if data.idOffre
      data.idOffre = Number(data.idOffre)
    if data.date
      data.dateFr = data.date.replace(/([0-9]{4})-([0-9]{2})-([0-9]{2}) ([0-9]{2})-([0-9]{2})-([0-9]{2})/,"$3/$2/$1 $4:$5:$6")
    return data
}

RendezVousCollection = Backbone.Collection.extend {
  url: "api/rendezVous"
  model: RendezVousItem
  comparator: "date"
}

# Utilisé pour créer un paquet de créneaux
PlageItem = Backbone.Model.extend {
  urlRoot: "api/rendezVous/plage"
  toJSON: ->
    data = @attributes
    data.date = data.dateFr.replace(/([0-9]{2})\/([0-9]{2})\/([0-9]{4})/,"$3-$2-$1") + " " + data.debut + ":00"
    _.pick(data, "idOffre", "date", "nombre", "duree")
  validate: (attrs, options) ->
    errors = {}
    reTime = /^[0-9]{2}:[0-9]{2}$/
    reDate = /^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$/
    reInt = /^[1-9]*[0-9]$/
    if not attrs.debut
      errors.debut = "Ne doit pas être vide"
    else if not reTime.test(attrs.debut)
      errors.debut = "Format hh:mm"
    if not attrs.nombre
      errors.nombre = "Ne doit pas être vide"
    else if not reInt.test(attrs.nombre)
      errors.nombre = "Doit être un nombre entier"
    if not attrs.duree
      errors.duree = "Ne doit pas être vide"
    else if not reInt.test(attrs.nombre)
      errors.duree = "Doit être un nombre entier"
    if not attrs.dateFr
      errors.dateFr = "Ne doit pas être vide"
    else if not reDate.test(attrs.dateFr)
      errors.dateFr = "Format invalide"
    if not _.isEmpty(errors)
      return errors
}

API = {
  fetchList: ->
    defer = $.Deferred()
    url = "api/rendezVous/offres"
    request = $.ajax(url,{
      method:'GET'
      dataType:'json'
    })

    request.done( (data)->
      offresRendezVous = new OffresCollection(data, {parse:true})
      defer.resolve(offresRendezVous)
    ).fail( (response)->
      defer.reject(response)
    )
    return defer.promise()

  fetch: (id) ->
    defer = $.Deferred()
    url = "api/rendezVous/offres/#{id}"
    request = $.ajax(url,{
      method:'GET'
      dataType:'json'
    })

    request.done( (data)->
      rendezVous = new RendezVousCollection(data.rendezvous, {parse:true})
      offreRendezVous = new OffreItem(data.offre, {parse:true})

      defer.resolve(offreRendezVous, rendezVous)
    ).fail( (response)->
      defer.reject(response)
    )
    return defer.promise()

}

channel = Radio.channel('entities')
channel.reply('rendezVous:offres:fetch:list', API.fetchList )
channel.reply('rendezVous:offre:fetch', API.fetch )

export {
  OffreItem
  OffresCollection
  PlageItem
}
