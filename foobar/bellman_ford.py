class Dist:
    def __init__(self, dist=None):
        self._dist = dist

    def __lt__(self, other):
        if self._dist is None:
            return False
        elif other._dist is None:
            return True
        else:
            return self._dist < other._dist

    def __add__(self, other):
        if self._dist is None:
            return Dist()
        elif other._dist is None:
            return Dist()
        else:
            return Dist(self._dist + other._dist)

class NegativeCycle(Exception):
    pass

def bellman_ford(g,source):
    dist = [ Dist() for _ in g ]
    dist[source] = Dist(0)
    for i in xrange(1, len(g)):
        for u, row in enumerate(g):
            for v, w in enumerate(row):
                if dist[u] + w < dist[v]:
                    dist[v] = dist[u] + w

    for u, row in enumerate(g):
        for v, w in enumerate(row):
            if dist[u] + w < dist[v]:
               raise NegativeCycle

    return dist

from itertools import permutations

def answer(times, time_limit):
    times = [ [ Dist(x) for x in xs ] for xs in times ]
    num_bunnies = len(times) - 2
    bunny_inds = range(1, num_bunnies + 1)
    try:
        dists = [ bellman_ford(times, i) for i in xrange(len(times)) ]
    except NegativeCycle:
        return range(num_bunnies)
    for i in xrange(num_bunnies, 0, -1):
        for candidate in permutations(bunny_inds, i):
            time_left = time_limit
            prev = 0
            for bunny in candidate:
                time_left -= dists[prev][bunny]._dist
                prev = bunny
            time_left -= dists[prev][-1]._dist
            if time_left >= 0:
                return sorted(b - 1 for b in candidate)
    return []
