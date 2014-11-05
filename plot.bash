#!/bin/bash

gnuplot <(cat <<EOF
set terminal dumb 160 20;
set datafile separator ",";
set xdata time;
set timefmt "%Y-%m-%d";
plot "$1" using 1:4 with line pi -3;
EOF
)
