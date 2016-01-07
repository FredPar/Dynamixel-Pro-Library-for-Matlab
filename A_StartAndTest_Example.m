%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example for the setup and use of the Jenkins Library for the Dynamixel
% Pro
% By: Federico Parietti
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Create serial port object and load control table constants

%Set the port paramenters
s = serial('COM5');
set(s,'Baudrate',1000000);   %set speed of communication at 1'000'000 bps
set(s,'StopBits',1);         %specify number of bits used to indicate end of byte
set(s,'DataBits',8);         %number of data bits to transmit (we use 8 bit data)
set(s,'Parity','none');      %no parity
%Connect serial port
fopen(s);

%Load the control table constants
run('Control_Table_Constants')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Create and send Instruction Packet to set RED LED ON
servo_ID = 1;
brightness = 255;
Instruction_Packet = DynamixelPro_write(servo_ID,ADDRESS_RED_LED,brightness,BYTES_RED_LED,s);

%Check the Instruction Packet
dec2hex(Instruction_Packet)

% Instruction packet to set RED LED to 200 with servo ID 1
% FF FF FD 00 01 06 00 03 33 02 C8 91 6E


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Create and send Instruction Packet to set GOAL ACCELERATION
servo_ID = 1;
goal_accel = 5;
Instruction_Packet = DynamixelPro_write(servo_ID,ADDRESS_GOAL_ACCEL,goal_accel,BYTES_GOAL_ACCEL,s);

%Check the Instruction Packet
dec2hex(Instruction_Packet)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Create and send Instruction Packet to set ENABLE TORQUE ON
servo_ID = 1;
enable = 1;
Instruction_Packet = DynamixelPro_write(servo_ID,ADDRESS_TORQUE_ENABLE,enable,BYTES_TORQUE_ENABLE,s);

%Check the Instruction Packet
dec2hex(Instruction_Packet)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Create and send Instruction Packet to set GOAL POSITION
servo_ID = 1;
goal_angle = 0; %[rad]
goal_pos = goal_angle*RAD2POS;
Instruction_Packet = DynamixelPro_write(servo_ID,ADDRESS_GOAL_POS,goal_pos,BYTES_GOAL_POS,s);

%Check the Instruction Packet
dec2hex(Instruction_Packet)

%Correct Instruction Packet to set the desired position of the servo
%(ID: 1) to 200'000
% FF FF FD 00 01 09 00 03 54 02 40 0D 03 00 C9 03

%Correct Instruction Packet to set the desired position of the servo
%(ID: 1) to -200'000
% FF FF FD 00 01 09 00 03 54 02 C0 F2 FC FF F7 0F


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Disconnect serial port
fclose(s);
delete(s)
clear s


