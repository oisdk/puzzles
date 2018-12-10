import sys
import time
secs = int(sys.argv[1])
lower_bound = int(sys.argv[2])
upper_bound = int(sys.argv[3])
steps = upper_bound - lower_bound

from collections import namedtuple


class Point(namedtuple('Point', ['pos_x', 'pos_y', 'vel_x', 'vel_y'])):
    def step(self, fac=1):
        return Point(self.pos_x + self.vel_x * fac,
                     self.pos_y + self.vel_y * fac, self.vel_x, self.vel_y)


with open('../input') as inp:
    points = [
        Point(
            int(line[10:16]),
            int(line[18:24]), int(line[36:38]), int(line[40:42]))
        for line in inp
    ]

import curses

try:
    screen = curses.initscr()
    curses.noecho()
    curses.cbreak()
    curses.curs_set(False)
    screen.nodelay(True)
    screen.keypad(True)

    def print_map(points):
        min_x = min(p.pos_x for p in points)
        min_y = min(p.pos_y for p in points)
        max_x = max(p.pos_x for p in points)
        max_y = max(p.pos_y for p in points)
        height, width = screen.getmaxyx()
        for p in points:
            pos_y = int((height - 3) * ((p.pos_y - min_y) / (max_y - min_y)))
            pos_x = int((width - 1) * ((p.pos_x - min_x) / (max_x - min_x)))
            screen.addstr(pos_y + 1, pos_x, "●")

    i = 0

    def next_step(i, time=False):
        t = int(lower_bound + ((upper_bound - lower_bound) * (i / steps)))
        tstr = str(t)
        screen.clear()
        height, width = screen.getmaxyx()
        if 0 <= i < steps:
            screen.addstr(0, int(((width-1) * i) / steps), '|')
        if time:
            screen.addstr(0, 0, tstr)
        print_map([p.step(t) for p in points])
        screen.refresh()

    while i <= steps:
        if i == steps or screen.getch() == 32:
            next_step(i, time=True)
            screen.nodelay(False)
            while True:
                c = screen.getch()
                if c == 32:
                    i += 1
                    break
                elif c == curses.KEY_LEFT:
                    i -= 1
                elif c == curses.KEY_RIGHT:
                    i += 1
                next_step(i, time=True)
            screen.nodelay(True)
        else:
            next_step(i)
            i += 1
            curses.napms(int((secs * 1000) / steps))
finally:
    curses.nocbreak()
    curses.echo()
    curses.curs_set(True)
    screen.nodelay(False)
    screen.keypad(False)
    curses.endwin()
