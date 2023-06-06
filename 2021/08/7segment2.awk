#!/usr/bin/awk -f

function contains(s, p,    i) {
	for (i = length(p); i > 0; i--) {
		if (index(s, substr(p, i, 1)) == 0) {
			return 0
		}
	}
	return  1
}

function find(n,    i, l) {
	for (i = 1; i <= 10; i++) {
		l = length($i)
		if ((n == 1 && l == 2) ||
		    (n == 4 && l == 4) ||
		    (n == 7 && l == 3) ||
		    (n == 8 && l == 7) ||
		    (n == 3 && l == 5 && contains($i, digits[1])) ||
		    (n == 9 && l == 6 && contains($i, digits[3])) ||
		    (n == 2 && l == 5 && !contains(digits[9], $i)) ||
		    (n == 5 && l == 5 && $i != digits[2] && $i != digits[3]) ||
		    (n == 0 && l == 6 && !contains($i, digits[5])) ||
		    (n == 6 && l == 6 && $i != digits[9] && $i != digits[0])) {
			digits[n] = $i
			return
		}
	}
}

function decode(s,    n, d) {
	for (n in digits) {
		d = digits[n]
		if (length(d) == length(s) && contains(d, s)) {
			return n
		}
	}
	return 0
}

{
	find(1)
	find(4)
	find(7)
	find(8)
	find(3)
	find(9)
	find(2)
	find(5)
	find(0)
	find(6)
	num = 0
	for (i = 12; i <= 15; i++) {
		num = num * 10 + decode($i)
	}
	sum += num
}

END {
	print sum
}
