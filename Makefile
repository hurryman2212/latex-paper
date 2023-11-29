# Makefile for LaTeX Projects by Jihong Min (hurryman2212@gmail.com)

TEX=$(wildcard *.tex)

AUTOBIB_DIR=autobib
BIB_DIR=biblio
FIG_DIR=figures
TEXT_DIR=text

all: default
default: anonymous
citeall: anonymous_citeall

.PHONY: autobib
autobib:
	make -C $(AUTOBIB_DIR)

latexindent_clean:
	find . -name "indent.log" -type f -delete
latexmk_clean:
	latexmk -c
autobib_clean:
	make -C $(AUTOBIB_DIR) clean
clean_residuals: latexindent_clean latexmk_clean autobib_clean

clean_pdf:
	rm -f $(shell echo $(TEX:.tex=.pdf))

clean: clean_residuals clean_pdf
distclean: clean
	find . ! \( \
	-name '.' -o \
	-name '..' -o \
	-name '.gitignore' -o \
	-name '.gitmodules' -o \
	-name '.gitkeep' -o \
	-name '.latexmkrc' -o \
	-name 'Makefile' -o \
	-name '$(TEX)' -o \
	-name '*.cls' -o \
	-name '.git' -prune -o \
	-name '$(AUTOBIB_DIR)' -prune -o \
	-name '$(BIB_DIR)' -prune -o \
	-name '$(FIG_DIR)' -prune -o \
	-name '$(TEXT_DIR)' -prune \
	\) -exec rm -rf {} +

anonymous_citeall: PRETEX+= \def\citeall{1}
anonymous_citeall: anonymous
anonymous: PRETEX+= \def\anonymous{1}
anonymous: build

final_citeall: PRETEX+= \def\citeall{1}
final_citeall: final
final: build

build: latexmk_clean
build: autobib
build: $(TEX)
	for tex in $(TEX); do \
		latexmk -f -pdf -usepretex='$(PRETEX)' $$tex -bibtex; \
		latexmk -f -pdf -usepretex='$(PRETEX)' $$tex -bibtex; \
	done
	make clean_residuals
