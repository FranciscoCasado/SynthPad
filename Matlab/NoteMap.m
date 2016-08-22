
key_freqs = zeros(127,1);

a = 440; % A4 is 440 Hz

for i=0:126
    key_freqs(i+1) = (a / 32) * (2 ^ ((i - 9) / 12));  
end

fpga_clk_freq = 50*10^6; % FPGA runs at 50MHz
fpga_clk_period = 1/fpga_clk_freq;

samples_per_note = 100;

key_periods = 1./key_freqs;

fpga_periods = key_periods/samples_per_note;

fpga_counter = round(fpga_periods/fpga_clk_period);

key_freqs_estimated = 1./(fpga_counter*fpga_clk_period*samples_per_note);