def greedy_pack_by_ratio(instance, tour):
    """
    Simple greedy packing heuristic:
    Pick items in descending order of profit/weight ratio
    but only items located in cities we actually visit (tour order).
    """

    # Construct list of items in tour order
    items = []
    for city in tour:
        for it in instance.items_by_city[city]:
            items.append(it)

    # Sort by profit/weight ratio
    items.sort(key=lambda it: it["profit"] / it["weight"], reverse=True)

    z = [0] * len(instance.items)
    current_weight = 0

    for it in items:
        idx = it["index"] - 1
        w = it["weight"]
        if current_weight + w <= instance.capacity:
            z[idx] = 1
            current_weight += w

    return z
