# cython: boundscheck=False, wraparound=False, cdivision=True, language_level=3

cimport cython
from libc.math cimport sqrt

############################################################
# LOW-LEVEL DISTANCE FROM COORDS (INLINE C FUNCTION)
############################################################
cdef inline double edge_len(object coords, int u, int v):
    cdef double dx = float(coords[u, 0]) - float(coords[v, 0])
    cdef double dy = float(coords[u, 1]) - float(coords[v, 1])
    return sqrt(dx*dx + dy*dy)



############################################################
# 2-OPT COORD-BASED CANDIDATE SEARCH
############################################################
@cython.cdivision(True)
@cython.boundscheck(False)
@cython.wraparound(False)
cpdef tuple two_opt_cand(
        list tour,
        list cand,
        object coords,
        int max_iter=2000,
        bint verbose=False):
    """
    LKH-style 2-opt using candidate lists + coord distance.
    """

    cdef int n = len(tour)
    if n <= 2:
        return tour, 0.0

    cdef int i, j, t
    cdef int a, b, c, d, city
    cdef int l, r
    cdef double best_len = 0.0
    cdef double oldd, newd
    cdef bint improved
    pos = [0] * n     # tour position lookup

    ########################################################
    # INITIAL MAPPING + BASE COST
    ########################################################
    for i in range(n):
        pos[tour[i]] = i
    for i in range(n):
        a = tour[i]
        b = tour[(i+1) % n]
        best_len += edge_len(coords, a, b)


    ########################################################
    # MAIN 2-OPT IMPROVEMENT LOOP
    ########################################################
    for t in range(max_iter):
        improved = False

        for i in range(n):
            a = tour[i]
            b = tour[(i+1) % n]

            # candidates for a
            for c in cand[a]:
                j = pos[c]
                if j <= i+1 or j >= n-1:
                    continue

                d = tour[(j+1) % n]

                oldd = edge_len(coords, a, b) + edge_len(coords, c, d)
                newd = edge_len(coords, a, c) + edge_len(coords, b, d)

                if newd + 1e-12 < oldd:
                    # perform segment reversal
                    l = i+1
                    r = j
                    while l < r:
                        city      = tour[l]
                        tour[l]   = tour[r]
                        tour[r]   = city
                        l += 1
                        r -= 1

                    # rebuild pos
                    for j in range(n):
                        pos[tour[j]] = j

                    best_len += (newd - oldd)
                    improved = True
                    if verbose:
                        print(f"[2-OPT] iter={t} → {best_len:.2f}")

                    break  # restart search

            if improved:
                break

        if not improved:
            break

    return tour, best_len
