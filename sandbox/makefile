sandbox: sandbox.o
	ld -o sandbox sandbox.o

sandbox.o: sandbox.asm
	nasm -f elf -g -F dwarf sandbox.asm