# Change underscore.js interpolation from ruby-like to using {{ ... }}}
_.templateSettings =  interpolate :/\{\{(.+?)\}\}/g

window.User = Backbone.Model.extend({})

window.Users = Backbone.Collection.extend
  model: User
  url: '/users.json'

window.list = new Users()

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

window.ListUserView = UserView.extend({})

window.ListView = Backbone.View.extend
  tagName: 'section'
  className: 'list'

  initialize: ->
    _.bindAll(@, 'render')
    @template = _.template(($ '#list-template').html())
    @collection.bind('reset', @render)

  render: ->
    $(@.el).html(@template({}))
    $users = @$('.users')
    @collection.each (user) ->
      view = new ListUserView
        model: user
        collection: @collection
      $users.append(view.render().el)
    @

window.UserRouter = Backbone.Router.extend
  routes:
    '': 'home'

  initialize: ->
    @listView = new ListView
      collection: window.list

  home: ->
    $container = ($ '#container')
    $container.empty()
    $container.append(@listView.render().el)

$ ->
  window.App = new UserRouter()
  Backbone.history.start(pushState: true)
  list.fetch()
