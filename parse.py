#!/bin/env python
""""
parse single PDF of manuscript into individual PDF files for upload

The page breaks are hard-coded below and will need to be adjusted

"""

import os

parent_pdf = "mr_arfi_anatomy.pdf"
parsed_pdf_dir = "parsed_pdfs"

if not os.path.exists(parsed_pdf_dir):
    os.mkdir(parsed_pdf_dir)

# section title, number of pages
sections = (('title',   1),
            ('main',    18),
            ('figure1', 1),
            ('figure2', 1),
            ('figure3', 1),
            ('figure4', 1),
            ('figure5', 1),
            ('figure6', 1),
            ('figure7', 1),
            ('figure8', 1))

print("\nWARNING: Number of pages for each section is HARD-CODED\n")

start_page = 0
stop_page = 0
for i in range(len(sections)):
    # iteratively generate each section PDF
    start_page = stop_page + 1
    stop_page = start_page + int(sections[i][1]) - 1
    os.system("pdftk A=%s cat A%i-%i output %s/%s.pdf" %
              (parent_pdf,
               start_page,
               stop_page,
               parsed_pdf_dir,
               sections[i][0]))

    # test for and indicate new file existence
    new_file = ("./%s/%s.pdf" % (parsed_pdf_dir, sections[i][0]))
    if os.path.exists(new_file):
        print("Successfully created: %s" % new_file)
    else:
        print("ERROR: Failed to create %s" % new_file)
