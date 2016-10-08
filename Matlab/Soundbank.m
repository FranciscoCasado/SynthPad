
% Files Config
sourceFileName = 'Magnetic Field Amethyst.wav';
destFileName   = 'test.coe';

% Bits
bits = 10;
discretized_max_value = (2^bits) -1;

% Read Audio File
[y,Fs] = audioread(sourceFileName);

% Configure Sample Properties
max_time = 5; %s
Fs2 = 1024;
max_sample = min([Fs2*max_time, length(y)]);


% Subsample
counter = 1;
suma    = 0;

y2 = zeros(max_sample,1);

for i =1:length(y)
   suma = suma + Fs2/Fs; 
   if(suma > counter)
       y2(counter) = y(i,1)+ y(i,2);
       counter = counter + 1;
   end
   
   if max_sample < counter
       break
   end
end

% 2*Fs2
sound(y2, 4*Fs2, 8)

plot(y2)
pause

% Discretize and format
max_value = max(y2);
min_value = min(y2);
range = max_value - min_value;

y_normalized = (y2 - min_value) / range;
plot(y_normalized)
pause

y_discretized = round(discretized_max_value*y_normalized);
plot(y_discretized)

% Format into coe and write file
file = fopen(destFileName, 'w');

fprintf(file, 'memory_initialization_radix=2;\nmemory_initialization_vector=\n');
bits = 10;
for j=1:length(Y)

    binaryVector = decimalToBinaryVector(Y(j),bits);
    for i=1:bits
       fprintf(file,'%d',binaryVector(i)); 
    end 
    fprintf(file,'\n');
end
        