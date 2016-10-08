format long

f_clock = 50000000;
f_note_max = 4186.01;

samples_per_note = 80:1:120;

f_max = f_note_max * samples_per_note;

ratio = f_clock ./ f_max;

counter = ratio - floor(ratio);
counter2 = ceil(ratio) - ratio ;
 