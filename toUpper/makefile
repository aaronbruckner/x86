toUpper: toUpper.o
	ld -o toUpper toUpper.o

toUpper.o: toUpper.asm
	nasm -f elf -g -F dwarf toUpper.asm