def value(tree):
    if tree[1] == []:
        return sum(tree[0])
    else:
        children = [value(child) for child in tree[1]]
        return sum(children[i-1] for i in tree[0] if 0 < i <= len(children))

from parse_input import tree
print(value(tree))
