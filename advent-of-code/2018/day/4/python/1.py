from parse_input import schedules

most_asleep_id, most_asleep_schedule = max(
    schedules.items(),
    key=lambda kv: sum(end - start for start, end in kv[1]))

most_asleep_minute = max(
    range(0,60),
    key=lambda minute: sum(1 for start, end in most_asleep_schedule if start <= minute < end))
print(most_asleep_id)
print(most_asleep_minute * most_asleep_id)
