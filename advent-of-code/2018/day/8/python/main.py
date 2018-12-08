def parse_tree(genr):
    num_children = next(genr)
    num_metas = next(genr)
    return ([parse_tree(genr) for _ in range(num_children)],
            [next(genr) for _ in range(num_metas)])

def sum_metadata(tree):
    return sum(tree[1]) + sum(sum_metadata(child) for child in tree[0])

def value(tree):
    if tree[0] == []:
        return sum(tree[1])
    else:
        children = [value(child) for child in tree[0]]
        return sum(children[i-1] for i in tree[1] if 0 < i <= len(children))

tree = parse_tree(int(num) for num in next(open('../input')).split(' '))

print(sum_metadata(tree))
print(value(tree))
