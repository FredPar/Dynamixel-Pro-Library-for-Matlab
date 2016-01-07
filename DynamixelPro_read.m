function [Instruction_Packet, Status_Packet, read_value] = DynamixelPro_read(servo_ID,address,bytes,s)
%Sends an Instruction Packet to read the desired value at the specified
%address on the Dynamixel Pro
% By: Federico Parietti
%Inputs:
%-> ID:      the ID of the Dynamixel Pro where we want to read
%-> address: the address of the value that we want to read on the control
%            table of the Dynamixel Pro
%-> bytes:   the number of bytes in which the value is represented
%-> s:       the serial port object
%Outputs:
%-> Instruction_Packet: the Instruction Packet that has been sent to the
%                       Dynamixel Pro
%-> Status_Packet:      the Status Packet that has been received from the
%                       Dynamixel Pro
%-> read_value:         the read value of the desired parameter


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
num_param = 2+2; %address(2 bytes) + number of bytes to read (2 bytes)
L_p = num_param + 3; %number of parameters + 3 (Instruction and CRC)
[LEN_H, LEN_L] = high_low_bytes(L_p);

%Instruction
Instruction = hex2dec('02'); %the Read instruction is 02

%Parameters
%Address
[address_H, address_L] = high_low_bytes(address);
%Data length
[data_length_H, data_length_L] = high_low_bytes(bytes);

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
                       data_length_L
                       data_length_H ];
L_Instruction_Packet = length(Instruction_Packet);
CRC = 0;
CRC = CRC_update(CRC,Instruction_Packet,L_Instruction_Packet);
%Find Low and High bytes of the CRC
[CRC_H, CRC_L] = high_low_bytes(CRC);

%Complete the Instruction Packet with the CRC
Instruction_Packet = [ Instruction_Packet
                       CRC_L
                       CRC_H              ];
                   
%Flush the buffer (if it's not already empty)
if s.BytesAvailable
    fread(s, s.BytesAvailable);
end        
                   
%Send the Instruction Packet

%Binary write
fwrite(s, Instruction_Packet);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read the Status Packet

%Length of Status Packet after the Read Instruction Packet
L_Status_Packet = 3+1+1+2+1+1+bytes+2;
%(header+reserved+ID+packet length+instruction+error+parameter+CRC)

%Binary read
Status_Packet = fread(s, L_Status_Packet); %much faster if number of bytes is specified
%Note: if the 9th byte is zero, there are no errors

% %Order the received Status Packet (header at the beginning)
% flag_order = 0;
% if (Status_Packet(1)==255) && (Status_Packet(2)==255) && (Status_Packet(3)==253)
%     flag_order = 1;
% end
% while flag_order==0
%     %Shift the vector down by one (circularly)
%     Status_Packet = circshift(Status_Packet,[1 0]);
%     if (Status_Packet(1)==255) && (Status_Packet(2)==255) && (Status_Packet(3)==253)
%         flag_order = 1;
%     end
% end

%Isolate the relevant bytes (they can be 1, 2 or 4) and convert them to the
%corresponding decimal value
if bytes == 1
    
    read_value = Status_Packet(10); %it's already decimal
    
elseif bytes == 2
    
    read_value_L = Status_Packet(10);
    read_value_H = Status_Packet(11);
    read_value = highlow_to_decimal(read_value_H, read_value_L);
    
elseif bytes == 4
    
    read_value_LL = Status_Packet(10);
    read_value_L  = Status_Packet(11);
    read_value_H  = Status_Packet(12);
    read_value_HH = Status_Packet(13);
    read_value = highhighlowlow_to_decimal(read_value_HH, read_value_H, read_value_L, read_value_LL);

else
    read_value = NaN;
    disp('Incorrect bytes number')
end


