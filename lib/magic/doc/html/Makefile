MAGICDIR = ../..

include $(MAGICDIR)/defs.mak

HTML_INSTDIR=$(LIBDIR)/magic/doc/html

install: $(DESTDIR)${HTML_INSTDIR}
	tar cf - . | (cd $(DESTDIR)${HTML_INSTDIR}; tar xf - )

$(DESTDIR)${HTML_INSTDIR}:
	${SCRIPTS}/mkdirs $(DESTDIR)${HTML_INSTDIR}

clean:

