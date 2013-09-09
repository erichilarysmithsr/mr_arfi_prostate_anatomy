#!/bin/bash
texfile='mr_arfi_anatomy'
pdflatex $texfile.tex
pdflatex $texfile.tex
bibtex $texfile
pdflatex $texfile.tex
pdflatex $texfile.tex
rm $texfile.aux $texfile.bbl $texfile.out $texfile.blg $texfile.log

#response='ResponseToReviewsR2'
#pdflatex $response.tex
#rm $response.aux $response.log
