#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <error.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct buf {
	char *s;
	size_t size;
	ssize_t len;
} buf;

struct stack {
	char s[1024];
	char *sp;
} stack;

int readline(struct buf *buf) {
start:	buf->len = getline(&buf->s, &buf->size, stdin);
	if (buf->len == -1) {
		if (errno == 0 && feof(stdin)) {
			return 0;
		}
		if (errno == EINTR) {
			goto start;
		}
		error(EXIT_FAILURE, errno, "getline");
	}
	if (buf->len > 0 && buf->s[buf->len - 1] == '\n') {
		buf->s[--buf->len] = '\0';
	}
	return 1;

}

char closing(char o) {
	static const char *const OPENS = "([{<";
	static const char *const CLOSES = ")]}>";
	char *s = strchr(OPENS, o);
	return s != NULL ? CLOSES[s - OPENS] : 0;
}

char check(const struct buf *buf, struct stack *stack) {
	stack->sp = stack->s;
	for (size_t i = 0; i < buf->len; i++) {
		char c = buf->s[i];
		char cc = closing(c);
		if (cc) {
			*stack->sp++ = cc;
		} else {
			if (stack->sp == stack->s || stack->sp[-1] != c) {
				return c;
			}
			stack->sp--;
		}
	}
	return 0;
}

size_t error_score(char c) {
	switch (c) {
	case ')': return 3;
	case ']': return 57;
	case '}': return 1197;
	case '>': return 25137;
	default:  return 0;
	}
}

size_t complete_score(struct stack *stack) {
	size_t score = 0;
	for (char *sp = stack->sp; sp != stack->s; sp--) {
		score *= 5;
		switch (sp[-1]) {
		case ')': score += 1; break;
		case ']': score += 2; break;
		case '}': score += 3; break;
		case '>': score += 4; break;
		}
	}
	return score;
}

struct vec_zu {
	size_t v[1024];
	size_t n;
} c_scores;

int cmp_zu(const void *a, const void *b) {
	ssize_t d = *(const size_t *)a - *(const size_t *)b;
	return d < 0 ? -1 : d > 0 ? 1 : 0;
}

int main(int argc, char *argv[]) {
	size_t c_score = 0, e_score = 0;
	while (readline(&buf)) {
		char err = check(&buf, &stack);
		if (err) {
			e_score += error_score(err);
		} else {
			size_t compl = complete_score(&stack);
			if (compl != 0) {
				printf("  %zu %s\n", compl, buf.s);
				c_scores.v[c_scores.n++] = compl;
			}
		}
	}
	if (c_scores.n > 0) {
		qsort(c_scores.v, c_scores.n, sizeof(c_scores.v[0]), cmp_zu);
		c_score = c_scores.v[c_scores.n / 2];
	}
	printf("%zu %zu\n", e_score, c_score);
	return 0;
}
