#!/usr/bin/awk -f

function line(x1, y1, x2, y2,    x, y) {
	x = x1
	y = y1
	for (;;) {
		cell[x, y]++
		if (x == x2 && y == y2) {
			break
		}
		x += x1 < x2 ? 1 : x1 > x2 ? -1 : 0
		y += y1 < y2 ? 1 : y1 > y2 ? -1 : 0

	}
}

BEGIN {
	FS = ",|( -> )"
	maxx = maxy = 0
}

{
	x1 = $1; y1 = $2; x2 = $3; y2 = $4
	if (maxx < x1) {
		maxx = x1
	}
	if (maxx < x2) {
		maxx = x2
	}
	if (maxy < y1) {
		maxy = y1
	}
	if (maxy < y2) {
		maxy = y2
	}
	line(x1, y1, x2, y2)
}

END {
	for (x = 0; x <= maxx; x++) {
		for (y = 0; y <= maxy; y++) {
			if (cell[x, y] > 1) {
				num++
			}
		}
	}
	print(num)
}
