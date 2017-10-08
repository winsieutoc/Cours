#We consider that we have a file, named stats.txt,
#in which, on each line we have three values
#frameNumber PSNR ENT ENTERR
#
#This file, passed as parameter to gnuplot :
# gnuplot msemono2.gnuplot
# will save the curves of the MSE against time, and PSNR against time
# to the file msemultiblock.png

set terminal png
set output "data/msemultiblock.png"

set xlabel "Frames"
set ylabel "MSE3,MSE2,MSE1"
#set xrange [0:110]
#set yrange [0: 700]
set xtics 10
set ytics 50
set style line 1 lw 5
set style line 2 lw 5
set style line 3 lw 5
plot 'build/statsMSE.txt' using 1:2 with lines title 'MSE3', 'build/statsMSE.txt' using 1:3 with lines title 'MSE2', 'build/statsMSE.txt' using 1:4 with lines title 'MSE1'
