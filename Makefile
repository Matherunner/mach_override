CC = clang
CFLAGS = -Wall -Wextra -Os
SRCS = mach_override.c $(wildcard libudis86/*.c)
BUILDDIR = build
BUILDDIR32 = $(BUILDDIR)/x86
BUILDDIR64 = $(BUILDDIR)/x86_64
OBJS = $(patsubst %.c, %.o, $(SRCS))
OBJS32 = $(addprefix $(BUILDDIR32)/, $(OBJS))
OBJS64 = $(addprefix $(BUILDDIR64)/, $(OBJS))
TARGET32 = $(BUILDDIR)/libmach_override_32.a
TARGET64 = $(BUILDDIR)/libmach_override_64.a

all: directories $(TARGET32) $(TARGET64)

directories: $(BUILDDIR32)/libudis86 $(BUILDDIR64)/libudis86

$(BUILDDIR32)/libudis86:
	mkdir -p $@

$(BUILDDIR64)/libudis86:
	mkdir -p $@

$(TARGET32): $(OBJS32)
	libtool -static -o $@ $^

$(TARGET64): $(OBJS64)
	libtool -static -o $@ $^

build/x86/%.o: %.c
	$(CC) -m32 $(CFLAGS) -c $< -o $@

build/x86_64/%.o: %.c
	$(CC) -m64 $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILDDIR)
