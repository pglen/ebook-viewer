PREFIX = /usr
EBOOKVIEWER_DIR = ${PREFIX}/share/easy-ebook-viewer
BINDIR = ${PREFIX}/bin
PYTHON = ${BINDIR}/python3
DISTRO := $(shell lsb_release -i | awk -F ':\t' '{print $$2}')

all: easy-ebook-viewer

easy-ebook-viewer:
	echo "#!/bin/sh" > easy-ebook-viewer
	echo "${PYTHON} ${EBOOKVIEWER_DIR}/main.py \"\$$@\"" >> easy-ebook-viewer
	chmod +x easy-ebook-viewer

install: install-bin install-desktop install-locale

install-bin: easy-ebook-viewer
	install -d ${BINDIR}
	install -d ${EBOOKVIEWER_DIR}
	install -d ${EBOOKVIEWER_DIR}/css
	install -d ${EBOOKVIEWER_DIR}/workers
	install -d ${EBOOKVIEWER_DIR}/components
	install -d ${EBOOKVIEWER_DIR}/misc
	install -d ${EBOOKVIEWER_DIR}/locale
	install easy-ebook-viewer ${BINDIR}
	install -m 644 css/night.css ${EBOOKVIEWER_DIR}/css/night.css
	install -m 644 css/day.css ${EBOOKVIEWER_DIR}/css/day.css
	install -m 644 src/main.py ${EBOOKVIEWER_DIR}/main.py
	install -m 644 src/main_window.py ${EBOOKVIEWER_DIR}/main_window.py
	install -m 644 src/components/__init__.py ${EBOOKVIEWER_DIR}/components/__init__.py
	install -m 644 src/components/file_chooser.py ${EBOOKVIEWER_DIR}/components/file_chooser.py
	install -m 644 src/components/header_bar.py ${EBOOKVIEWER_DIR}/components/header_bar.py
	install -m 644 src/components/viewer.py ${EBOOKVIEWER_DIR}/components/viewer.py
	install -m 644 src/components/about_dialog.py ${EBOOKVIEWER_DIR}/components/about_dialog.py
	install -m 644 src/components/chapters_list.py ${EBOOKVIEWER_DIR}/components/chapters_list.py
	install -m 644 src/components/preferences_dialog.py ${EBOOKVIEWER_DIR}/components/preferences_dialog.py
	install -m 644 src/constants.py ${EBOOKVIEWER_DIR}/constants.py
	install -m 644 src/workers/__init__.py ${EBOOKVIEWER_DIR}/workers/__init__.py
	install -m 644 src/workers/config_provider.py ${EBOOKVIEWER_DIR}/workers/config_provider.py
	install -m 644 src/workers/xml2obj.py ${EBOOKVIEWER_DIR}/workers/xml2obj.py
	install -m 644 src/workers/content_provider.py ${EBOOKVIEWER_DIR}/workers/content_provider.py
	install -m 644 misc/easy-ebook-viewer-scalable.svg ${EBOOKVIEWER_DIR}/misc/easy-ebook-viewer-scalable.svg

install-locale:
	install -d ${EBOOKVIEWER_DIR}/locale/pl
	install -d ${EBOOKVIEWER_DIR}/locale/pl/LC_MESSAGES
	install -m 644 po/pl.mo ${EBOOKVIEWER_DIR}/locale/pl/LC_MESSAGES/easy-ebook-viewer.mo
	install -d ${EBOOKVIEWER_DIR}/locale/fr
	install -d ${EBOOKVIEWER_DIR}/locale/fr/LC_MESSAGES
	install -m 644 po/fr.mo ${EBOOKVIEWER_DIR}/locale/fr/LC_MESSAGES/easy-ebook-viewer.mo
	install -d ${EBOOKVIEWER_DIR}/locale/es
	install -d ${EBOOKVIEWER_DIR}/locale/es/LC_MESSAGES
	install -m 644 po/es.mo ${EBOOKVIEWER_DIR}/locale/es/LC_MESSAGES/easy-ebook-viewer.mo
	install -d ${EBOOKVIEWER_DIR}/locale/ja
	install -d ${EBOOKVIEWER_DIR}/locale/ja/LC_MESSAGES
	install -m 644 po/ja.mo ${EBOOKVIEWER_DIR}/locale/ja/LC_MESSAGES/easy-ebook-viewer.mo

install-desktop:
	install -d ${PREFIX}/share/icons/hicolor/24x24/apps
	install -d ${PREFIX}/share/icons/hicolor/32x32/apps
	install -d ${PREFIX}/share/icons/hicolor/48x48/apps
	install -d ${PREFIX}/share/icons/hicolor/64x64/apps
	install -d ${PREFIX}/share/icons/hicolor/scalable/apps
	install -d ${PREFIX}/share/applications
	install -m 644 misc/easy-ebook-viewer-scalable.svg \
		${PREFIX}/share/icons/hicolor/scalable/apps/easy-ebook-viewer.svg
	install -m 644 misc/easy-ebook-viewer.desktop \
		${PREFIX}/share/applications/easy-ebook-viewer.desktop
ifeq "${DISTRO}" "Arch"
	gtk-update-icon-cache ${PREFIX}/share/icons/hicolor
else
	update-icon-caches ${PREFIX}/share/icons/hicolor
endif

clean:
	rm -f easy-ebook-viewer

uninstall: uninstall-bin uninstall-desktop

uninstall-bin:
	rm -rf ${EBOOKVIEWER_DIR}
	rm -rf ${BINDIR}/easy-ebook-viewer

uninstall-desktop:
	rm -f ${PREFIX}/share/applications/easy-ebook-viewer.desktop
	rm -f ${PREFIX}/share/icons/hicolor/*/apps/easy-ebook-viewer.png

.PHONY: all install install-bin install-desktop
