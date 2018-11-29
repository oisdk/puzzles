def show_gas(xs):
    print '\n'.join(''.join('O' if x else '.' for x in row) for row in xs)


def from_string(xs):
    return [[c == 'O' for c in row.strip()] for row in xs.split('\n')]


def step(xs):
    ylen = len(xs)
    xlen = len(xs[0])

    return [[
        sum((xs[y][x], xs[y + 1][x], xs[y][x + 1], xs[y + 1][x + 1])) == 1
        for x in xrange(xlen - 1)
    ] for y in xrange(ylen - 1)]

from itertools import (chain, imap)
from functools import partial

def prev(cur, below, i=0):
    if i == len(cur):
        yield 0
        yield 1
    else:
        tot = (below >> i) & 3
        if tot == 0:
            if cur[i]:
                for prev_s in prev(cur, below, i+1):
                    yield (prev_s << 1) | ~ (prev_s | ~ 1)
            else:
                for prev_s in prev(cur, below, i+1):
                    yield (prev_s << 1) | (prev_s & 1)
        elif tot == 3:
            if not cur[i]:
                for prev_s in prev(cur, below, i+1):
                    yield (prev_s << 1) | 1
                    yield prev_s << 1
        else:
            if cur[i]:
                for prev_s in prev(cur, below, i+1):
                    if not prev_s & 1:
                        yield prev_s << 1
            else:
                for prev_s in prev(cur, below, i+1):
                    yield (prev_s << 1) | 1
                    if prev_s & 1:
                        yield prev_s << 1

def answer(g):
    # g = [list(col) for col in zip(*g)]
    bottom = xrange(0, 2**(len(g[0]) + 1))
    for i in xrange(len(g) - 1, -1, -1):
        bottom = chain.from_iterable(imap(partial(prev, g[i]), bottom))
    return sum(1 for _ in bottom)


def make_board(ylen, xlen, i=100):
    from random import choice

    xs = [[choice((False, True)) for _ in xrange(xlen + i)]
          for _ in xrange(ylen + i)]

    for _ in xrange(i):
        xs = step(xs)
    return xs

slow_board = from_string("""O...O...
                            O..O....
                            ...O...O
                            ....OO..""")

from timeit import default_timer as timer

start = timer()
answer(slow_board)
end = timer()

print(end - start)

assert answer(
    from_string("""O.O
                   .O.
                   O.O""")) == 4
assert answer(
    from_string("""O.O..OOO
                   O.O...O.
                   OOO...O.
                   O.O...O.
                   O.O..OOO""")) == 254
assert answer(
    from_string("""OO.O.O.OO.
                   OO....OOO.
                   OO.......O
                   .O....OO..""")) == 11567
