memory: memory.o
	ld -o memory memory.o

memory.o: memory.asm
	nasm -f elf -g -F dwarf memory.asm