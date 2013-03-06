# Extending

All extendable objects in dermis use prototypal inheritance. Below are some examples of how to extend things.

## Basic Example

### The Model

Let's make a custom User model

    # We extend dermis.Model as our base
    class User extends dermis.Model
      # Add some URLs for syncing
      urls:
        create: -> "/api/users"
        read: -> "/api/users/#{@get('id')}"
        update: -> "/api/users/#{@get('id')}"
        destroy: -> "/api/users/#{@get('id')}"
      # Add a custom function
      run: ->
        console.log "Running!"
      # And another one
      walk: ->
        console.log "Walking..."
      # And one more...
      move: ->
        if @get('indoors')
          @walk()
        else
          @run()

Now lets make an instance of our User model

    todd = new User name: 'Todd', id: 1

And we can call it's functions

    todd.set('indoors', true)
    todd.move() # Walking...
    todd.set('indoors', false)
    todd.move() # Running!

### The Collection

    # We extend dermis.Collection as our base
    class Users extends dermis.Collection
      model: User
      # Add some URLs for syncing
      url: "/api/users"
      # Add a custom function that moves all of our children
      moveAll: ->
        @forEach (user) ->
          user.move()

Now lets make an instance of Users

    people = new Users

And we can add todd to this

    people.add todd

And we can call it's functions

    people.moveAll() # will print either walking or running for each child