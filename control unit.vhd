library ieee;
use ieee.std_logic_1164.all;


entity CU is --control unit

port(clk:in std_logic;
reset:in std_logic;
Opcode:in std_logic_vector(3 downto 0);
zero:in std_logic;
pcsrc:out std_logic_vector(1 downto 0);
ALUSrcA:out std_logic;
ALUSrcB:out std_logic_vector(1 downto 0);
regwrite:out std_logic;
pcwritecond:out std_logic;
pcwrite:out std_logic;
pcwriter: out std_logic; -- input signal for PC
I_or_D_or_BA:out std_logic_vector(1 downto 0);-- input signal for multiplexer that chooses between pc , aluout and BA
memread:out std_logic;
memwrite:out std_logic;
memtoreg:out std_logic;
IRWrite:out std_logic;
ALUop: out std_logic_vector(3 downto 0));


end CU;


architecture CU of CU is




TYPE states IS (state0, state1, state2, state3, state4,state5,state6,state7,state8,state9);
SIGNAL pr_state, nx_state: states;
SIGNAL pc_src:std_logic_vector(1 downto 0); -- temp signals 
signal ALUSrc_A:std_logic;
signal ALUSrc_B:std_logic_vector(1 downto 0);
signal reg_write:std_logic;
--signal zerobit:std_logic;
signal pc_write_cond:std_logic;
signal pc_write:std_logic;
signal IorDorBA:std_logic_vector(1 downto 0);
signal mem_read:std_logic;
signal mem_write:std_logic;
signal mem_to_reg:std_logic;
signal IR_Write:std_logic;
signal pc_writer: std_logic;
signal ALU_OP: std_logic_vector(3 downto 0);
  
BEGIN

PROCESS (clk,reset) --lower section
BEGIN


if(reset='1')then
pr_state <= state0;

ELSIF (clk'EVENT AND clk='1') THEN
pcsrc <= pc_src;
ALUSrcA  <=  ALUSrc_A;
ALUSrcB  <=  ALUSrc_B;
regwrite <= reg_write;
pcwritecond  <= pc_write_cond;
pcwrite  <= pc_write;
I_or_D_or_BA <= IorDorBA;
memread  <=  mem_read;
memwrite <= mem_write;
memtoreg <= mem_to_reg;
IRWrite <= IR_Write;
pcwriter <= (zero  and pc_write_cond ) or pc_write;
ALUop<=ALU_OP;

pr_state <= nx_state;
END IF;
END PROCESS;



PROCESS (Opcode,pr_state)
BEGIN

CASE pr_state IS
WHEN state0 =>       --IF

pc_write <= '1';
IorDorBA<="00";   
mem_read<='1';
IR_Write<='1';
ALUSrc_A<='0';
ALUSrc_B<="01";
pc_src<="00";
pc_write<='1';
ALU_Op<="0000";--opcode  add

nx_state <= state1;


WHEN state1 =>  --ID

ALUSrc_A<='0';
ALUSrc_B<="11";
ALU_Op<="0000"; 


IF (Opcode="0111" or  opcode ="1001") THEN 
     nx_state <= state2;

elsif( opcode ="0000" or opcode ="0010" or opcode ="0100" or opcode ="0101" or opcode ="0110") then
    nx_state <= state6;

elsif ( opcode = "1110") then
    nx_state<= state8;

elsif( opcode = "1111") then 
    nx_state <= state9;
else   nx_state <= state0;  

END IF;


WHEN state2 =>

ALUSrc_A<='1';
IorDorBA<="01";
ALUSrc_B<="10";
ALU_Op<="0000";   -- alu operation clk3

IF (Opcode="0111") THEN 
nx_state <= state3;

elsif ( opcode="1001") then
nx_state <= state5;
else nx_state <= state0;
END IF;

WHEN state3 =>  --loadword
IorDorBA <= "01";   
mem_read<= '1';


IF (Opcode="0111") THEN    
nx_state <= state4;
END IF;


WHEN state4 =>    -- LW _ completion
mem_to_reg<='0';
reg_write<='1';
 
nx_state <= state0; -- restarts


WHEN state5 =>   --storeword
mem_write<= '1';
IorDorBA<= "01";
nx_state <= state0;

WHEN state6 => --continue of R_type , execution

ALUsrc_A<= '1';
ALUSrc_B<="00";
ALU_Op<=Opcode; --Rtype

nx_state <= state7;

when state7 =>   --R_type completion
reg_write<= '1';
mem_to_reg <= '0';

nx_state<= state0;

when state8 =>   --BNE 
ALUSrc_A <= '1';
ALUSrc_B <="00";
ALU_op <= "0010"; -- subtract opcode for branch 
pc_write_cond<= '1';
pc_src<= "01";

nx_state<= state0;

when state9 =>  --jump

pc_write <= '1';
pc_src<= "10";

nx_state <= state0;


END CASE;
END PROCESS;

end CU;