hexDump: hexDump.o
	ld -o hexDump hexDump.o

hexDump.o: hexDump.asm
	nasm -f elf -g -F dwarf hexDump.asm