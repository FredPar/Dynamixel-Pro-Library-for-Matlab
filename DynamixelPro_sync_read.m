function read_value_vect = DynamixelPro_sync_read(servo_IDs,address,bytes,s)
%Reads the desired values at the specified address on the Dynamixel Pro
%servos, simultaneously (works with any number of servos)
% By: Federico Parietti
%Inputs:
%-> servo_IDs: the IDs of the Dynamixel Pro servos where we want to read
%              (row vector)
%-> address:   the address on the control table of the Dynamixel Pro
%-> bytes:     the number of bytes in which the value is represented
%-> s:         the serial port object
%Output:
%-> read_value_vect: the read values of the desired parameter


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Create the Instruction Packet

%Headers
Header1 = hex2dec('FF');
Header2 = hex2dec('FF');
Header3 = hex2dec('FD');

%Reserved byte
Reserved = hex2dec('00');

%ID of the Dynamixel Pro
ID = hex2dec('FE'); %ID used for broadcast transmission

%Packet Length
num_servos = length(servo_IDs);
L_p = 1+2+2+num_servos+2;
%instruction(1)+common address(2)+common length(2)+servo ID (1 for each
%servo)+CRC(2)

%number of parameters + 3 (Instruction and CRC)
[LEN_H, LEN_L] = high_low_bytes(L_p);

%Instruction
Instruction = hex2dec('82'); %the Sync Read instruction is 82

%Parameters
%Address
[common_address_H, common_address_L] = high_low_bytes(address);
%Common read data length
[common_length_H, common_length_L] = high_low_bytes(bytes);
%ID of first servo (from IDs vector)
%ID of second servo (from IDs vector)

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
                       common_address_L
                       common_address_H
                       common_length_L
                       common_length_H
                       servo_IDs'       ];       
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
%(note: there are as many Status Packets as servos called in the Read
%Instruction Packet)
L_Status_Packet = 3+1+1+2+1+1+bytes+2;
%header(3)+reserved(1)+ID(1)+packet length(2)+instruction(1)+error(1)+
%+parameter(bytes)+CRC(2)

%Read all of the Status Packets, extracting the desired values from all of
%them (same order as the servos in servo_IDs)
read_value_vect = zeros(1,num_servos);
for count=1:1:num_servos
    %Binary read
    Status_Packet = fread(s, L_Status_Packet);
    %Note: if the 9th byte is zero, there are no errors
    
    %Isolate the relevant bytes (they can be 1, 2 or 4) and convert them to the
    %corresponding decimal value
    if bytes == 1

        read_value_vect(count) = Status_Packet(10); %it's already decimal

    elseif bytes == 2

        read_value_L = Status_Packet(10);
        read_value_H = Status_Packet(11);
        read_value_vect(count) = highlow_to_decimal(read_value_H, read_value_L);

    elseif bytes == 4

        read_value_LL = Status_Packet(10);
        read_value_L  = Status_Packet(11);
        read_value_H  = Status_Packet(12);
        read_value_HH = Status_Packet(13);
        read_value_vect(count) = highhighlowlow_to_decimal(read_value_HH, read_value_H, read_value_L, read_value_LL);

    else
        read_value_vect(count) = NaN;
        disp('Incorrect bytes number')
    end
end


