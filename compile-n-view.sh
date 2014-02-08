#tmp_latex="/tmp/mr_arfi_anatomy"
tmp_latex="./"

if [ ! -d $tmp_latex ]; then
    mkdir $tmp_latex
fi

latexmk -f -bibtex -pdf -pvc -outdir=$tmp_latex mr_arfi_anatomy.tex
