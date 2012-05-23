# Change underscore.js interpolation from ruby-like to using {{ ... }}}
_.templateSettings =  interpolate :/\{\{(.+?)\}\}/g

window.User = Backbone.Model.extend({})

window.Users = Backbone.Collection.extend
  model: User
  url: '/users'

window.UserView = Backbone.View.extend
  tagName: 'li'
  className: 'user'

  initialize: ->
    _.bindAll(@, 'render')
    @model.bind('change', @render)
    @template = _.template(($ '#user-template').html())

  render: ->
    rendered = @template(@model.toJSON())
    ($ @el).html(rendered)
    @
