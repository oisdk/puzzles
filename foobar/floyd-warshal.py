def answer(m):
    n = len(m)

    if n == 1:
        return [1, 1]

    from fractions import Fraction, gcd

    dist, terminals = [], []
    for i, row in enumerate(m):
        d = sum(row)
        if d == 0:
            terminals.append(i)
        dist.append([Fraction(nm, d or 1) for nm in row])

    for k in xrange(n):
        dist = [[
            dist[i][j] + (dist[i][k] * 1 / (1 - dist[k][k]) * dist[k][j])
            for j in xrange(n)
        ] for i in xrange(n)]
    fracs = [dist[0][i] for i in terminals]

    from functools import reduce

    common_denom = reduce(lambda x, y: x * y // gcd(x, y),
                          (f.denominator for f in fracs))
    return [(f.numerator * common_denom) // f.denominator
            for f in fracs] + [common_denom]
