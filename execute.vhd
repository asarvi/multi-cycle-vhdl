library ieee;
use ieee.std_logic_1164.all;
--Clock 3 (execution)
entity EX is

port(Opcode:in std_logic_vector(3 downto 0);
ALU_in0:in std_logic_vector(15 downto 0);   --output og register D0(pc output)
ALU_in1:in std_logic_vector(15 downto 0);   --output of register D1 
ALU_in2:in std_logic_vector(15 downto 0);   --output of register D2 
ALU_in_immid:in std_logic_vector(7 downto 0);
ALU_src_A:in std_logic;
clk:in std_logic;
ALU_src_B:in std_logic_vector(1 downto 0);
pc_src:in std_logic_vector(1 downto 0);
ALU_Result:out std_logic_vector(15 downto 0);
pc_addr_out:out std_logic_vector(15 downto 0);
zero_bit:out std_logic;
high_result:out std_logic_vector(15 downto 0));


end EX;


architecture EX of EX is


signal gnd :std_logic_vector(15 downto 0):=X"0000";
signal extended:std_logic_vector(15 downto 0);
signal sr_signal:std_logic_vector(15 downto 0);
signal shifted_extended:std_logic_vector(15 downto 0);
signal jump_address:std_logic_vector(19 downto 0);
signal shifted: std_logic_vector(15 downto 0);
signal ALU_result_signal:std_logic_vector(15 downto 0);
signal shifted_sign_final:std_logic_vector(15 downto 0);
signal high_signal:std_logic_vector(15 downto 0);

component ALU is

port(data0:in std_logic_vector(15 downto 0);
data1:in std_logic_vector(15 downto 0);
data2:in std_logic_vector(15 downto 0);
data3:in std_logic_vector(15 downto 0);
ALUOp:in std_logic_vector(3 downto 0);
ALUSrc_A:in std_logic;
ALUSrc_B:in std_logic_vector(1 downto 0);
low_result:out std_logic_vector(15 downto 0);
high_result:out std_logic_vector(15 downto 0);
sr_result:out std_logic_vector(15 downto 0);
zero:out std_logic);

end component;




component mux_4_to_1  is 


 Port ( inputA : in  STD_LOGIC_VECTOR (15 downto 0);
           inputB : in  STD_LOGIC_VECTOR (15 downto 0);
           inputC : in  STD_LOGIC_VECTOR (15 downto 0);
           inputD : in  STD_LOGIC_VECTOR (15 downto 0);
           sel : in  STD_LOGIC_VECTOR(1 downto 0);
           output : out  STD_LOGIC_VECTOR (15 downto 0));
           
end component;



component Sign_Extend   is


 Port ( Input : in  STD_LOGIC_VECTOR (7 downto 0);       --8 bit input
           Output : out  STD_LOGIC_VECTOR (15 downto 0));   --16bit output
           
           
end component;     



component ShiftLeft is

 Port ( input : in  STD_LOGIC_VECTOR (15 downto 0);
        number_of_shift:in STD_LOGIC_VECTOR (15 downto 0);           
        output : out STD_LOGIC_VECTOR(15 downto 0));
        
        
end component; 



begin

jump_address<=(shifted)& ALU_in0(15 downto 12);

sign:sign_extend port map(ALU_in_immid,extended);
shift:ShiftLeft port map(extended,"0000000000000001",shifted_extended);
ALU_unit:ALU port map(ALU_in0,ALU_in1,ALU_in2,shifted_extended,Opcode,ALU_src_A,ALU_src_B,ALU_Result ,high_signal,sr_signal,zero_bit); 
shifting:ShiftLeft port map(extended,"0000000000000001",shifted); 
mux4:mux_4_to_1 port map(gnd,ALU_Result_signal,shifted_sign_final,gnd,pc_src,pc_addr_out);                                


shifted_sign_final<=jump_address(15 downto 0);

high_result<=high_signal;

end EX;