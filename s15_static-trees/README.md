# Session 15: Static Trees

See it on [MIT OCW](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-851-advanced-data-structures-spring-2012/lecture-videos/session-15-static-trees/).

This lecture focuses on three problems:
- **Range minimum queries** (RMQ): given an array `A` and indices `i` and `j`,
  find the minimum element on the range `A[i..j]`

- **Lowest common ancestor** (LCA): given two nodes on a tree, find their lowest
  common ancestor

- **Level ancestor** (LA): given a node on a tree and and integer `k` smaller than
  its depth, find the `k`-th ancestor of that node

All of which are solved in constant time for static trees (arrays for RMQ).
