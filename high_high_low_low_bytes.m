function [high_high_byte, high_byte, low_byte, low_low_byte] = high_high_low_low_bytes(number)
%Calculates the 4 bytes representation of the input number
%It also handles negative inputs (by using the two's complement)

%Negative numbers are represented with the Two's Complement
if number<0
    number = 2^32+number;
end

%Find the 4 bytes
high_high_byte = floor( number/(2^24) );
remainder1     = floor( mod( number,(2^24) ) );
high_byte      = floor( remainder1/(2^16) );
remainder2     = floor( mod( remainder1,(2^16) ) );
low_byte       = floor( remainder2/(2^8) );
low_low_byte   = floor( mod( remainder2,(2^8) ) );