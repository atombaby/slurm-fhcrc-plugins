PACKAGE    ?= slurm-fhcrc-plugins

LIBNAME    ?= lib$(shell uname -m | grep -q x86_64 && echo 64)
LIBDIR     ?= /usr/$(LIBNAME)
BINDIR     ?= /usr/bin
SBINDIR    ?= /sbin
LIBEXECDIR ?= /usr/libexec

export LIBNAME LIBDIR BINDIR SBINDIR LIBEXECDIR PACKAGE

CFLAGS   = -Wall -ggdb

PLUGINS = 

LIBRARIES = 

SUBDIRS = \
	./slurm-spank-plugins \
	./slurm-spank-plugins/use-env \
	./slurm-spank-x11 

all: 
	make -C ./slurm-spank-plugins tmpdir.so
	make -C ./slurm-spank-plugins/use-env
	make -C ./slurm-spank-x11

.SUFFIXES: .c .o .so

.c.o: 
	$(CC) $(CFLAGS) -o $@ -fPIC -c $<
.o.so: 
	$(CC) -shared -o $*.so $< $(LIBS)

subdirs: 
	@for d in $(SUBDIRS); do make -C $$d; done

clean: subdirs-clean
	rm -f *.so *.o lib/*.o

install:
	@mkdir -p --mode=0755 $(DESTDIR)$(LIBDIR)/slurm
	install -m0755 \
		./slurm-spank-plugins/tmpdir.so \
		$(DESTDIR)$(LIBDIR)/slurm-llnl;
	make -C ./slurm-spank-plugins/use-env DESTDIR=$(DESTDIR) install; 
	make -C ./slurm-spank-x11 DESTDIR=$(DESTDIR) install; 

subdirs-clean:
	@for d in $(SUBDIRS); do make -C $$d clean; done
