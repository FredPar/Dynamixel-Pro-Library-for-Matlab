function [high_byte, low_byte] = high_low_bytes(number)
%Calculates the high and low bytes of the input number

%Negative numbers are represented with the Two's Complement
if number<0
    number = 2^16+number;
end

%Find the 2 bytes
high_byte = floor(number/256);        %quotient
low_byte  = floor( mod(number,256) ); %remainder(integer)