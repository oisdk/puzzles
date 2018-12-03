from parse_input import matrix

print(sum(cell <= 0 for row in matrix for cell in row))
