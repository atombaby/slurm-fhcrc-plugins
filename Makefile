PACKAGE    ?= slurm-fhcrc-plugins

LIBDIR     ?= /usr/lib
BINDIR     ?= /usr/bin
SBINDIR    ?= /sbin
LIBEXECDIR ?= /usr/sbin

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
	install --mode=0755 ./slurm-spank-plugins/tmpdir.so \
		$(DESTDIR)$(LIBDIR)/slurm;
	make -C ./slurm-spank-plugins/use-env DESTDIR=$(DESTDIR) install; 
	make -C ./slurm-spank-x11 DESTDIR=$(DESTDIR) install; 

subdirs-clean:
	@for d in $(SUBDIRS); do make -C $$d clean; done

slurm-spank-plugins:
	git clone https://code.google.com/p/slurm-spank-plugins

slurm-spank-x11:
	git clone git://github.com/edf-hpc/slurm-spank-x11.git

orig:
	cd .. && tar czf slurm-fhcrc-plugins_0.25.1.orig.tar.gz \
		--exclude='.git' --exclude='.gitignore' \
		slurm-fhcrc-plugins/Makefile \
		slurm-fhcrc-plugins/README.md \
		slurm-fhcrc-plugins/slurm-spank-*

