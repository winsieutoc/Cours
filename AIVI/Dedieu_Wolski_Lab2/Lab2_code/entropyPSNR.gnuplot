#We consider that we have a file, named stats.txt,
#in which, on each line we have three values
#frameNumber PSNR ENT ENTERR
#
#This file, passed as parameter to gnuplot :
# gnuplot entropyGraph.gnuplot
# will save the curves of the MSE against time, and PSNR against time
# to the file outEntPSNR.png

set terminal png
set output "graph/GraphEntropyPSNR.png"

set xlabel "Frames"
set ylabel "PSNR,ENT,ENTERR"
#set xrange [0:110]
#set yrange [0: 50]
set xtics 10
set ytics 5
set style line 1 lw 5
set style line 2 lw 5
plot 'build/statsEnt.txt' using 1:2 with lines title 'PSNR', 'build/statsEnt.txt' using 1:3 with lines title 'ENT', 'build/statsEnt.txt' using 1:4 with lines title 'ENTERR'
