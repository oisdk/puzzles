from collections import namedtuple

class Point(namedtuple('Point', ['pos_x', 'pos_y', 'vel_x', 'vel_y'])):
    def step(self, fac=1):
        return Point(self.pos_x + self.vel_x * fac, self.pos_y + self.vel_y * fac, self.vel_x, self.vel_y)

with open('../input') as inp:
    points = [
        Point(
            int(line[10:16]), int(line[18:24]), int(line[36:38]), int(line[40:42]))
        for line in inp
    ]

def print_map(points):
    min_x = min(p.pos_x for p in points)
    min_y = min(p.pos_y for p in points)
    max_x = max(p.pos_x for p in points)
    max_y = max(p.pos_y for p in points)
    board = [[' ' for _ in range(201)] for _ in range(21)]
    for p in points:
        pos_y = int(20 * ((p.pos_y - min_y) / (max_y - min_y)))
        pos_x = int(200 * ((p.pos_x - min_x) / (max_x - min_x)))
        board[pos_y][pos_x] = '●'
    for row in board:
        print(''.join(row))

import time
import sys
steps = int(sys.argv[1])
lower_bound = int(sys.argv[2])
upper_bound = int(sys.argv[3])
for i in range(steps):
    t = int(lower_bound + ((upper_bound - lower_bound) * (i / steps)))
    tstr = str(t)
    print(tstr, '━' * (200 - len(tstr)) )
    print_map([ p.step(t) for p in points ])
    time.sleep(3 / float(steps))
