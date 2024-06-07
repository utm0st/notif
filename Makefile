all:
	nasm -f elf64 -g src/notif.asm -o notif.o && gcc -no-pie -nostartfiles -o notif notif.o

clean:
	rm notif.out && rm notif
