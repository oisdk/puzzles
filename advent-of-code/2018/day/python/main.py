def power_level(serial, x, y):
    rid = x + 10
    plevel = rid * y
    plevel += serial
    plevel *= rid
    plevel = int(str(plevel)[-3])
    return plevel - 5


assert power_level(8, 3, 5) == 4
assert power_level(57, 122, 79) == -5
assert power_level(39, 217, 196) == 0
assert power_level(71, 101, 153) == 4

with open('../input') as inp:
    serial = int(next(inp))

grid = [[power_level(serial, x, y) for x in range(1, 301)]
        for y in range(1, 301)]


def conv(coord):
    x, y, size = coord
    return x + 1, y + 1, size


memo_dict = {}


def section_size(coord):
    try:
        return memo_dict[coord]
    except KeyError:
        x, y, size = coord
        if size == 0:
            memo_dict[coord] = 0
            return 0
        t = sum(grid[y][x:x + size])
        l = sum(row[x] for row in grid[y + 1:y + size])
        res = t + l + section_size((x + 1, y + 1, size - 1))
        memo_dict[coord] = res
        return res


part_1 = max(((x, y, 3) for x in range(300 - 3) for y in range(300 - 3)),
             key=section_size)

print('Part 1:', conv(part_1))

part_2 = max(((x, y, s)
              for s in range(300) for x in range(300 - s)
              for y in range(300 - s)),
             key=section_size)

print('Part 2:', part_2)
