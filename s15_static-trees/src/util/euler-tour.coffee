# Euler tour representations for binary trees

# Constructs the Euler tour representation for a given binary tree.
#
#   T   : a binary tree
#
# As a side effect, this function assigns the following metadata on the nodes
# of the tree:
#   - 'etrIndex'    : index of the node on the resulting ETR array
#   - 'depth'       : depth of the node on the tree

module.exports = eulerTour = (T) ->
    etr = []

    rec = (node, depth) ->
        # Store index of first occurence of the node on the euler tour as
        # metadata for later
        node.metadata['etrIndex']   = etr.length
        node.metadata['depth']      = depth 

        etr.push node

        if node.left
            rec node.left, depth + 1
            etr.push node

        if node.right
            rec node.right, depth + 1
            etr.push node

    rec(T, 0)

    return etr
