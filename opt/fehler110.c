struct A {
	int a, b, c;
};

struct A globa = { 1, 2, 3 };

__attribute__((noinline)) struct A funk(void) {
	struct A res;

	res.a = globa.c + 20;
	res.b = globa.b + 20;
	res.c = globa.a + 20;

	return res;
}

__attribute__((noinline)) struct A funk2(void) {
	struct A res;

	memcpy(&res, &globa, sizeof(res));

	res.a -= 20;
	res.b -= 20;
	res.c -= 20;

	return res;
}

int main(void) {
	globa = funk();
	printf("%d %d %d\n", globa.a, globa.b, globa.c);
	globa = funk2();
	printf("%d %d %d\n", globa.a, globa.b, globa.c);
	return 0;
}
