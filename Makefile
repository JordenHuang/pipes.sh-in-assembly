assembler = nasm
linker = gcc

filename = beta_pipe.asm
obj = pipe.o
target = pipe.out

util_filename = util.c
util_obj = util.o

all: $(obj) util.o
	$(linker) -no-pie $(obj) $(util_obj) -o $(target)

$(obj): $(filename)
	$(assembler) -f elf64 $(filename) -o $(obj)

util: $(util_filename)
	gcc -Wall -c $(util_filename)

clean:
	rm *.o *.out

run:
	./pipe.out
