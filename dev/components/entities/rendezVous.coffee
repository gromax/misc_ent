import Radio from 'backbone.radio'

Item = Backbone.Model.extend {
  urlRoot: "api/rendezVous"

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

Collection = Backbone.Collection.extend {
  url: "api/rendezVous"
  model: Item
  comparator: "idEntUser"
}

API = {
  fetch: () ->
    defer = $.Deferred()
    url = "api/rendezVous"
    request = $.ajax(url,{
      method:'GET'
      dataType:'json'
    })

    request.done( (data)->
      droits = new Collection(data, {parse:true})
      defer.resolve(droits)
    ).fail( (response)->
      defer.reject(response)
    )
    return defer.promise()
}

channel = Radio.channel('entities')
channel.reply('rendezVous:fetch', API.fetch )

export {
  Item
  Collection
}
