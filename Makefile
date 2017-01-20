# dirmenu - directory menu
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dmenu.c stest.c util.c
OBJ = ${SRC:.c=.o}

all: options dirmenu stest

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

stest: stest.o
	@echo CC -o $@
	@${CC} -o $@ stest.o ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f dirmenu stest ${OBJ} dirmenu-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p dirmenu-${VERSION}
	@cp LICENSE Makefile README arg.h config.def.h config.mk dmenu.1 \
		drw.h util.h dmenu_path dmenu_run stest.1 ${SRC} \
		dirmenu-${VERSION}
	@tar -cf dirmenu-${VERSION}.tar dirmenu-${VERSION}
	@gzip dirmenu-${VERSION}.tar
	@rm -rf dirmenu-${VERSION}

install: all
	@echo installing executables to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f dirmenu dmenu_path dmenu_run stest ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dirmenu
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dmenu_path
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dmenu_run
	@chmod 755 ${DESTDIR}${PREFIX}/bin/stest
	@echo installing manual pages to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < dmenu.1 > ${DESTDIR}${MANPREFIX}/man1/dmenu.1
	@sed "s/VERSION/${VERSION}/g" < stest.1 > ${DESTDIR}${MANPREFIX}/man1/stest.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/dmenu.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/stest.1

uninstall:
	@echo removing executables from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/dirmenu
	@rm -f ${DESTDIR}${PREFIX}/bin/dmenu_path
	@rm -f ${DESTDIR}${PREFIX}/bin/dmenu_run
	@rm -f ${DESTDIR}${PREFIX}/bin/stest
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/dmenu.1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/stest.1

.PHONY: all options clean dist install uninstall
