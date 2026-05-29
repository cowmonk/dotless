#
# dotless (pdpmake / POSIX make)
#
# cowmonk <cowmonk@based.pt>
#

.POSIX:
SHELL = /bin/sh

USR     ?= $(whoami)
HOME_DIR = /home/$(USR)/

include config.mk

.PHONY: all build pull extract install clean distclean

all: build

$(SRCDIR)/$(NAME_dwm).tar.gz:
	@[ -d "$(SRCDIR)" ] || mkdir -p "$(SRCDIR)"
	@echo "pulling ${NAME_dwm}"
	@curl -fLo "${SRCDIR}/${NAME_dwm}.tar.gz"        "${URL_dwm}"

$(SRCDIR)/$(NAME_st).tar.gz:
	@echo "pulling ${NAME_st}"
	@curl -fLo "${SRCDIR}/${NAME_st}.tar.gz"         "${URL_st}"

$(SRCDIR)/$(NAME_dmenu).tar.gz:
	@echo "pulling ${NAME_dmenu}"
	@curl -fLo "${SRCDIR}/${NAME_dmenu}.tar.gz"      "${URL_dmenu}"

$(SRCDIR)/$(NAME_slstatus).tar.gz:
	@echo "pulling ${NAME_slstatus}"
	@curl -fLo "${SRCDIR}/${NAME_slstatus}.tar.gz"   "${URL_slstatus}"

$(EXTDIR)/$(NAME_dwm): $(SRCDIR)/$(NAME_dwm).tar.gz
	@[ -d "$(EXTDIR)" ] || mkdir -p "$(EXTDIR)"
	@echo "extracting $(NAME_dwm).tar.gz..."
	@tar -xzf "$(SRCDIR)/$(NAME_dwm).tar.gz" -C      "$(EXTDIR)"

$(EXTDIR)/$(NAME_st): $(SRCDIR)/$(NAME_st).tar.gz
	@echo "extracting $(NAME_st).tar.gz..."
	@tar -xzf "$(SRCDIR)/$(NAME_st).tar.gz" -C       "$(EXTDIR)"

$(EXTDIR)/$(NAME_dmenu): $(SRCDIR)/$(NAME_dmenu).tar.gz
	@echo "extracting $(NAME_dmenu).tar.gz..."
	@tar -xzf "$(SRCDIR)/$(NAME_dmenu).tar.gz" -C    "$(EXTDIR)"

$(EXTDIR)/$(NAME_slstatus): $(SRCDIR)/$(NAME_slstatus).tar.gz
	@echo "extracting $(NAME_slstatus).tar.gz..."
	@tar -xzf "$(SRCDIR)/$(NAME_slstatus).tar.gz" -C "$(EXTDIR)"

pull: $(SRCDIR)/$(NAME_dwm).tar.gz $(SRCDIR)/$(NAME_st).tar.gz $(SRCDIR)/$(NAME_dmenu).tar.gz $(SRCDIR)/$(NAME_slstatus).tar.gz
	@printf "\033[1mpulled all sources!\n\033[0m"	

extract: pull $(EXTDIR)/$(NAME_dwm) $(EXTDIR)/$(NAME_st) $(EXTDIR)/$(NAME_dmenu) $(EXTDIR)/$(NAME_slstatus)
	@printf "\033[1mextracted all sources!\n\033[0m"

.user:
	@sh -c "echo $(whoami) > .user"

build: extract .user
	@if [ ${NOUSR} -eq 1 ] && [ ${BSD} -eq 0 ]; then \
		find $(EXTDIR) -name config.mk -exec sed -i 's|/usr/|/|g' {} +; \
	elif []
	fi
	@(cd $(EXTDIR)/$(NAME_dwm)      && CC="$(CC)" $(MAKE))
	@(cd $(EXTDIR)/$(NAME_st)       && CC="$(CC)" $(MAKE))
	@(cd $(EXTDIR)/$(NAME_dmenu)    && CC="$(CC)" $(MAKE))
	@(cd $(EXTDIR)/$(NAME_slstatus) && CC="$(CC)" $(MAKE))
	
install: build
	#@(cd $(EXTDIR)/$(NAME_dwm)      && CC="$(CC)" PREFIX="$(PREFIX)" $(MAKE) install)
	#@(cd $(EXTDIR)/$(NAME_st)       && CC="$(CC)" PREFIX="$(PREFIX)" $(MAKE) install)
	#@(cd $(EXTDIR)/$(NAME_dmenu)    && CC="$(CC)" PREFIX="$(PREFIX)" $(MAKE) install)
	#@(cd $(EXTDIR)/$(NAME_slstatus) && CC="$(CC)" PREFIX="$(PREFIX)" $(MAKE) install)
	@if [ ${YASH} -eq 1 ]; then \
		#install -d -m 0755 "$(HOME_DIR)/.config/yash"; \
		#cp -av $(TOP)/files/config/yash/* $(HOME_DIR)/.config/yash/; \
		#chown -R $(USR):$(USR) $(HOME_DIR)/.config/;
		echo $(USR); \
		echo $(HOME_DIR); \
	fi

clean: build
	@(cd $(EXTDIR)/$(NAME_dwm)      && CC="$(CC)" $(MAKE) clean)
	@(cd $(EXTDIR)/$(NAME_st)       && CC="$(CC)" $(MAKE) clean)
	@(cd $(EXTDIR)/$(NAME_dmenu)    && CC="$(CC)" $(MAKE) clean)
	@(cd $(EXTDIR)/$(NAME_slstatus) && CC="$(CC)" $(MAKE) clean)

distclean: clean
	@echo "cleaning $(SRCDIR)"
	@rm -r "$(SRCDIR)"
	@echo "cleaning $(EXTDIR)"
	@rm -r "$(EXTDIR)"
	@echo "removing .user"
	@rm .user
