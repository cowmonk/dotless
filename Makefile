#
# dotless (pdpmake / POSIX make)
#
# cowmonk <cowmonk@based.pt>
#

.POSIX:
SHELL = /bin/sh

USR      ?=
HOME_DIR ?=

include config.mk

.PHONY: all build pull extract configure install clean distclean

all: build

$(SRCDIR)/$(NAME_dwm).tar.gz:
	@[ -d "$(SRCDIR)" ] || mkdir -p "$(SRCDIR)"
	@echo "pulling ${NAME_dwm}"
	@curl -fLo "${SRCDIR}/${NAME_dwm}.tar.gz"        "${URL_dwm}"

$(SRCDIR)/$(NAME_st).tar.gz:
	@mkdir -p "$(SRCDIR)"
	@echo "pulling ${NAME_st}"
	@curl -fLo "${SRCDIR}/${NAME_st}.tar.gz"         "${URL_st}"

$(SRCDIR)/$(NAME_dmenu).tar.gz:
	@mkdir -p "$(SRCDIR)"
	@echo "pulling ${NAME_dmenu}"
	@curl -fLo "${SRCDIR}/${NAME_dmenu}.tar.gz"      "${URL_dmenu}"

$(SRCDIR)/$(NAME_slstatus).tar.gz:
	@mkdir -p "$(SRCDIR)"
	@echo "pulling ${NAME_slstatus}"
	@curl -fLo "${SRCDIR}/${NAME_slstatus}.tar.gz"   "${URL_slstatus}"

$(EXTDIR)/$(NAME_dwm): $(SRCDIR)/$(NAME_dwm).tar.gz
	@[ -d "$(EXTDIR)" ] || mkdir -p "$(EXTDIR)"
	@echo "extracting $(NAME_dwm).tar.gz..."
	@tar -xzf "$(SRCDIR)/$(NAME_dwm).tar.gz" -C      "$(EXTDIR)"

$(EXTDIR)/$(NAME_st): $(SRCDIR)/$(NAME_st).tar.gz
	@mkdir -p "$(EXTDIR)"
	@echo "extracting $(NAME_st).tar.gz..."
	@tar -xzf "$(SRCDIR)/$(NAME_st).tar.gz" -C       "$(EXTDIR)"

$(EXTDIR)/$(NAME_dmenu): $(SRCDIR)/$(NAME_dmenu).tar.gz
	@mkdir -p "$(EXTDIR)"
	@echo "extracting $(NAME_dmenu).tar.gz..."
	@tar -xzf "$(SRCDIR)/$(NAME_dmenu).tar.gz" -C    "$(EXTDIR)"

$(EXTDIR)/$(NAME_slstatus): $(SRCDIR)/$(NAME_slstatus).tar.gz
	@mkdir -p "$(EXTDIR)"
	@echo "extracting $(NAME_slstatus).tar.gz..."
	@tar -xzf "$(SRCDIR)/$(NAME_slstatus).tar.gz" -C "$(EXTDIR)"

pull: $(SRCDIR)/$(NAME_dwm).tar.gz $(SRCDIR)/$(NAME_st).tar.gz $(SRCDIR)/$(NAME_dmenu).tar.gz $(SRCDIR)/$(NAME_slstatus).tar.gz
	@printf "\033[1mpulled all sources!\n\033[0m"	

extract: pull $(EXTDIR)/$(NAME_dwm) $(EXTDIR)/$(NAME_st) $(EXTDIR)/$(NAME_dmenu) $(EXTDIR)/$(NAME_slstatus)
	@printf "\033[1mextracted all sources!\n\033[0m"

$(EXTDIR)/.user: extract
	@test -f "$@" || id -un > "$@"

configure: extract
	@set -e; \
	for name in $(NAME_dwm) $(NAME_st) $(NAME_dmenu) $(NAME_slstatus); do \
		dir="$(EXTDIR)/$$name"; \
		tool=$${name%-*}; \
		tar -xOf "$(SRCDIR)/$$name.tar.gz" "$$name/config.mk" > "$$dir/config.mk"; \
		if [ "$(BSD)" -eq 1 ]; then \
			case $$tool in \
				dwm|dmenu) sed 's/^#[[:space:]]*\(FREETYPEINC =.*\)/\1/; s/^#[[:space:]]*\(MANPREFIX =.*\)/\1/' "$$dir/config.mk" ;; \
				st) sed '/^#CPPFLAGS =/,/^#MANPREFIX =/s/^#//' "$$dir/config.mk" ;; \
				slstatus) sed 's/^LDLIBS[[:space:]]*=.*/LDLIBS = -lX11 -lsndio/' "$$dir/config.mk" ;; \
			esac > "$$dir/config.mk.tmp"; \
			mv "$$dir/config.mk.tmp" "$$dir/config.mk"; \
		elif [ "$(NOUSR)" -eq 1 ]; then \
			sed 's|/usr/|/|g' "$$dir/config.mk" > "$$dir/config.mk.tmp"; \
			mv "$$dir/config.mk.tmp" "$$dir/config.mk"; \
		fi; \
		{ \
			if [ "$(BSD)" -eq 1 ]; then printf '#define OBSD\n'; fi; \
			if [ "$(LAPTOP)" -eq 1 ]; then printf '#define LAPTOP\n'; fi; \
			if [ "$(MIXER)" -eq 1 ]; then printf '#define MIXER\n'; fi; \
			vol="$(VOL)"; \
			if [ "$$vol" -eq 0 ]; then vol=5; fi; \
			if [ "$(BSD)" -eq 1 ]; then vol=$$(LC_ALL=C awk -v step="$$vol" 'BEGIN { printf "%.6f", step / 100 }'); fi; \
			printf '#define VOL "%s"\n' "$$vol"; \
			case $$tool in \
				st) font='$(ST_FONT)'; macro=ST_FONT ;; \
				*) font='$(FONT)'; macro=FONT ;; \
			esac; \
			case $$font in ''|'""'*) ;; *) \
				font=$$(printf '%s\n' "$$font" | sed 's/[\\"]/\\&/g'); \
				printf '#define %s "%s"\n' "$$macro" "$$font" ;; \
			esac; \
			cat "$(TOP)/files/config/$$tool/config.h"; \
		} > "$$dir/config.h.tmp"; \
		cmp -s "$$dir/config.h.tmp" "$$dir/config.h" || cp "$$dir/config.h.tmp" "$$dir/config.h"; \
		rm -f "$$dir/config.h.tmp"; \
	done

build: configure $(EXTDIR)/.user
	@(cd "$(EXTDIR)/$(NAME_dwm)"      && $(MAKE) CC="$(CC)" PREFIX="$(PREFIX)")
	@(cd "$(EXTDIR)/$(NAME_st)"       && $(MAKE) CC="$(CC)" PREFIX="$(PREFIX)")
	@(cd "$(EXTDIR)/$(NAME_dmenu)"    && $(MAKE) CC="$(CC)" PREFIX="$(PREFIX)")
	@(cd "$(EXTDIR)/$(NAME_slstatus)" && $(MAKE) CC="$(CC)" PREFIX="$(PREFIX)")

install: build
	@(cd "$(EXTDIR)/$(NAME_dwm)"      && $(MAKE) CC="$(CC)" PREFIX="$(PREFIX)" install)
	@(cd "$(EXTDIR)/$(NAME_st)"       && $(MAKE) CC="$(CC)" PREFIX="$(PREFIX)" install)
	@(cd "$(EXTDIR)/$(NAME_dmenu)"    && $(MAKE) CC="$(CC)" PREFIX="$(PREFIX)" install)
	@(cd "$(EXTDIR)/$(NAME_slstatus)" && $(MAKE) CC="$(CC)" PREFIX="$(PREFIX)" install)
	@if [ "$(BSD)" -eq 0 ] && { [ "$(SCRIPTS)" -eq 1 ] || [ "$(LAPTOP)" -eq 1 ]; }; then \
		mkdir -p "$(DESTDIR)$(PREFIX)/bin" && \
		cp "$(TOP)/files/bin/backlight.sh" "$(TOP)/files/bin/volume.sh" "$(DESTDIR)$(PREFIX)/bin/" && \
		chmod 755 "$(DESTDIR)$(PREFIX)/bin/backlight.sh" "$(DESTDIR)$(PREFIX)/bin/volume.sh"; \
	fi
	@set -e; if [ "$(YASH)" -eq 1 ]; then \
		usr="$(USR)"; \
		if [ -z "$$usr" ]; then read -r usr < "$(EXTDIR)/.user"; fi; \
		home="$(HOME_DIR)"; \
		if [ -z "$$home" ]; then home=$$(awk -F: -v user="$$usr" '$$1 == user { print $$6; exit }' /etc/passwd); fi; \
		test -n "$$home" || { echo "cannot find home for $$usr; set HOME_DIR" >&2; exit 1; }; \
		mkdir -p "$(DESTDIR)$$home/.config/yash"; \
		cp -R "$(TOP)/files/config/yash/." "$(DESTDIR)$$home/.config/yash/"; \
		chown -R "$$usr" "$(DESTDIR)$$home/.config/yash"; \
	fi

clean:
	@set -e; for name in $(NAME_dwm) $(NAME_st) $(NAME_dmenu) $(NAME_slstatus); do \
		if [ -d "$(EXTDIR)/$$name" ]; then (cd "$(EXTDIR)/$$name" && $(MAKE) clean); fi; \
	done

distclean:
	@echo "cleaning $(SRCDIR) and $(EXTDIR)"
	@rm -rf "$(SRCDIR)" "$(EXTDIR)"
