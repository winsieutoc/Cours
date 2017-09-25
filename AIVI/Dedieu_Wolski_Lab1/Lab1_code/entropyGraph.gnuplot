
#We consider that we have a file, named stats.txt,
#in which, on each line we have three values
#frameNumber ENT ENTERR
#
#This file, passed as parameter to gnuplot :
# gnuplot entropyGraph.gnuplot
# will save the curves of the MSE against time, and PSNR against time
# to the file outEntropy.png

set terminal png
set output "outEntropy.png"

set xlabel "Frames"
set ylabel "ENT,ENTERR"
#set xrange [0:110]
#set yrange [0: 700]
set xtics 10
set ytics 50
set style line 1 lw 5
set style line 2 lw 5
plot 'Build/statsEntropy.txt' using 1:2 with lines title 'ENT', 'Build/statsEntropy.txt' using 1:3 with lines title 'ENTERR'
