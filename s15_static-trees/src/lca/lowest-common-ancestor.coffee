# Lowest common ancestor implementation for binary trees

eulerTour       = require '../util/euler-tour'
UnitDistanceRMQ = require '../rmq/unit-distance-rmq'

# LCA data structure for O(1) time queries and O(n) space
# An LCA is equivalent to an RMQ on the ETR of the tree, so this is quite
# compact

module.exports = LCA = class
    constructor: (T) ->
        @etr = eulerTour T
        @rmq = new UnitDistanceRMQ @etr.map (node) -> node.metadata['depth']

    # Returns the lowest common ancestor of two given nodes on the tree
    #
    #   a, b    : nodes from T
    
    lowestCommonAncestor: (a, b) ->
        [i, j] = [a.metadata['etrIndex'], b.metadata['etrIndex']].sort (x, y) => x - y
        return @etr[@rmq.rangeMinimum i, j]
