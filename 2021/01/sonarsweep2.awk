#!/usr/bin/awk -f

{
	for (i = 0; i < 3; i++) {
		sum[win - i] += $1
	}
	win++
}
NR > 3 { ninc += sum[win - 3] > sum[win - 4] }
END { print ninc }
