def parse_tree(genr):
    def go():
        num_children = next(genr)
        num_metas = next(genr)
        children = [ go() for _ in range(num_children) ]
        meta_vals = [ next(genr) for _ in range(num_metas) ]
        return (meta_vals, children)
    return go()

with open('../input') as inp:
    tree = parse_tree(int(num) for num in next(inp).split(' '))
