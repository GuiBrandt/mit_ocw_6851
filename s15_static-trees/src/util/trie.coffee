module.exports = Trie = class
    constructor: () ->
        @$ = null
        @children = {}

    insert: (S, value) ->
        if S.length == 0
            @$ = value
        else
            symbol = S[0]
            @children[symbol] or= new Node
            @children[symbol].insert S[1..], value

    get: (S) ->
        if S.length == 0
            return @$
        else
            symbol = S[0]
            return null unless symbol in @children
            return @children.find S[1..]
