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

CreneauItem = Backbone.Model.extend {
  urlRoot: "api/rendezVous/creneaux"
  toJSON: ->
    data = @attributes
    data.date = data.dateFr.replace(/([0-9]{2})\/([0-9]{2})\/([0-9]{4})/,"$3-$2-$1")
    _.pick(data, "id", "idOffre", "date", "debut", "fin")
  parse: (data) ->
    if data.id
      data.id = Number(data.id)
    if data.idOffre
      data.idOffre = Number(data.idOffre)
    if data.date
      data.dateFr = data.date.replace(/([0-9]{4})-([0-9]{2})-([0-9]{2})/,"$3/$2/$1")
    return data
  validate: (attrs, options) ->
    errors = {}
    reTime = /^[0-9]{2}:[0-9]{2}$/
    reDate = /^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$/
    if not attrs.debut
      errors.debut = "Ne doit pas être vide"
    else if not reTime.test(attrs.debut)
      errors.debut = "Format invalide"
    if not attrs.fin
      errors.fin = "Ne doit pas être vide"
    else if not reTime.test(attrs.fin)
      errors.fin = "Format invalide"
    if not attrs.dateFr
      errors.dateFr = "Ne doit pas être vide"
    else if not reDate.test(attrs.dateFr)
      errors.dateFr = "Format invalide"
    if not _.isEmpty(errors)
      return errors
}

CreneauCollection = Backbone.Collection.extend {
  url: "api/rendezVous"
  model: CreneauItem
  comparator: "date"
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
      creneaux = new CreneauCollection(data.creneaux, {parse:true})
      offreRendezVous = new OffreItem(data.offre, {parse:true})
      defer.resolve(offreRendezVous, creneaux)
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
  CreneauItem
}
