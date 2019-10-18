import Radio from 'backbone.radio'

Item = Backbone.Model.extend {
  urlRoot: "api/droits"

  defaults: {
    idEntUser: ""
    idDroit: 0
  }

  parse: (data) ->
    if (data.id)
      data.id = Number(data.id)
    if (data.idDroit)
      data.idDroit = Number(data.idDroit)
    return data

  validate: (attrs, options) ->
    errors = {}
    if not attrs.idEntUser
      errors.idEntUser = "Ne doit pas être vide"
    if not _.isEmpty(errors)
      return errors
}

Collection = Backbone.Collection.extend {
  url: "api/droits"
  model: Item
  comparator: "idEntUser"
}

API = {
  fetch: () ->
    defer = $.Deferred()
    url = "api/droits"
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
channel.reply('droits:fetch', API.fetch )


export {
  Item
  Collection
}
