#= require_self
#= require ./mixins/collections
#= require ./mixins/logins
#= require ./mixins/flashes
#= require_tree ./mixins
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Ananta =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  App: {}
  Mixins: {}

Backbone.View::close = ->
  if @onClose then @onClose()
  @remove()
  @unbind()