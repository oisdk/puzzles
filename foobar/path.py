class Node(object):
    def __init__(self, pos, prio=20*20*2):
        self.pos = pos
        self.prio = prio
        self.prev = None

    def __lt__(self, other):
        return self.prio < other.prio

    def __eq__(self, other):
        return self.prio == other.prio

    def __repr__(self):
        return str((self.prio, self.pos))


def answer(maze):
    ydim, xdim = len(maze), len(maze[0])

    import heapq

    vals = [[[Node((c, y, x)) for x in xrange(xdim)] for y in xrange(ydim)] for c in (0, 1)]

    vals[0][0][0].prio = 1
    q = []

    for l in vals:
        for ys in l:
            for xs in ys:
                heapq.heappush(q, xs)

    def neighbours(c, y, x):
        for yv in (y-1, y+1):
            if 0 <= yv < ydim:
                if maze[yv][x] == 0:
                    yield c, yv, x
                elif c == 0:
                    yield 1, yv, x
        for xv in (x-1, x+1):
            if 0 <= xv < xdim:
                if maze[y][xv] == 0:
                    yield c, y, xv
                elif c == 0:
                    yield 1, y, xv

    while q:
        u = heapq.heappop(q)
        if u.pos[1:] == (ydim-1, xdim-1):
            return u.prio
        for c, y, x in neighbours(*u.pos):
            v = vals[c][y][x]
            alt = u.prio + 1
            if alt < v.prio:
                v.prio = alt
                v.prev = u
                heapq.heapify(q)
