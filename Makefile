# pandoc makefile for presentations

MDWN2BEAMER= pandoc -t beamer
MDWN2HTML= pandoc -t slidy --self-contained
MDWN2PDF= pandoc

MDWNFILES= $(wildcard *.mdwn)
HTMLFILES= $(MDWNFILES:.mdwn=-slides.html)
PDFFILES= $(MDWNFILES:.mdwn=-notes.pdf) $(MDWNFILES:.mdwn=-slides.pdf)

all: html pdf

html: $(HTMLFILES)
pdf: $(PDFFILES) $(SLIDEFILES)

%-slides.html: %.mdwn
	$(MDWN2HTML) -o $@ $<

%-notes.pdf: %.mdwn
	$(MDWN2PDF) -o $@ $<

%-slides.pdf: %.mdwn
	$(MDWN2BEAMER) -o $@ $<

clean:
	rm -f $(HTMLFILES) $(PDFFILES)
