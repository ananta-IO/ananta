class Ananta.Models.User extends Backbone.Model
  paramRoot: 'user'

class Ananta.Collections.UsersCollection extends Backbone.Collection
  model: Ananta.Models.User
  url: '/users'
