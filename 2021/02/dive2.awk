#!/usr/bin/awk -f

/forward/ { pos += $2; depth += aim * $2 }
/down/ { aim += $2 }
/up/ { aim -= $2 }
END { print aim, pos, depth, pos * depth  }
