matrix = [ [ 2 for _ in range(1000) ] for _ in range(1000) ]

def parse_coord(line):
    nm, rest = line.split(' @ ')
    tx, rest = rest.split(',')
    ty, rest = rest.split(': ')
    bx, by = rest.split('x')
    return (int(nm[1:]), int(tx), int(ty), int(bx), int(by))

with open('../../input') as inp:
    for line in inp:
        _ , tx, ty, bx, by = parse_coord(line)
        for x in range(tx, tx+bx):
            for y in range(ty, ty+by):
                matrix[x][y] -= 1

res = 0
for row in matrix:
    for cell in row:
        if cell <= 0:
            res += 1
print(res)
