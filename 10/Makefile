LIBS = lib/io.o lib/str.o lib/array.o lib/time.o lib/rand.o lib/math.o
.PHONY: default compile build run debug
default: build run
compile: lib/io.s
	as --gstabs lib/io.s -o lib/io.o
	as --gstabs lib/str.s -o lib/str.o
	as --gstabs lib/array.s -o lib/array.o
	as --gstabs lib/time.s -o lib/time.o
	as --gstabs lib/rand.s -o lib/rand.o
	as --gstabs lib/math.s -o lib/math.o
build: main.s
	as main.s -o main.o
	ld main.o $(LIBS) -o main
run: main
	./main $(ARGS)
debug: main.s
	as --gstabs -o main.o main.s
	ld main.o $(LIBS) -o main
	gdb main
