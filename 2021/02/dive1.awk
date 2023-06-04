#!/usr/bin/awk -f

/forward/ { pos += $2 }
/down/ { depth += $2 }
/up/ { depth -= $2 }
END { print pos, depth, pos * depth  }
