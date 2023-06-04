#!/usr/bin/awk -f

NR > 1 { ninc += $1 > last }
{ last = $1 }
END { print ninc }
