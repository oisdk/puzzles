matrix = [ [ 2 for _ in range(1000) ] for _ in range(1000) ]

with open('../../input') as inp:
    for line in inp:
        try:
            _ , rest = line.split('@ ')
            tx, rest = rest.split(',')
            ty, rest = rest.split(': ')
            bx, by = rest.split('x')
            for x in range(int(tx), int(tx)+int(bx)):
                for y in range(int(ty), int(ty)+int(by)):
                    matrix[x][y] -= 1
        except ValueError:
            pass

res = 0
for row in matrix:
    for cell in row:
        if cell < 0:
            res += 1
print(res)
