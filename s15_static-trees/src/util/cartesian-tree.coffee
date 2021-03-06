# Cartesian Tree generation for arrays of numbers
#   used to reduce RMQ to LCA
# 
# Given an array A:
#   - let T = min element A[i] of A
#   - left subtree of T = cartesian tree on A[< i]
#   - right               ...               A[> i]
# 
# This gives a min heap, with the added property that LCA(T, i, j) on this
# structure is equivalent to RMQ(A, i, j) on the original array.
#
# Ties are broken by arbitrarily choosing one of the elements.

{ strict: assert } = require 'assert'

# Linear-time algorithm for constructing the cartesian tree of a given array.
#
#   A   : an array of numbers
#
# Returns an object { root, mapping } with the root node of the tree and an
# array corresponding to the nodes created for each element in A.
# Each node will be assigned its original index as metadata on 'sourceIndex'.

module.exports = cartesianTree = (A) ->
    mapping = []
    
    makeNode = (i) ->
        node = new Node A[i]
        node.metadata['sourceIndex'] = i
        mapping.push node
        return node

    root = makeNode 0
    
    for i in [1..A.length - 1]
        current = makeNode i

        # Here we maintain the min-heap property
        if A[i] < root.$
            # We may have to go arbitrarily up the tree, but after we do that
            # every node we traversed becomes part of the left subtree, which
            # we don't care about anymore, so we can charge this traversal on
            # the following reduction of the number of nodes on the right
            # spine, giving an amortized constant cost on this branch
            while root.parent != null and A[i] < root.parent.$  
                root = root.parent
            
            if root.parent != null
                # We're always on the right spine of the tree
                root.parent.right = current

            current.left = root

        # Otherwise, essentially what we do is put the node on the left
        # subtree if it's empty and grow the right spine otherwise.
        else
            assert root.right == null
            root.right = current

        root = current

    # In the end, the "root" is going to be the rightmost node on the tree, so
    # we have to go back to the actual root of the tree. This takes at most
    # linear time, so we're good.
    while root.parent != null
        root = root.parent

    return { root, mapping }


# Nifty binary tree node object that automatically assigns parent pointers.

class Node
    constructor: (@$) ->
        @_left = @_right = @_parent = null
        @metadata = {}

    _linkChild: (node) ->
        node._parent = this

Object.defineProperties Node.prototype,
    left:
        get: -> @_left
        set: (node) ->
            this._linkChild node
            @_left = node
    right:
        get: -> @_right
        set: (node) ->
            this._linkChild node
            @_right = node
    parent:
        get: -> @_parent
    depth:
        get: -> if this.parent then this.parent.depth + 1 else 0
