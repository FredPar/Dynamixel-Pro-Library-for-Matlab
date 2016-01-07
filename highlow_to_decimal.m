function decimal = highlow_to_decimal(high_byte, low_byte)
%Converts high byte and low byte into the corresponding decimal value

%Convert to decimal
decimal = high_byte*256+low_byte;

%Identify and compute negative numbers (Two's Complement)
if decimal>(2^15-1)
    decimal = decimal-2^16;
end