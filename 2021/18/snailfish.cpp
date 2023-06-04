#include <iostream>
#include <string>
#include <vector>

struct token {
	char tok = 0;
	unsigned int num = 0;

	token(char t) : tok(t), num(0) {}
	token(unsigned int n) : tok(0), num(n) {}
	
	static token from_char(char c) {
		if (c == '[' || c == ',' || c == ']') {
			return token(c);
		} else {
			return token((unsigned int)(c - '0'));
		}
	}

	std::string to_string() const {
		return tok ? std::string(1, tok) : std::to_string(num);
	}
};

class snailfish_number : public std::vector<token> {
	template<class It>
	void shift(unsigned int num, It first, It last) {
		for (; first != last; first++) {
			if (!first->tok) {
				first->num += num;
				return;
			}
		}
	}

	bool explode() {
		size_t depth = 0;
		for (iterator i = begin(); i != end(); i++) {
			if (i->tok == '[') {
				if (depth == 4) {
					shift((i + 1)->num, rbegin() + (end() - i), rend());
					shift((i + 3)->num, i + 5, end());
					i = erase(i, i + 5);
					insert(i, token((unsigned int)0));
					return true;
				}
				depth++;
			} else if (i->tok == ']') {
				depth--;
			}
		}
		return false;
	}

	bool split() {
		for (iterator i = begin(); i != end(); i++) {
			if (!i->tok && i->num > 9) {
				unsigned int n = i->num;
				i = erase(i, i + 1);
				insert(i, {'[', n / 2, ',', (n + 1) / 2, ']'});
				return true;
			}
		}
		return false;
	}

	void reduce() {
		while (explode() || split());
	}
public:
	snailfish_number() {}

	snailfish_number(const std::string &s) {
		for (const char &c : s) {
			push_back(token::from_char(c));
		}
	}

	snailfish_number& operator+=(const snailfish_number &other) {
		if (empty()) {
			*this = other;
		} else {
			insert(begin(), token('['));
			insert(end(), token(','));
			insert(end(), other.begin(), other.end());
			insert(end(), token(']'));
		}
		reduce();
		return *this;
	}

	std::string to_string() const {
		std::string s;
		for (const token &t : *this) {
			s.append(t.to_string());
		}
		return s;
	}

	unsigned int magnitude() const {
		unsigned int mag = 0, mul = 1;
		for (const token &t : *this) {
			switch (t.tok) {
			case '[': mul *= 3; break;
			case ',': mul = mul / 3 * 2; break;
			case ']': mul /= 2; break;
			default: mag += t.num * mul; break;
			}
		}
		return mag;
	}
};

int main(int argc, char *argv[]) {
	std::string line;
	std::vector<snailfish_number> nums;
	while (std::getline(std::cin, line)) {
		nums.push_back(snailfish_number(line));
	}
	if (nums.empty()) {
		return 0;
	}
	if (argc == 1) {
		snailfish_number num;
		for (const auto &n : nums) {
			num += n;
		}
		std::cout << num.to_string() << std::endl;
		std::cout << num.magnitude() << std::endl;
	} else {
		unsigned int maxmag = 0;
		for (auto i = nums.cbegin(); i != nums.cend(); i++) {
			for (auto j = nums.cbegin(); j != nums.cend(); j++) {
				if (i != j) {
					snailfish_number num = *i;
					num += *j;
					unsigned int mag = num.magnitude();
					if (maxmag < mag) {
						maxmag = mag;
					}
				}
			}
		}
		std::cout << maxmag << std::endl;
	}
	return 0;
}
