class Schedule:
    def __init__(self):
        self._record = []
        self._fell_asleep_at = None

    def wake(self, date):
        if self._fell_asleep_at is not None:
            self._record.append((self._fell_asleep_at, date))
            self._fell_asleep_at = None

    def sleep(self, date):
        if self._fell_asleep_at is None:
            self._fell_asleep_at = date


from collections import defaultdict

schedules = defaultdict(Schedule)

import re
guard_id_pat = re.compile('#(?P<guard_id>\d+)')

with open('../input') as inp:
    cur_guard = None
    for line in sorted(inp):
        guard_id = guard_id_pat.search(line)
        date = line[1:17]
        if guard_id:
            if cur_guard is not None:
                schedules[cur_guard].wake(date)
            cur_guard = int(guard_id.group('guard_id'))
            schedules[cur_guard].wake(date)
        else:
            if line[-3] == 'u':
                schedules[cur_guard].wake(date)
            else:
                schedules[cur_guard].sleep(date)

schedules = {
    key: [(int(start[14:]), int(end[14:]))
          for start, end in val._record]
    for key, val in schedules.items()
}
