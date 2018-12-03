matrix = [ [ 2 for _ in range(1000) ] for _ in range(1000) ]

def parse_coord(line):
    nm, rest = line.split(' @ ')
    tx, rest = rest.split(',')
    ty, rest = rest.split(': ')
    bx, by = rest.split('x')
    return (int(nm[1:]), int(tx), int(ty), int(bx), int(by))

coords = list(map(parse_coord, open('../input')))

for _ , tx, ty, bx, by in coords:
    for x in range(tx, tx+bx):
        for y in range(ty, ty+by):
            matrix[x][y] -= 1
