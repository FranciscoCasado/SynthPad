
t = (0:1:99)*2*pi/100;
Y = round(511*(sin(t)+1));

stairs(t,Y)

fileName = 'sineTable.coe';
file = fopen(fileName, 'w');

fprintf(file, 'memory_initialization_radix=2;\nmemory_initialization_vector=\n');
bits = 10;
for j=1:length(Y)

    binaryVector = decimalToBinaryVector(Y(j),bits);
    for i=1:bits
       fprintf(file,'%d',binaryVector(i)); 
    end 
    fprintf(file,'\n');
end
        