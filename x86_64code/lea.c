/*$ check leal\s+_?arr.*\+12\(%.*,%.*,4\), %eax $*/
static char arr[20];

char *foo(unsigned long x, unsigned long y)
{
	return &arr[(x*4)+y+12];
}

int main(void)
{
	(void)foo;
	return 0;
}
