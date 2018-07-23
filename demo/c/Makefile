# gcc nuklear_sdl_gl3.c -c -onuklear_sdl_gl3.o -I. -lGL -lSDL2 -O3 -Wall -DNDEBUG
# ar rcs libnuklear_sdl_gl3.a nuklear_sdl_gl3.o

CC=gcc
CFLAGS=-I. -O3 -Wall -DNDEBUG
DEPS=nuklear_sdl_gl3.h nuklear.h
OBJ=nuklear_sdl_gl3.o
LIBS=-lGL -lSDL2
ODIR=.

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS) $(LIBS)

libnuklear_sdl_gl3.a: $(OBJ)
	ar rcs -o $@ $^

.PHONY: clean

clean:
	rm -f $(ODIR)/*{.o,.a}