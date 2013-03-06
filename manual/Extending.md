# Extending

All extendable objects in dermis use prototypal inheritance. Below are some examples of how to extend things.

## Models

    class User extends dermis.Model
      urls:
        create: -> "/api/users"
        read: -> "/api/users/#{@get('id')"
        update: -> "/api/users/#{@get('id')"
        destroy: -> "/api/users/#{@get('id')"

      run: ->
        console.log "Running!"

      walk: ->
        console.log "Walking..."

      move: ->
        if @get('indoors')
          @walk()
        else
          @run()

## Collections

    class Users extends dermis.Collection
      model: User
      url: "/api/users"

      moveAll: ->
        @forEach (user) ->
          user.move()