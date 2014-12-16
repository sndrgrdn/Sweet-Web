class App.Models.Base

  constructor: (@root)->
    @urlRoot =  "#{App.ApiLocation}#{@root}/"
    @setup()

  setup: ->
    $.ajaxSetup
      statusCode:
        401: ->
          # Redirect to the login page.
          App.Vent.publish 'sessions:auth:fail'
          routie('/')

        403: ->
          # 403 -- Access denied
          App.Vent.publish 'sessions:auth:fail'
          routie('/')


  all: () ->
    $.ajax(
      url: @urlRoot
      type: 'GET'
      dataType: 'json'
      crossDomain: true
      beforeSend: (xhr) ->
        xhr.setRequestHeader "Authorization", "Token token=#{App.Session.authToken}"
    )
    .done( (data, textStatus, jqXHR) =>
      App.Vent.publish "model:#{@root}:all", data
    )
    .fail (jqXHR, textStatus, errorThrown) =>
      App.Vent.publish "model:#{@root}:all:error", jqXHR.responseJSON

  find: (id) ->
    $.ajax(
      url: @urlRoot + id
      type: 'GET'
      dataType: 'json'
      crossDomain: true
      beforeSend: (xhr) ->
        xhr.setRequestHeader "Authorization", "Token token=#{App.Session.authToken}"
    )
    .done( (data) =>
      App.Vent.publish "model:#{@root}:find", data
    )
    .fail (jqXHR, textStatus, errorThrown) =>
      App.Vent.publish "model:#{@root}:find:error", jqXHR.responseJSON

  create: (attr) ->
    $.ajax(
      url: @urlRoot
      type: 'POST'
      dataType: 'json'
      crossDomain: true
      data: attr
      beforeSend: (xhr) ->
        xhr.setRequestHeader "Authorization", "Token token=#{App.Session.authToken}"
    )
    .done( (data) =>
      App.Vent.publish "model:#{@root}:create", data
    )
    .fail (jqXHR, textStatus, errorThrown) =>
      App.Vent.publish "model:#{@root}:create:error", jqXHR.responseJSON

  update: (id, attr) ->
    $.ajax(
      url: @urlRoot + id
      type: 'POST'
      dataType: 'json'
      crossDomain: true
      data: attr
      beforeSend: (xhr) ->
        xhr.setRequestHeader "Authorization", "Token token=#{App.Session.authToken}"
    )
    .done( (data) =>
      App.Vent.publish "model:#{@root}:update", data
    )
    .fail (jqXHR, textStatus, errorThrown) =>
      App.Vent.publish "model:#{@root}:update:error", jqXHR.responseJSON

  destroy: (id) ->
    $.ajax(
      url: @urlRoot + id
      type: 'POST'
      dataType: 'json'
      crossDomain: true
      data:
        _method: 'delete'
      beforeSend: (xhr) ->
        xhr.setRequestHeader "Authorization", "Token token=#{App.Session.authToken}"
    )
    .done( (data) =>
      App.Vent.publish "model:#{@root}:destroy", id: id
    )
    .fail (jqXHR, textStatus, errorThrown) =>
      App.Vent.publish "model:#{@root}:destroy:error", jqXHR.responseJSON
