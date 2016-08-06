CC ?= gcc
CFLAGS += -std=c99 -W -Wall -pedantic -O3 -march=native -ftree-vectorize \
	-D_POSIX_C_SOURCE=200809L \
	-D_FILE_OFFSET_BITS=64 \
	-DLODEPNG_NO_COMPILE_ANCILLARY_CHUNKS \
	-DLODEPNG_NO_COMPILE_CPP \
	-DLODEPNG_NO_COMPILE_ALLOCATORS \
	-DLODEPNG_NO_COMPILE_ENCODER
LDFLAGS +=
PREFIX := /usr/local

OBJS = sendpos.o
EXEC = sendpos

all : $(EXEC)

clean :
	-rm -f $(OBJS) $(EXEC)
	-rm *.pos *.gz debug.* *.backup

$(EXEC) : $(OBJS)
	@printf "%-16s%s\n" LD $@
	@$(CC) $(OBJS) $(LDFLAGS) -o $@

%.o : %.c
	@printf "%-16s%s\n" CC $@
	@$(CC) -c $(CFLAGS) -o $@ $<

