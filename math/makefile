math: math.o
	ld -o math math.o

math.o: math.asm
	nasm -f elf -g -F dwarf math.asm