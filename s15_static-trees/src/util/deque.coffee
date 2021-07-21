# General purpose double-ended queue 

module.exports = Deque = class
    constructor: -> @head = @tail = null

    # Adds a value to the top of the deque
    #
    # Returns this
    push: (value) ->
        node = new Node value
        @tail.next = node if @tail
        @tail = node
        if @head == null
            @head = @tail
        return this

    # Removes the value from the top of the deque
    #
    # Returns this
    pop: ->
        @tail = @tail.prev
        if @tail == null
            @head = null
        else
            @tail._next = null
        return this

    # Adds a value to the bottom of the deque
    #
    # Returns this
    unshift: (value) ->
        node = new Node value
        @head.prev = node if @head
        @head = node
        if @tail == null
            @tail = @head
        return this

    # Removes the value from the bottom of the deque
    #
    # Returns this
    shift: ->
        @head = @head.next
        if @head == null
            @tail = null
        else
            @head._prev = null
        return this

Object.defineProperties Deque.prototype,
    isEmpty:
        get: -> @head == null
    top:
        get: -> @tail.$
    bottom:
        get: -> @head.$


class Node
    constructor: (@$) ->
        @_prev = null
        @_next = null

Object.defineProperties Node.prototype,
    next:
        get: -> @_next
        set: (node) ->
            node._prev = this
            @_next = node
    prev:
        get: -> @_prev
        set: (node) ->
            node._next = this
            @_prev = node
