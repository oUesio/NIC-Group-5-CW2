# cython: boundscheck=False, wraparound=False, cdivision=True, language_level=3

cimport cython
from libc.math cimport sqrt

############################################################
# basic tour distance
############################################################
cdef inline double edge_len(object coords, int u, int v):
    cdef double dx = float(coords[u,0]) - float(coords[v,0])
    cdef double dy = float(coords[u,1]) - float(coords[v,1])
    return sqrt(dx*dx + dy*dy)

cdef double tour_len(list tour, object coords):
    cdef int i, n=len(tour)
    cdef double L=0
    for i in range(n):
        L += edge_len(coords, tour[i], tour[(i+1)%n])
    return L


############################################################
# temporary 3-opt placeholder
############################################################
cpdef tuple three_opt_cy(list tour,
                         list cand,
                         object coords,
                         int max_iter=500,
                         bint verbose=False):
    """
    3-opt stub for now so entire pipeline runs clean.

    Returns (unchanged_tour, length)
    """
    cdef double L = tour_len(tour, coords)
    if verbose:
        print(f"[3-OPT] stub → {L:.2f}")
    return tour, L
