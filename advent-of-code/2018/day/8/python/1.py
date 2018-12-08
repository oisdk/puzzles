from parse_input import tree

def sum_metadata(tree):
    return sum(tree[0]) + sum(sum_metadata(child) for child in tree[1])

print(sum_metadata(tree))
