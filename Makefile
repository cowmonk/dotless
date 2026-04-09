#
# dotless (pdpmake / POSIX make)
#
# cowmonk <cowmonk@based.pt>
#

.POSIX:
SHELL   = /bin/sh

include config.mk

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
