Deque = require('../util/deque')

# RMQ data structure for O(1) time queries and O(n lg n) space

module.exports = SimpleRMQ = class
    # Constructs a static data structure for RMQ on a given array
    #
    #   A : an array

    constructor: (@A) ->
        # There are O(lg n) windows with size 2^k (k = 0..lg n), each with
        # size O(n), thus giving our O(n lg n) bound on space.
        @lookup = (slidingMinimum @A, k for k from powersOf2UpTo @A.length)

    # Returns the index of the minimum element on the given range
    #
    #   i, j    : range boundaries (0 <= i <= j < |A|)

    rangeMinimum: (i, j) ->
        # Let k = |j - i|.
        # We only need to look at two intervals with size 2^floor(lg k): since
        # 2 * 2^floor(lg k) = 2^(floor(lg k) + 1) > 2^lg k = k, we can
        # be sure that these will cover at least the whole interval. Then we
        # only need to take the minimum between them and we have the minimum
        # on the interval overall.
        lgK = Math.floor Math.log2(j - i + 1)

        argminLeft = @lookup[lgK][i]
        argminRight = @lookup[lgK][j - Math.pow(2, lgK) + 1]

        minLeft = @A[argminLeft]
        minRight = @A[argminRight]

        if minLeft <= minRight
            return argminLeft
        else
            return argminRight


# Linear time algorithm for minimum on a sliding window of size k
#
#   A   : an array
#   k   : length of the desired sliding window
#
# The resulting array contains the index (in A) of the minimum for each
# window.

slidingMinimum = (A, k) ->
    result = []
    deque = new Deque
    for i in [0..A.length - 1]
        do deque.shift until deque.isEmpty or deque.bottom >= i - k + 1
        do deque.pop   until deque.isEmpty or A[deque.top] <= A[i]
        deque.push i
        result.push deque.bottom if i >= k - 1
    return result


# Generates powers of 2 up to a given number

powersOf2UpTo = (n) ->
    k = 1
    until k > n
        yield k
        k *= 2
