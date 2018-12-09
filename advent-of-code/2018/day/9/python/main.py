def max_points(num_players, final_points):
    from itertools import cycle
    from collections import deque

    marbles = deque([0])
    players = [0 for _ in range(num_players)]

    for player, marble in zip(cycle(range(len(players))), range(1, final_points + 1)):
        if marble % 23 == 0:
            marbles.rotate(7)
            players[player] += marble + marbles.pop()
            marbles.rotate(-1)
        else:
            marbles.rotate(-1)
            marbles.append(marble)

    return max(players)

with open('../input') as inp:
    line = next(inp).split()
    num_players, final_points = int(line[0]), int(line[6])
    print(max_points(num_players, final_points))
    print(max_points(num_players, final_points * 100))
