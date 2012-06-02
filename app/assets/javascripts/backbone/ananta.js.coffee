#= require_self
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
  @remove()
  @unbind()
  if @onClose then @onClose()