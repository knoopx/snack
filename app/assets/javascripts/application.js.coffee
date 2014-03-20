#= require jquery
#= require fastclick
#= require moment
#= require mousetrap
#= require hammerjs
#= require angular
#= require angular-moment
#= require angular-hammer
#= require highlightjs

@snack = angular.module "snack", ["angularMoment", "hmTouchEvents"]

@snack.run ->
  FastClick.attach(document.body)
#  document.addEventListener "touchmove", (event) ->
#    el = event.target
#    style = window.getComputedStyle(el)
#    scrolling = style.getPropertyValue("-webkit-overflow-scrolling")
#    overflow = style.getPropertyValue("overflow")
#    height = parseInt(style.getPropertyValue("height"), 10)
#    event.preventDefault() unless scrolling

@snack.config ($httpProvider) ->
  $httpProvider.defaults.headers.common["Accept"] = "application/json"
#  authToken = $("meta[name=\"csrf-token\"]").attr("content")
#  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

@snack.controller "mainCtrl", ($scope, $sce, $http, $timeout) ->
  $scope.entries = []
  $http.get("/entries").success (entries) ->
    angular.forEach entries, (entry) ->
      $scope.entries.push(entry)
    $scope.select($scope.entries[0])

  $scope.selected = null

  $scope.previousEntry = ->
    if previous = $scope.entries[$scope.entries.indexOf($scope.selected) - 1]
      $scope.select(previous)

  $scope.nextEntry = ->
    if next = $scope.entries[$scope.entries.indexOf($scope.selected) + 1]
      $scope.select(next)

  Mousetrap.bind 'shift+up', ->
    $scope.$apply($scope.previousEntry)

  Mousetrap.bind 'shift+down', ->
    $scope.$apply($scope.nextEntry)

  $scope.htmlSafe = (html) ->
    $sce.trustAsHtml(html)

  $scope.select = (entry) ->
    $scope.selected = entry

  $scope.$watch "selected", (entry) ->
    if entry
      $timeout ->
        $("#entry-#{entry.id}").focus()
        $('.article pre code').each ->
          console.log("changed")
          hljs.highlightBlock(this)

@snack.controller "sidebarCtrl", ($scope) ->

@snack.controller "entriesCtrl", ($scope) ->

@snack.controller "entryCtrl", ($scope, $element) ->

@snack.controller "articleCtrl", ($scope) ->
