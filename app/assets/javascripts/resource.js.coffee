kickboard.factory "resource", ($resource) ->
  (url, params, options) ->
    defaults =
      create:
        method: "POST"

      index:
        method: "GET"
        isArray: true

      show:
        method: "GET"
        isArray: false

      update:
        method: "PUT"

      destroy:
        method: "DELETE"

    resource = $resource(url, params, angular.extend(defaults, options))
    resource::$save = ->
      unless @id
        @$create()
      else
        @$update()

    resource
