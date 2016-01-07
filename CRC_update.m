function CRC = CRC_update_One(CRC,Packet_Data,L_Packet_Data)
%Calculates the CRC
% By: Federico Parietti
%Inputs:
% - CRC is 0 (format: double), the initial value of the CRC
% - Packet_Data is an array containing the values (format: double) of the
%   Instruction and Parameter fields.
% - L_Packet_Data is the length of Packet_Data (format: double)
%Output:
% - CRC is the value of the CRC for this data packet


%Create CRC table and convert from hex to dec format
CRC_table = [  hex2dec('0000'), hex2dec('8005'), hex2dec('800F'), hex2dec('000A'), hex2dec('801B'), hex2dec('001E'), hex2dec('0014'), hex2dec('8011')

               hex2dec('8033'), hex2dec('0036'), hex2dec('003C'), hex2dec('8039'), hex2dec('0028'), hex2dec('802D'), hex2dec('8027'), hex2dec('0022')

               hex2dec('8063'), hex2dec('0066'), hex2dec('006C'), hex2dec('8069'), hex2dec('0078'), hex2dec('807D'), hex2dec('8077'), hex2dec('0072')

               hex2dec('0050'), hex2dec('8055'), hex2dec('805F'), hex2dec('005A'), hex2dec('804B'), hex2dec('004E'), hex2dec('0044'), hex2dec('8041')

               hex2dec('80C3'), hex2dec('00C6'), hex2dec('00CC'), hex2dec('80C9'), hex2dec('00D8'), hex2dec('80DD'), hex2dec('80D7'), hex2dec('00D2')

               hex2dec('00F0'), hex2dec('80F5'), hex2dec('80FF'), hex2dec('00FA'), hex2dec('80EB'), hex2dec('00EE'), hex2dec('00E4'), hex2dec('80E1')

               hex2dec('00A0'), hex2dec('80A5'), hex2dec('80AF'), hex2dec('00AA'), hex2dec('80BB'), hex2dec('00BE'), hex2dec('00B4'), hex2dec('80B1')

               hex2dec('8093'), hex2dec('0096'), hex2dec('009C'), hex2dec('8099'), hex2dec('0088'), hex2dec('808D'), hex2dec('8087'), hex2dec('0082')

               hex2dec('8183'), hex2dec('0186'), hex2dec('018C'), hex2dec('8189'), hex2dec('0198'), hex2dec('819D'), hex2dec('8197'), hex2dec('0192')

               hex2dec('01B0'), hex2dec('81B5'), hex2dec('81BF'), hex2dec('01BA'), hex2dec('81AB'), hex2dec('01AE'), hex2dec('01A4'), hex2dec('81A1')

               hex2dec('01E0'), hex2dec('81E5'), hex2dec('81EF'), hex2dec('01EA'), hex2dec('81FB'), hex2dec('01FE'), hex2dec('01F4'), hex2dec('81F1')

               hex2dec('81D3'), hex2dec('01D6'), hex2dec('01DC'), hex2dec('81D9'), hex2dec('01C8'), hex2dec('81CD'), hex2dec('81C7'), hex2dec('01C2')

               hex2dec('0140'), hex2dec('8145'), hex2dec('814F'), hex2dec('014A'), hex2dec('815B'), hex2dec('015E'), hex2dec('0154'), hex2dec('8151')

               hex2dec('8173'), hex2dec('0176'), hex2dec('017C'), hex2dec('8179'), hex2dec('0168'), hex2dec('816D'), hex2dec('8167'), hex2dec('0162')

               hex2dec('8123'), hex2dec('0126'), hex2dec('012C'), hex2dec('8129'), hex2dec('0138'), hex2dec('813D'), hex2dec('8137'), hex2dec('0132')

               hex2dec('0110'), hex2dec('8115'), hex2dec('811F'), hex2dec('011A'), hex2dec('810B'), hex2dec('010E'), hex2dec('0104'), hex2dec('8101')

               hex2dec('8303'), hex2dec('0306'), hex2dec('030C'), hex2dec('8309'), hex2dec('0318'), hex2dec('831D'), hex2dec('8317'), hex2dec('0312')

               hex2dec('0330'), hex2dec('8335'), hex2dec('833F'), hex2dec('033A'), hex2dec('832B'), hex2dec('032E'), hex2dec('0324'), hex2dec('8321')

               hex2dec('0360'), hex2dec('8365'), hex2dec('836F'), hex2dec('036A'), hex2dec('837B'), hex2dec('037E'), hex2dec('0374'), hex2dec('8371')

               hex2dec('8353'), hex2dec('0356'), hex2dec('035C'), hex2dec('8359'), hex2dec('0348'), hex2dec('834D'), hex2dec('8347'), hex2dec('0342')

               hex2dec('03C0'), hex2dec('83C5'), hex2dec('83CF'), hex2dec('03CA'), hex2dec('83DB'), hex2dec('03DE'), hex2dec('03D4'), hex2dec('83D1')

               hex2dec('83F3'), hex2dec('03F6'), hex2dec('03FC'), hex2dec('83F9'), hex2dec('03E8'), hex2dec('83ED'), hex2dec('83E7'), hex2dec('03E2')

               hex2dec('83A3'), hex2dec('03A6'), hex2dec('03AC'), hex2dec('83A9'), hex2dec('03B8'), hex2dec('83BD'), hex2dec('83B7'), hex2dec('03B2')

               hex2dec('0390'), hex2dec('8395'), hex2dec('839F'), hex2dec('039A'), hex2dec('838B'), hex2dec('038E'), hex2dec('0384'), hex2dec('8381')

               hex2dec('0280'), hex2dec('8285'), hex2dec('828F'), hex2dec('028A'), hex2dec('829B'), hex2dec('029E'), hex2dec('0294'), hex2dec('8291')

               hex2dec('82B3'), hex2dec('02B6'), hex2dec('02BC'), hex2dec('82B9'), hex2dec('02A8'), hex2dec('82AD'), hex2dec('82A7'), hex2dec('02A2')

               hex2dec('82E3'), hex2dec('02E6'), hex2dec('02EC'), hex2dec('82E9'), hex2dec('02F8'), hex2dec('82FD'), hex2dec('82F7'), hex2dec('02F2')

               hex2dec('02D0'), hex2dec('82D5'), hex2dec('82DF'), hex2dec('02DA'), hex2dec('82CB'), hex2dec('02CE'), hex2dec('02C4'), hex2dec('82C1')

               hex2dec('8243'), hex2dec('0246'), hex2dec('024C'), hex2dec('8249'), hex2dec('0258'), hex2dec('825D'), hex2dec('8257'), hex2dec('0252')

               hex2dec('0270'), hex2dec('8275'), hex2dec('827F'), hex2dec('027A'), hex2dec('826B'), hex2dec('026E'), hex2dec('0264'), hex2dec('8261')

               hex2dec('0220'), hex2dec('8225'), hex2dec('822F'), hex2dec('022A'), hex2dec('823B'), hex2dec('023E'), hex2dec('0234'), hex2dec('8231')

               hex2dec('8213'), hex2dec('0216'), hex2dec('021C'), hex2dec('8219'), hex2dec('0208'), hex2dec('820D'), hex2dec('8207'), hex2dec('0202') ];


%Calculate the value of the CRC
CRC = uint16(CRC);
for j_count=1:1:L_Packet_Data
    
    %First, shift CRC to the right by 8 bits
    step1 = bitshift(CRC,-8);
%     step1 = bitsrl(CRC,8);
    %Then, do bitwise XOR with the current value in Packet_Data
    step2 = bitxor( step1, uint16(Packet_Data(j_count)) );
    %Finally, do bitwise AND with FF (hex)
    index = bitand( step2, uint16(hex2dec('FF')) );
    
    %Find row and column of matrix element
    index = double(index);
    table_width = size(CRC_table,2);
    row         = floor(index/table_width);
    column      = floor(mod(index,table_width));
    
    %IMPORTANT: Matlab indexes start from 1
    row    = row+1;
    column = column+1;
    
    %Shift CRC to the left by 8 bits
    CRC = bitshift(CRC,8);
%     CRC = bitsll(CRC,8);
    %Do bitwise XOR between the shifter CRC and the table value indicated
    %by index
    CRC = bitxor( CRC, uint16(CRC_table(row,column)) );
    
end

%Return the output as a double number
CRC = double(CRC);





