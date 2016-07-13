#!/bin/bash

# Copyright 2016 Alberto Termanini

R --vanilla --slave --args --infile "data.tab" --outfile "plot.pdf" --title "Main title" --ylab "Y-axis label" -v < ../main.R;
