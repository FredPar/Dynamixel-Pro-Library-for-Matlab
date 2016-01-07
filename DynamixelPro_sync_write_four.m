function Instruction_Packet = DynamixelPro_sync_write_four(servo_IDs,address,values,bytes,s)
%Writes the desired values at the specified address on the Dynamixel Pro
%servos, simultaneously (works with 4 servos)
% By: Federico Parietti
%Inputs:
%-> IDs:     the IDs of the Dynamixel Pro servos where we want to write
%-> address: the address on the control table of the Dynamixel Pro
%-> values:  the values to be written at the above specified address (in
%            the same order as the servos IDs)
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
ID = hex2dec('FE'); %ID used for broadcast transmission

%Packet Length
L_p = 1+2+2+(1+bytes)*length(servo_IDs)+2;
%instruction(1)+common address(2)+common length(2)+servo ID and value
%(1+bytes for each servo)+CRC(2)

%number of parameters + 3 (Instruction and CRC)
[LEN_H, LEN_L] = high_low_bytes(L_p);

%Instruction
Instruction = hex2dec('83'); %the Sync Write instruction is 83

%Parameters
%Address
[common_address_H, common_address_L] = high_low_bytes(address);
%Common write data length
[common_length_H, common_length_L] = high_low_bytes(bytes);
%ID of first servo (from IDs vector)
%Value to write on first servo
if bytes==1
    values_W1 = values(1);
elseif bytes==2
    [value_H, value_L] = high_low_bytes(values(1));
    values_W1 = [ value_L
                  value_H ];
else %in this case the value is expressed in 4 bytes
    [value_HH, value_H, value_L, value_LL] = high_high_low_low_bytes(values(1));
    values_W1 = [ value_LL
                  value_L
                  value_H
                  value_HH ];
end
%ID of second servo (from IDs vector)
%Value to write on second servo
if bytes==1
    values_W2 = values(2);
elseif bytes==2
    [value_H, value_L] = high_low_bytes(values(2));
    values_W2 = [ value_L
                  value_H ];
else %in this case the value is expressed in 4 bytes
    [value_HH, value_H, value_L, value_LL] = high_high_low_low_bytes(values(2));
    values_W2 = [ value_LL
                  value_L
                  value_H
                  value_HH ];
end
%ID of third servo (from IDs vector)
%Value to write on third servo
if bytes==1
    values_W3 = values(3);
elseif bytes==2
    [value_H, value_L] = high_low_bytes(values(3));
    values_W3 = [ value_L
                  value_H ];
else %in this case the value is expressed in 4 bytes
    [value_HH, value_H, value_L, value_LL] = high_high_low_low_bytes(values(3));
    values_W3 = [ value_LL
                  value_L
                  value_H
                  value_HH ];
end
%ID of fourth servo (from IDs vector)
%Value to write on fourth servo
if bytes==1
    values_W4 = values(4);
elseif bytes==2
    [value_H, value_L] = high_low_bytes(values(4));
    values_W4 = [ value_L
                  value_H ];
else %in this case the value is expressed in 4 bytes
    [value_HH, value_H, value_L, value_LL] = high_high_low_low_bytes(values(4));
    values_W4 = [ value_LL
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
                       common_address_L
                       common_address_H
                       common_length_L
                       common_length_H
                       servo_IDs(1)
                       values_W1
                       servo_IDs(2)
                       values_W2
                       servo_IDs(3)
                       values_W3
                       servo_IDs(4)
                       values_W4        ];       
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


