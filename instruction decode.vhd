library ieee;
use ieee.std_logic_1164.all;
--clock 2  
entity ID is
port(pc_address:in std_logic_vector(15 downto 0);
rdest:in std_logic_vector(3 downto 0);
rsrc:in std_logic_vector(3 downto 0);
clk:in std_logic;
immi:in std_logic_vector(7 downto 0);
ALU_srcA:in std_logic;
ALU_srcB:in std_logic_vector(1 downto 0);
ALU_opcode:in std_logic_vector(3 downto 0);
read_data1:out std_logic_vector(15 downto 0);
read_data2:out std_logic_vector(15 downto 0);
ALU_out:out std_logic_vector(15 downto 0);
sign_extended_shifted_imm:out std_logic_vector(15 downto 0));

end ID;

architecture ID of ID is
         
         
signal gnd :std_logic_vector(15 downto 0) := X"0000";  
signal regout1 :std_logic_vector(15 downto 0);
signal regout2 :std_logic_vector(15 downto 0); 
signal shifted:std_logic_vector(15 downto 0); 
signal extended:std_logic_vector(15 downto 0); 
signal ALUin1:std_logic_vector(15 downto 0);
signal ALUin2:std_logic_vector(15 downto 0);


component register_file is

 generic
        ( ADDR_WIDTH : integer  ;
         DATA_WIDTH : integer 
        );
    port
        ( clk          : in std_logic;
         read_reg_1   : in  STD_LOGIC_VECTOR (3 downto 0);
         read_reg_2   : in  STD_LOGIC_VECTOR (3 downto 0);
         write_reg    : in  STD_LOGIC_VECTOR (3 downto 0);
         write_data   : in  STD_LOGIC_VECTOR (15 downto 0);
         write_enable : in  STD_LOGIC;
         read_data_1  : out  STD_LOGIC_VECTOR (15 downto 0);
         read_data_2  : out  STD_LOGIC_VECTOR (15 downto 0));
end component;


component BinaryMux  is

 Port ( inputA : in  STD_LOGIC_VECTOR (15 downto 0);
           inputB : in  STD_LOGIC_VECTOR (15 downto 0);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (15 downto 0));
           
           end component;
           
           
component mux_4_to_1 is


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




component  ShiftLeft is


 Port ( input : in  STD_LOGIC_VECTOR (15 downto 0);
        number_of_shift:in STD_LOGIC_VECTOR (15 downto 0);           
        output : out STD_LOGIC_VECTOR(15 downto 0));
            
end component; 





component  Sign_Extend is


 Port ( Input : in  STD_LOGIC_VECTOR (7 downto 0);       
           Output : out  STD_LOGIC_VECTOR (15 downto 0));   
end component; 


                            

begin

      

registerfile:register_file generic map(ADDR_WIDTH=>16,DATA_WIDTH=>16)
                           port map (clk,rdest,rsrc,rdest,gnd,'0',regout1,regout2);


sign:Sign_Extend port map (immi,extended);
shift:ShiftLeft port map (extended,"0000000000000001",shifted);
mux2:BinaryMux port map(pc_address,regout1,ALU_SrcA,ALUin1);
mux4:mux_4_to_1 port map (regout2,"0000000000000010",extended,gnd,ALU_SrcB,ALUin2);
ALU_unit:ALU port map (pc_address,regout1,regout2,extended,ALU_opcode,ALU_srcA,ALU_srcB,ALU_out,open,open,open);

sign_extended_shifted_imm<=shifted;

end ID;  
