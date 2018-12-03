from parse_input import matrix, coords

for nm, tx, ty, bx, by in coords:
    no_overlap = all(matrix[x][y] == 1 for x in range(tx, tx+bx) for y in range(ty, ty+by))
    if no_overlap:
        print(nm)
        break
