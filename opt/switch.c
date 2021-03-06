#include <assert.h>
#include <limits.h>

static int switch1(int k)
{
	switch(k) {
	case 42:
		return 5;
	case 13:
		return 7;
	case INT_MAX:
		return 8;
	case -1:
	case INT_MIN:
		return 9;
	}
	return 3;
}

static int __attribute__((noinline)) switch2(int k)
{
	return switch1(k);
}

int main(void)
{
	assert(switch1(42) == 5);
	assert(switch1(13) == 7);
	assert(switch1(-1) == 9);
	assert(switch1(700) == 3);
	assert(switch1(-32000) == 3);
	assert(switch1(INT_MAX) == 8);
	assert(switch1(INT_MIN) == 9);
	assert(switch2(42) == 5);
	assert(switch2(13) == 7);
	assert(switch2(-1) == 9);
	assert(switch2(700) == 3);
	assert(switch2(-32000) == 3);
	assert(switch2(INT_MAX) == 8);
	assert(switch2(INT_MIN) == 9);
	return 0;
}
