function decimal = highhighlowlow_to_decimal(high_high_byte, high_byte, low_byte, low_low_byte)
%Converts high high byte, high byte, low byte and low low byte into the corresponding decimal value

%Convert to decimal
decimal = high_high_byte*(2^24)+high_byte*(2^16)+low_byte*(2^8)+low_low_byte;

%Identify and compute negative numbers (Two's Complement)
if decimal>(2^31-1)
    decimal = decimal-2^32;
end