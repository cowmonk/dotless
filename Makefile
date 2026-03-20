#
# dotless (pdpmake / POSIX make)
#
# cowmonk <cowmonk@based.pt>
#

.POSIX:
SHELL   = /bin/sh

PREFIX ?= /
TOP     = $(shell pwd)
SRCDIR  = $(TOP)/sources
EXTDIR  = $(TOP)/extracted

VER_dwm  = 6.8
NAME_dwm = dwm-$(VER_dwm)
URL_dwm  = https://dl.suckless.org/dwm/$(NAME_dwm).tar.gz

VER_st  = 0.9.3
NAME_st = st-$(VER_st)
URL_st  = https://dl.suckless.org/st/$(NAME_st).tar.gz

VER_dmenu  = 5.4
NAME_dmenu = dmenu-$(VER_dmenu)
URL_dmenu  = https://dl.suckless.org/tools/$(NAME_dmenu).tar.gz

VER_slstatus  = 1.1
NAME_slstatus = slstatus-$(VER_slstatus)
URL_slstatus  = https://dl.suckless.org/tools/$(NAME_slstatus).tar.gz

LAPTOP  ?= 0  # laptop mode enables certain keybinds and battery monitoring
SCRIPTS ?= 0  # whether or not to install the useful scripts (auto enable if laptop mode is enabled)
VOL     ?= 0  # default volume step percent (default is 5 when at 0)
OBSD    ?= 0  # enables support for OBSD (in config.mk and stuff)
MIXER   ?= 0  # /dev/mixer support, if not then it falls back to amixer hacky script (only on linux)
FONT    ?= "" # set the global font for dmenu, and dwm (default: cozette:size=10)
ST_FONT ?= "" # set the font for st (default: cozette:size=12).

.PHONY: all build install clean distclean

all: build

$(SRCDIR)/%.tar.gz:
	@[ -d "$(SRCDIR)" ] || mkdir -p "$(SRCDIR)"
	@echo "pulling all sources..."
	@if [ ! -f "$(SRCDIR)/$(NAME_dwm).tar.gz" ]; then \
	 	echo "pulling ${NAME_dwm}"; \
		curl -fLo "${SRCDIR}/${NAME_dwm}.tar.gz"      ${URL_dwm}; \
	else \
		printf "> \033[92malready pulled $(NAME_dwm).tar.gz...\n\033[0m"; \
	fi
	@if [ ! -f "$(SRCDIR)/$(NAME_st).tar.gz" ]; then \
		echo "pulling ${NAME_st}"; \
		curl -fLo "${SRCDIR}/${NAME_st}.tar.gz"       ${URL_st}; \
	else \
		printf "> \033[92malready pulled $(NAME_st).tar.gz...\n\033[0m"; \
	fi
	@if [ ! -f "$(SRCDIR)/$(NAME_dmenu).tar.gz" ]; then \
		echo "pulling ${NAME_dmenu}"; \
		curl -fLo "${SRCDIR}/${NAME_dmenu}.tar.gz"    ${URL_dmenu}; \
	else \
		printf "> \033[92malready pulled $(NAME_dmenu).tar.gz...\n\033[0m"; \
	fi
	@if [ ! -f "$(SRCDIR)/$(NAME_slstatus).tar.gz" ]; then \
		echo "pulling ${NAME_slstatus}"; \
		curl -fLo "${SRCDIR}/${NAME_slstatus}.tar.gz" ${URL_slstatus}; \
	else \
		printf "> \033[92malready pulled $(NAME_slstatus).tar.gz...\n\033[0m"; \
	fi
	@printf "\033[1mpulled all sources!\n\033[0m"

$(EXTDIR)/%: $(SRCDIR)/%.tar.gz
	@echo "extracting..."
	@[ -d "$(EXTDIR)" ] || mkdir -p "$(EXTDIR)"
	@if [ ! -f "$(EXTDIR)/$(NAME_dwm)" ]; then \
		echo "extracting $(NAME_dwm).tar.gz..."; \
		tar -xzf "$(SRCDIR)/$(NAME_dwm).tar.gz" -C      "$(EXTDIR)"; \
	else \
		printf "> \033[92malready extracted $(NAME_dwm).tar.gz...\n\033[0m"; \
	fi
	@if [ ! -f "$(SRCDIR)/$(NAME_st)" ]; then \
		echo "extracting $(NAME_st).tar.gz..."; \
		tar -xzf "$(SRCDIR)/$(NAME_st).tar.gz" -C       "$(EXTDIR)"; \
	else \
		printf "> \033[92malready extracted $(NAME_st).tar.gz...\n\033[0m"; \
	fi
	@if [ ! -f "$(SRCDIR)/$(NAME_dmenu)" ]; then \
		echo "extracting $(NAME_dmenu).tar.gz..."; \
		tar -xzf "$(SRCDIR)/$(NAME_dmenu).tar.gz" -C    "$(EXTDIR)"; \
	else \
		printf "> \033[92malready extracted $(NAME_dmenu).tar.gz...\n\033[0m"; \
	fi
	@if [ ! -f "$(SRCDIR)/$(NAME_slstatus)" ]; then \
		echo "extracting $(NAME_slstatus).tar.gz..."; \
		tar -xzf "$(SRCDIR)/$(NAME_slstatus).tar.gz" -C "$(EXTDIR)"; \
	else \
		printf "> \033[92malready extracted $(NAME_slstatus).tar.gz...\n\033[0m"; \
	fi
	@printf "\033[1mextracted all sources!\n\033[0m"

build: $(EXTDIR)/%


install:

clean:

distclean: clean
	@rm -rf "$(SRCDIR)"
