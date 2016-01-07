function Instruction_Packet = DynamixelPro_write(servo_ID,address,value,bytes,s)
%Writes the desired value at the specified address on the Dynamixel Pro
% By: Federico Parietti
%Inputs:
%-> ID:      the ID of the Dynamixel Pro where we want to write
%-> address: the address on the control table of the Dynamixel Pro
%-> value:   the value to be written at the above specified address
%-> bytes:   the number of bytes in which the value is represented
%-> s:       the serial port object
%Output:
%-> Instruction_Packet: the Instruction packet that has been sent to the
%                       Dynamixel Pro


%Create the Instruction Packet

%Headers
Header1 = hex2dec('FF');
Header2 = hex2dec('FF');
Header3 = hex2dec('FD');

%Reserved byte
Reserved = hex2dec('00');

%ID of the Dynamixel Pro
ID = servo_ID;

%Packet Length
num_param = 2+bytes; %address(2 bytes) + number of value bytes
L_p = num_param + 3; %number of parameters + 3 (Instruction and CRC)
[LEN_H, LEN_L] = high_low_bytes(L_p);

%Instruction
Instruction = hex2dec('03'); %the Write instruction is 03

%Parameters
%Address
[address_H, address_L] = high_low_bytes(address);
%Value(s) to write
if bytes==1
    values_W = value;
elseif bytes==2
    [value_H, value_L] = high_low_bytes(value);
    values_W = [ value_L
                value_H ];
else %in this case the value is expressed in 4 bytes
    [value_HH, value_H, value_L, value_LL] = high_high_low_low_bytes(value);
    values_W = [ value_LL
                 value_L
                 value_H
                 value_HH ];
end

%16 bit CRC
%Calculate the CRC value
Instruction_Packet = [ Header1
                       Header2
                       Header3
                       Reserved
                       ID
                       LEN_L
                       LEN_H
                       Instruction
                       address_L
                       address_H
                       values_W    ];
L_Instruction_Packet = length(Instruction_Packet);
CRC = 0;
CRC = CRC_update(CRC,Instruction_Packet,L_Instruction_Packet);
%Find Low and High bytes of the CRC
[CRC_H, CRC_L] = high_low_bytes(CRC);

%Complete the Instruction Packet with the CRC
Instruction_Packet = [ Instruction_Packet
                       CRC_L
                       CRC_H              ];

                   
%Send the Instruction Packet

%Binary write
fwrite(s, Instruction_Packet);


%Read the Status Packet

% %Length of Status Packet after a Write Instruction Packet
% L_Status_Packet = 11;
% 
% %Binary read
% Status_Packet = fread(s, L_Status_Packet) %much faster if number of bytes is specified
% %Note: if the 9th byte is zero, there are no errors















