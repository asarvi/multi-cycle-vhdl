library ieee;
use ieee.std_logic_1164.all;
--clock 1
entity Instr_fetch is
port(clk:in std_logic;
pc_addr:inout std_logic_vector(15 downto 0);
ALU_Result_addr:in std_logic_vector(15 downto 0);
BA_addr:in std_logic_vector(15 downto 0);
I_or_D_or_BA:in std_logic_vector(1 downto 0);   --to choose between pc or BA or ALU Result
memread:in std_logic;
memwrite:in std_logic;
pc_src:in std_logic_vector(1 downto 0);
--write_data:in std_logic_vector(15 downto 0);
data:out std_logic_vector(15 downto 0);
new_pc:out std_logic_vector(15 downto 0));

end Instr_fetch;


architecture Instr_fetch of Instr_fetch is


signal alu_resu:std_logic_vector(15 downto 0);
signal address:std_logic_vector(15 downto 0);
signal dataout:std_logic_vector(15 downto 0);
signal gnd:std_logic_vector(15 downto 0):="0000000000000000";

component unified_mem is
port(addr:in std_logic_vector(15 downto 0);
wdata:in std_logic_vector(15 downto 0);
rdata:out std_logic_vector(15 downto 0);
 memwrite: in std_logic;
 memread :in std_logic;
 clk:in std_logic);
 
 end component;


component  mux_4_to_1 is
Port ( inputA : in  STD_LOGIC_VECTOR (15 downto 0);
           inputB : in  STD_LOGIC_VECTOR (15 downto 0);
           inputC : in  STD_LOGIC_VECTOR (15 downto 0);
           inputD : in  STD_LOGIC_VECTOR (15 downto 0);
           sel : in  STD_LOGIC_VECTOR(1 downto 0);
           output : out  STD_LOGIC_VECTOR (15 downto 0));


end component;


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



 
begin

mux:mux_4_to_1 port map (pc_addr,ALU_Result_addr,BA_addr,X"0000",I_or_D_or_BA,address);
memory:unified_mem port map (address,gnd,dataout,memwrite,memread,clk);
ALU_unit:ALU port map (pc_addr,X"0000",X"0000",X"0000",ALUOp=>"0000",ALUSrc_A=>'0',ALUSrc_B=>"01",low_result=>alu_resu,high_result=>open,sr_result=>open,zero=>open);
data<=dataout;
new_pc <= alu_resu;

end Instr_fetch; 