from itertools import combinations


def answer(num_buns, num_required):
    combos = [
        set(c)
        for c in combinations(range(num_buns), num_buns + 1 - num_required)
    ]
    return [[j for j, c in enumerate(combos) if i in c]
            for i in xrange(num_buns)]