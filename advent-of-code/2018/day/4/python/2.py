from parse_input import schedules
from operator import *

freq_sleeps = {
    guard_id: max(((minute, sum(1 for start, end in schedule
                                if start <= minute < end))
                   for minute in range(0, 60)),
                  key=itemgetter(1))
    for guard_id, schedule in schedules.items()
}

most_asleep_id, (most_asleep_minute, _) = max(
    freq_sleeps.items(),
    key=lambda kv: kv[1][1])

print(most_asleep_minute * most_asleep_id)
