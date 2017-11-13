#We consider that we have a file, named stats.txt,
#in which, on each line we have three values
#frameNumber a b c ...

set terminal png
set output "data/msecompare.png"

set xlabel "Frames"
set ylabel "MSE"
set xtics 10
set yrange [*:*]
set style line 1 lw 5
set style line 2 lw 5
plot 'data/stats_MB_1.txt' using 1:2 with lines title 'BM_1',\
 'data/stats_MSE_MB3.txt' using 1:4 with lines title 'BM_3',\
  'data/stats_HS_1.txt' using 1:2 with lines title 'HS_1',\
  'data/statsMSE_HS_3.txt' using 1:2 with lines title 'HS_3', \
  'data/stats_F_1.txt' using 1:2 with lines title 'F_1',\
  'data/stats_F_3.txt' using 1:2 with lines title 'F_3',\
  'data/stats_MIT.txt' using 1:2 with lines title 'MIT_1'

  set terminal png
  set output "data/gmecompare.png"

  set xlabel "Frames"
  set ylabel "MSE"
  set xtics 10
  set yrange [*:*]
  set style line 1 lw 5
  set style line 2 lw 5
  plot 'data/stats_GME.txt' using 1:6 with lines title 'MSE0',\
   'data/stats_GME.txt' using 1:2 with lines title 'MSE1',\
    'data/stats_GME.txt' using 1:7 with lines title 'MSE2'
