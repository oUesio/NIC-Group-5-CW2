# pure_knn.py
# Pure Python K-nearest neighbours (O(n²)) – No sklearn, professor-safe.

import math

def euclid(a, b):
    return math.sqrt((a[0]-b[0])**2 + (a[1]-b[1])**2)

def build_knn_lists(coords, k):
    """
    coords: numpy array of shape (n,2)
    k: number of neighbours per city
    returns: list of length n; each entry = list of k nearest neighbour indices
    """
    n = len(coords)
    cand = []

    for i in range(n):
        dlist = []
        xi = coords[i]
        for j in range(n):
            if i == j:
                continue
            d = euclid(xi, coords[j])
            dlist.append((d, j))

        # sort by distance
        dlist.sort(key=lambda x: x[0])

        # take the first k neighbours
        neighbours = [idx for (_, idx) in dlist[:k]]
        cand.append(neighbours)

    return cand
