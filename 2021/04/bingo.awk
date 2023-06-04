#!/usr/bin/awk -f

function score(board, draw) {
	sum = 0
	win = 0
	split("", nmarkcol)
	for (row = 1; row <= nrow; row++) {
		nmarkrow = 0
		for (col = 1; col <= ncol; col++) {
			num = boards[board, row, col]
			if (draw < revdraws[num]) {
				sum += num
			} else if (++nmarkcol[col] == ncol ||
			           ++nmarkrow == nrow) {
				win = 1
			}
		}
	}
	return win ? sum * draws[draw] : -1
}

NR == 1 {
	ndraw = split($0, draws, /,/)
	for (i = 1; i <= ndraw; i++) {
		revdraws[draws[i]] = i
	}
	next
}

NF == 0 {
	nboard++
	nrow = 0
	next
}

{
	ncol = NF
	nrow++
	for (col = 1; col <= ncol; col++) {
		boards[nboard, nrow, col] = $col
	}
}

END {
	for (draw = 1; draw <= ndraw; draw++) {
		for (board = 1; board <= nboard; board++) {
			if (!(board in bingoed)) {
				s = score(board, draw)
				if (s >= 0) {
					bingoed[board] = 1
					nbingo++
					if (nbingo == 1) {
						print(s)
					} else if (nbingo == nboard) {
						print(s)
						exit
					}
				}
			}
		}
	}
}
