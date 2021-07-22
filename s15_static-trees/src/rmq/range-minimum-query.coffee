LCA             = require '../lca/lowest-common-ancestor'
cartesianTree   = require '../util/cartesian-tree'

# RMQ data structure for O(1) time queries and O(n) space
# This circumvents the unit distance limitation of the UnitDistanceRMQ by
# transforming the array into its corresponding cartesian tree and solving
# an LCA, which is equivalent.

module.exports = RMQ = class
    constructor: (A) ->
        { root: T, mapping: @nodes } = cartesianTree A
        @lca = new LCA T

    rangeMinimum: (i, j) ->
        @lca.lowestCommonAncestor(@nodes[i], @nodes[j]).metadata['sourceIndex']
