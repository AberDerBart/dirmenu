# dirmenu - directory menu
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dmenu.c util.c
OBJ = ${SRC:.c=.o}

all: options dirmenu

options:
	@echo dirmenu build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

config.h:
	@echo creating $@ from config.def.h
	@cp config.def.h $@

${OBJ}: arg.h config.h config.mk drw.h

dirmenu: dmenu.o drw.o util.o
	@echo CC -o $@
	@${CC} -o $@ dmenu.o drw.o util.o ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f dirmenu ${OBJ} dirmenu-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p dirmenu-${VERSION}
	@cp LICENSE Makefile README arg.h config.def.h config.mk dirmenu.1 \
		drw.h util.h ${SRC} \
		dirmenu-${VERSION}
	@tar -cf dirmenu-${VERSION}.tar dirmenu-${VERSION}
	@gzip dirmenu-${VERSION}.tar
	@rm -rf dirmenu-${VERSION}

install: all
	@echo installing executables to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f dirmenu ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dirmenu
	@echo installing manual pages to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < dirmenu.1 > ${DESTDIR}${MANPREFIX}/man1/dirmenu.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/dirmenu.1

uninstall:
	@echo removing executables from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/dirmenu
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/dirmenu.1

.PHONY: all options clean dist install uninstall
