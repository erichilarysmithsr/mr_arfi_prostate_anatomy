echo "Stripping URLs from library.bib . . ."
grep -v "url =" ./library.bib > ./library_no_urls.bib
