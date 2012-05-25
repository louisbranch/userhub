# Change underscore.js interpolation from ruby-like to using {{ ... }}
_.templateSettings =  interpolate :/\{\{(.+?)\}\}/g

window.User = Backbone.Model.extend({})

window.Users = Backbone.Collection.extend
  model: User

window.list = new Users()

window.UserView = Backbone.View.extend
  tagName: 'li'
  className: 'user'
  events:
    'click img, .user-data' : 'goTo'

  initialize: ->
    _.bindAll(@, 'render')
    @model.bind('change', @render)
    @template = _.template(($ '#user-template').html())

  render: ->
    rendered = @template(@model.toJSON())
    ($ @el).html(rendered).hide().fadeIn().slideDown()
    @

  goTo: ->
    window.location.href = @model.get('html_url')

window.ListUserView = UserView.extend({})

window.ListView = Backbone.View.extend
  tagName: 'section'
  className: 'list'

  initialize: ->
    _.bindAll(@, 'render', 'addOne')
    @template = _.template(($ '#list-template').html())
    @collection.bind('add', @addOne, @)
    @render()

  render: ->
    $(@.el).html(@template({}))
    $users = @$('.users')
    @collection.each (user) ->
      view = new ListUserView
        model: user
        collection: @collection
      $users.append(view.render().el)
    @

  addOne: (user) ->
    $users = @$('.users')
    view = new ListUserView
      model: user
    $users.append(view.render().el)
    @

window.UserRouter = Backbone.Router.extend
  routes:
    '': 'home'

  initialize: ->
    @listView = new ListView
      collection: window.list

  home: ->
    $container = ($ '.users_container')
    $container.empty()
    $container.append(@listView.render().el)
    fetchUsers()

createUser = (username) ->
  $.ajax
    type: 'GET'
    dataType: 'json'
    url: "https://api.github.com/users/#{username}"
    success: (json) ->
      list.add(new User(json))
    error: ->
      $('.alert-box').html("#{username} is not a valid Github login").fadeIn('slow')

fetchUsers = ->
  $.ajax
    type: 'GET'
    url: '/users.json'
    success: (users) ->
      for user in users
        createUser user.username


$ submitUser = ->
  if $('form#new-user')
    $('form#new-user').submit (event) ->
      $input = $('form#new-user input#user-login')
      login = $input.val()
      if login
        createUser login
        $input.val('')
        $('.alert-box').hide()
      else
        $('.alert-box').html('Type a github username').fadeIn('slow')
      event.preventDefault()

$ ->
  window.App = new UserRouter()
  Backbone.history.start(pushState: true)

