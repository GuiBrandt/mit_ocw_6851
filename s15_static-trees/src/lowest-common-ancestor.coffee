# Lowest common ancestor implementation for binary trees

eulerTour   = require './euler-tour'
rmq         = require './range-minimum-query'

# LCA data structure for O(1) time queries and O(n) space

module.exports = LCA = class
    constructor: (T) ->
        @etr = eulerTour T
        @rmq = new rmq.UnitDistanceRMQ @etr.map (node) -> node.metadata['depth']

    # Returns the lowest common ancestor of two given nodes on the tree
    #
    #   a, b    : nodes from T
    
    lowestCommonAncestor: (a, b) ->
        [i, j] = [a.metadata['etrIndex'], b.metadata['etrIndex']].sort()
        return @etr[@rmq.rangeMinimum i, j]
