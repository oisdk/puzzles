import sys
import time
secs = int(sys.argv[1])
lower_bound = int(sys.argv[2])
upper_bound = int(sys.argv[3])
steps = upper_bound - lower_bound

with open('../input') as inp:
    points = [(int(line[10:16]), int(line[18:24]), int(line[36:38]), int(
        line[40:42])) for line in inp]

import curses

try:
    screen = curses.initscr()
    curses.noecho()
    curses.cbreak()
    curses.curs_set(False)
    screen.nodelay(True)
    screen.keypad(True)

    def print_map(points):
        min_x, min_y, max_x, max_y = points[0][0], points[0][1], points[0][
            0], points[0][1]
        for x, y in points:
            min_x, max_x, min_y, max_y = min(min_x, x), max(max_x, x), min(
                min_y, y), max(max_y, y)
        height, width = screen.getmaxyx()
        for x, y in points:
            screen.addstr(
                int((height - 3) * ((y - min_y) / (max_y - min_y))) + 1,
                int((width - 1) * ((x - min_x) / (max_x - min_x))), "●")

    i = 0

    def next_step(i, time=False):
        screen.clear()
        _, width = screen.getmaxyx()
        if 0 <= i < steps:
            screen.addstr(0, int(((width - 1) * i) / steps), '|')
        t = int(lower_bound + ((upper_bound - lower_bound) * (i / steps)))
        if time:
            screen.addstr(0, 0, str(t))
        print_map([(pos_x + vel_x * t, pos_y + vel_y * t)
                   for pos_x, pos_y, vel_x, vel_y in points])
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
