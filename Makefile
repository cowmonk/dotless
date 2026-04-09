#
# dotless (pdpmake / POSIX make)
#
# cowmonk <cowmonk@based.pt>
#

.POSIX:
SHELL   = /bin/sh

include config.mk

.PHONY: all build pull extract install clean distclean

all: build

$(SRCDIR)/$(NAME_dwm).tar.gz:
	@[ -d "$(SRCDIR)" ] || mkdir -p "$(SRCDIR)"
	@echo "pulling ${NAME_dwm}"
	@curl -fLo "${SRCDIR}/${NAME_dwm}.tar.gz"        "${URL_dwm}"

$(SRCDIR)/$(NAME_st).tar.gz:
	@[ -d "$(SRCDIR)" ] || mkdir -p "$(SRCDIR)"
	@echo "pulling ${NAME_st}"
	@curl -fLo "${SRCDIR}/${NAME_st}.tar.gz"         "${URL_st}"

$(SRCDIR)/$(NAME_dmenu).tar.gz:
	@[ -d "$(SRCDIR)" ] || mkdir -p "$(SRCDIR)"
	@echo "pulling ${NAME_dmenu}"
	@curl -fLo "${SRCDIR}/${NAME_dmenu}.tar.gz"      "${URL_dmenu}"

$(SRCDIR)/$(NAME_slstatus).tar.gz:
	@[ -d "$(SRCDIR)" ] || mkdir -p "$(SRCDIR)"
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

extract: pull
	@printf "\033[1mextracted all sources!\n\033[0m"

build: extract
	
install: build

clean:

distclean: clean
	@rm -r "$(SRCDIR)"
	@rm -r "$(EXTDIR)"
