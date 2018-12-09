with open('../input') as inp:
    line = next(inp).split()
    num_players, final_points = int(line[0]), int(line[6])


from itertools import *

marbles = [0]
players = [0 for _ in range(num_players)]
position = 0

for player, marble in zip(cycle(range(len(players))), range(1, final_points + 1)):
    if marble >= 23 and marble % 23 == 0:
        position = (position - 7) % len(marbles)
        players[player] += marbles.pop(position)
    else:
        position = (position + 2) % len(marbles)
        marbles.insert(position, marble)

for marble in range(23, final_points + 1, 23):
    players[marble % num_players - 1] += marble

print(max(players))
