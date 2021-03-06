SimpleRMQ = require('./simple-rmq')

# RMQ data structure for O(1) time queries and O(n) space, assuming unit
# distance (+1/-1) between adjacent elements on the array

module.exports = UnitDistanceRMQ = class
    # Constructs a static data structure for RMQ on a given array
    #
    #   A : an array

    constructor: (@A) ->
        @chunkSize = Math.max 1, Math.floor((Math.log2 @A.length) / 2)
        @chunks = chunked @A, @chunkSize

        do @_buildLookup

        # This summary takes O(n / lg n) space by definition, so we can just
        # use the simple RMQ and we have O(1) query and O(n) space, because
        # the logs cancel!
        @summary = (Math.min chunk... for chunk in @chunks)
        @summaryRMQ = new SimpleRMQ @summary

    # Returns the index of the minimum element on the given range
    #
    #   i, j    : range boundaries (0 <= i <= j < |A|)

    rangeMinimum: (i, j) ->
        # This looks complicated, but it's mostly edge-case handling, because
        # intervals are a pain to work with.
        # All we do is essentially four queries: one on the summary and three
        # on the "chunks", all of which take constant time. Then we
        # consolidate these by comparing their results and returning the
        # minimum between them.

        left = Math.floor(i / @chunkSize)
        leftCenter = Math.ceil(i / @chunkSize)
        right = Math.floor(j / @chunkSize)

        if leftCenter >= right 
            center = leftCenter
        else
            center = @summaryRMQ.rangeMinimum leftCenter, right

        argminLeft = left * @chunkSize +
            @_doLookup @chunks[left].type,
                i - left * @chunkSize,
                Math.min(j - left * @chunkSize, @chunkSize - 1)

        argminCenter = center * @chunkSize +
            @_doLookup @chunks[center].type,
                Math.max(i - center * @chunkSize, 0),
                Math.min(j - center * @chunkSize, @chunkSize - 1)

        argminRight = right * @chunkSize +
            @_doLookup @chunks[right].type,
                Math.max(i - right * @chunkSize, 0),
                j - right * @chunkSize

        minLeft = @A[argminLeft]
        minCenter = @A[argminCenter]
        minRight = @A[argminRight]

        if minLeft <= minCenter
            if minLeft <= minRight
                return argminLeft
            else
                return argminRight
        else
            if minCenter <= minRight
                return argminCenter
            else
                return argminRight

    _doLookup: (type, i, j) -> @lookup[type][i][j - i]

    # Builds the lookup table for the RMQs on the smaller "chunks" of size
    # 1/2 lg n

    _buildLookup: () ->
        # Generator for all possible "types" of chunks. Since we assume the
        # difference between adjacent elements in the array is either +1 or
        # -1, and RMQ is invariant when adding/subtracting a constant from all
        # elements of the array, these equate to all combinations of sequences
        # starting at 0 with unit deltas and length k. There are O(2^k) such
        # sequences, and since k = O(1/2 lg n), this gives O(sqrt(n)) types of
        # chunks.
        generate = (n) ->
            return yield [0] if n == 1
            for tail from generate(n - 1)
                last = tail[tail.length - 1]
                yield tail.concat [last + 1]
                yield tail.concat [last - 1]

        # For each of the O(sqrt(n)) types, we generate O(k^2) = O(lg^2 n)
        # answers correspoding to all RMQs possible on such sequence.
        # In total, this gives O(sqrt(n) lg^2 n) values, which is o(n), so
        # it's essentially free for our purposes.
        @lookup = []
        for type from generate @chunkSize
            rmq = new SimpleRMQ type
            lookup = []
            for i in [0..type.length - 1]
                lookup[i] = for j in [i..type.length - 1]
                    rmq.rangeMinimum i, j
            @lookup.push lookup

        # Finally, we tag each chunk with it's correspoding "type", to make
        # lookups constant-time.
        # The type is an integer given by converting the sequence of diffs
        # (which are always +1 or -1) into a binary number (+1 => 0, -1 => 1).
        # This works because `generate` is implemented with this ordering in
        # mind.
        # In particular, for any k:
        #   (type x for x from generate k) == [0..Math.pow(2, k - 1) - 1]
        type = (seq) ->
            i = 0
            p = 1
            for j in [seq.length - 1..1]
                i += p if seq[j] < seq[j - 1]
                p *= 2
            return i

        for chunk in @chunks
            chunk.type = type chunk


# Breaks an array into fixed-size chunks.
# If the array length is not a multiple of the chunk size, the last chunk will
# be smaller than k.
#
#   A   : an array
#   k   : desired chunk size

chunked = (A, k) ->
    (A[i * k..(i + 1) * k - 1] for i in [0..Math.ceil(A.length / k) - 1])
