#!/usr/bin/awk -f

{
	for (i = 12; i <= 15; i++) {
		n = length($i)
		if (n == 2 || n == 3 || n == 4 || n == 7) {
			cnt++
		}
	}
}

END {
	print cnt
}
