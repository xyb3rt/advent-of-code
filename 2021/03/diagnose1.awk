{
	n = split($0, bits, "")
	for (i in bits) {
		cnt[i, bits[i]]++
	}
}

END {
	for (i = 1; i <= n; i++) {
		if (cnt[i, "0"] > cnt[i, "1"]) {
			epsilon += 2 ^ (n - i)
		} else {
			gamma += 2 ^ (n - i)
		}
	}
	print gamma, epsilon, gamma * epsilon
}
