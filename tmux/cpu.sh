#!/usr/bin/env bash
# CPU usage widget for tmux status-right (Linux /proc/stat; prints nothing elsewhere).
# Usage: cpu.sh <color_low> <color_medium> <color_stress>
#
# Usage is the delta of /proc/stat counters since the previous sample, kept in a
# small state file, so no background collector is needed. tmux runs #() once per
# attached client on every status refresh: a sample younger than $min_age seconds
# is reused, otherwise each client would compute a near-zero-interval delta.

[ -r /proc/stat ] || exit 0

min_age=2
medium_threshold=30
stress_threshold=80
state="${TMPDIR:-/tmp}/tmux-cpu-$(id -u)"

read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
total=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_all=$((idle + iowait))
printf -v now '%(%s)T' -1

# Tenths of a percent; 0 until there is a previous sample to diff against.
pct=0
if read -r prev_ts prev_total prev_idle prev_pct 2>/dev/null < "$state"; then
  if [ $((now - prev_ts)) -lt "$min_age" ]; then
    pct=$prev_pct
    reused=1
  elif [ $((total - prev_total)) -gt 0 ]; then
    dt=$((total - prev_total))
    pct=$(((dt - (idle_all - prev_idle)) * 1000 / dt))
  fi
fi

if [ -z "$reused" ]; then
  # Write-then-rename: concurrent clients must never read a half-written file.
  printf '%s %s %s %s\n' "$now" "$total" "$idle_all" "$pct" > "$state.$$" \
    && mv -f "$state.$$" "$state"
fi

if [ "$pct" -ge $((stress_threshold * 10)) ]; then
  color=$3
elif [ "$pct" -ge $((medium_threshold * 10)) ]; then
  color=$2
else
  color=$1
fi

printf 'CPU:#[fg=%s]%d.%d%%#[default]' "${color:-default}" $((pct / 10)) $((pct % 10))
