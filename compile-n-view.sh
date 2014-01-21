tmp_latex="/tmp/latex"

if [ ! -d $tmp_latex ]; then
    mkdir $tmp_latex
fi

latexmk -bibtex -pdf -pvc -outdir=$tmp_latex mr_arfi_anatomy.tex
