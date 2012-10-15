# pandoc makefile for presentations

MDWN2BEAMER= pandoc -t beamer
MDWN2HTML= pandoc -t slidy --self-contained
MDWN2PDF= pandoc

MDWNFILES= $(wildcard *.md)
HTMLFILES= $(MDWNFILES:.md=-slides.html)
PDFFILES= $(MDWNFILES:.md=-notes.pdf) $(MDWNFILES:.md=-slides.pdf)

all: html pdf

html: $(HTMLFILES)
pdf: $(PDFFILES) $(SLIDEFILES)

%-slides.html: %.md
	$(MDWN2HTML) -o $@ $<

%-notes.pdf: %.md
	$(MDWN2PDF) -o $@ $<

%-slides.pdf: %.md
	$(MDWN2BEAMER) -o $@ $<

clean:
	rm -f $(HTMLFILES) $(PDFFILES)
