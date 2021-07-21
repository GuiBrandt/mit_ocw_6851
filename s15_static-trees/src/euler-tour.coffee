# Euler tour representations for binary trees

# Constructs the Euler tour representation for a given binary tree.
#
#   T   : a binary tree

module.exports = eulerTour = (T) ->
    etr = []

    rec = (node) ->
        # Store index of first occurence of the node on the euler tour as
        # metadata for later
        node.metadata['etrIndex'] = etr.length

        etr.push node

        if node.left
            rec(node.left)
            etr.push node

        if node.right
            rec(node.right)
            etr.push node

    rec(T)

    return etr
