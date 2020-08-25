library ieee;
use ieee.std_logic_1164.all;

--    d0 d1 d2d3 low high pc ba   ir a0 sr 
entity cpu_multicycle is


port(clk:in std_logic;
reset:in std_logic;
ALU_RESULT_FINAL:out std_logic_vector(15 downto 0);
MEMORY_DATA_FINAL:out std_logic_vector(15 downto 0);
PC_OUT_FINAL:out std_logic_vector(15 downto 0);
HIGH_OUT_FINAL:out std_logic_vector(15 downto 0));


end cpu_multicycle;



architecture structural of cpu_multicycle is





component CU is


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

end component;






component Instr_fetch  is



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

end component;





component ID is

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


end component;





component EX is



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


end component;



component AG is


port(register_data:in std_logic_vector(15 downto 0);     --ALU out data (register write data (R_Type)or memory address(LW or SW))
register_data_out:in std_logic_vector(15 downto 0);      --input of memory(write data(SW))
base_address:in std_logic_vector(15 downto 0);
reg_dest:in std_logic_vector(3 downto 0);
regwrite:in std_logic;
memtoreg:in std_logic;
clk:in std_logic;
I_or_D_or_BA:in std_logic_vector(1 downto 0);
memread:in std_logic;
memwrite:in std_logic;
memdata:out std_logic_vector(15 downto 0));



end component;



component  Reg_Write   is



port(rdest:in std_logic_vector(3 downto 0);
memorydata:in std_logic_vector(15 downto 0);    --writes memory data in register(LW)
memtoreg:in std_logic;
regwrite:in std_logic;
clk:in std_logic);


end  component;






component  D0 is



port(clk:in std_logic;
data_in:in std_logic_vector(15 downto 0);
D0out:out std_logic_vector(15 downto 0));

end component;




component  D1 is

port(clk:in std_logic;
data:in std_logic_vector(15 downto 0);
D1out:out std_logic_vector(15 downto 0));

end component ;



component D2  is


port(clk:in std_logic;
data:in std_logic_vector(15 downto 0);
D2out:out std_logic_vector(15 downto 0));

end component ;


component D3  is

port(clk:in std_logic;
data:in std_logic_vector(15 downto 0);
D3out:out std_logic_vector(15 downto 0));

end component;


component Lo  is

port(clk:in std_logic;
data:inout std_logic_vector(15 downto 0);
Lowout:inout std_logic_vector(15 downto 0));

end component;


component Hi is

port(clk:in std_logic;
data:inout std_logic_vector(15 downto 0);
Hiout:inout std_logic_vector(15 downto 0));

end component ;



component pc   is


port(clk:in std_logic;
pcsignal:in std_logic;        -- (pc write con and zero) or pcwrite 
data1:in std_logic_vector(15 downto 0);
pc_out:out std_logic_vector(15 downto 0));

end component;


component  BA is

port(clk:in std_logic;
data:in std_logic_vector(15 downto 0);
BA_out:out std_logic_vector(15 downto 0));

end  component;


component IR   is


port(clk:in std_logic;
IRWrite:in std_logic;
instr:in std_logic_vector(15 downto 0);
Opcode:out std_logic_vector(3 downto 0);
rd:out std_logic_vector(3 downto 0);
rs:out std_logic_vector(3 downto 0);
immidiate:out std_logic_vector(7 downto 0));

end  component;


component A0  is

port(clk:in std_logic;
data:in std_logic_vector(15 downto 0);
A0out:out std_logic_vector(15 downto 0));

end component;



component SR is

port(clk:in std_logic;
data:in std_logic_vector(15 downto 0);
SRout:out std_logic_vector(15 downto 0));
end component;


signal gnd:std_logic_vector(15 downto 0):=X"0000";
--pc signals
signal pc_address_in:std_logic_vector(15 downto 0);
signal pc_address_out:std_logic_vector(15 downto 0);

--control signals

SIGNAL pc_src:std_logic_vector(1 downto 0); -- temp signals 
signal ALUSrc_A:std_logic;
signal ALUSrc_B:std_logic_vector(1 downto 0);
signal reg_wr:std_logic;
signal zerobit:std_logic;
signal pc_write_cond:std_logic;
signal pc_write:std_logic;
signal IorDorBA:std_logic_vector(1 downto 0);
signal mem_read:std_logic;
signal mem_write:std_logic;
signal mem_to_reg:std_logic;
signal IR_Write:std_logic;
signal pc_writer: std_logic;
signal ALU_OP: std_logic_vector(3 downto 0);

--BA signals
signal BA_in:std_logic_vector(15 downto 0);
signal BA_out:std_logic_vector(15 downto 0);
--memory signal
signal mem_data_out:std_logic_vector(15 downto 0);
--D0 signal
signal D0_reg_out:std_logic_vector(15 downto 0);
--D1 signal
signal D1_reg_out:std_logic_vector(15 downto 0);
--D2 signals
signal D2_reg_out:std_logic_vector(15 downto 0);
--ID signals
signal ID_out_1:std_logic_vector(15 downto 0);
signal ID_out_2:std_logic_vector(15 downto 0);
signal ALU_Resu:std_logic_vector(15 downto 0);   --ALUout<=pc + sign_extended[IR(7 downto 0)*2]
--D3 signal
signal D3_reg_input:std_logic_vector(15 downto 0);
signal D3_reg_out:std_logic_vector(15 downto 0);
--EX
signal ALU_out_signal:std_logic_vector(15 downto 0);   --LW or SW  or R_type
signal zerobit_signal:std_logic;                       --for BNE
signal ALU_out_ex:std_logic_vector(15 downto 0);       --for EX
signal pc_address_in_new:std_logic_vector(15 downto 0);
signal high_out:std_logic_vector(15 downto 0);
signal high_out_finall:std_logic_vector(15 downto 0);
--Low
signal Low_out:std_logic_vector(15 downto 0);
--AG
signal memory_data_signal:std_logic_vector(15 downto 0);
--A0 signal
signal A0_reg:std_logic_vector(15 downto 0);

begin

--IF
control_unit:CU port map(clk,reset,mem_data_out(15 downto 12),zerobit,pc_src,ALUSrc_A,ALUSrc_B,reg_wr, pc_write_cond,
pc_write,pc_writer,IorDorBA,mem_read,mem_write,mem_to_reg,IR_Write,ALU_OP);


program_counter:pc port map(clk,pc_writer,pc_address_in,pc_address_out);

Base_Address:BA port map(clk,BA_in,BA_out);

instruction_fetch:Instr_fetch port map(clk,pc_address_out,gnd,BA_out,IorDorBA,mem_read,mem_write,pc_src,mem_data_out,pc_address_in);

instruction_register:IR port map(clk,IR_Write,mem_data_out,mem_data_out(15 downto 12),mem_data_out(11 downto 8),mem_data_out(7 downto 4)
,mem_data_out(7 downto 0));

d0_mapping:D0 port map(clk,pc_address_out,D0_reg_out);

--ID


D1_mapping:D1 port map(clk,ID_out_1,D1_reg_out);
D2_mapping:D2 port map(clk,ID_out_2,D2_reg_out);
D3_mapping:D3 port map(clk,D3_reg_input,D3_reg_out);
instruction_decode:ID port map(pc_address_out,mem_data_out(11 downto 8),
mem_data_out(7 downto 4),clk,mem_data_out(7 downto 0),ALUSrc_A,ALUSrc_B,ALU_Op,ID_out_1,ID_out_2,ALU_Resu,D3_reg_input);


--EX
Low_mapping:Lo port map(clk,ALU_out_ex,Low_out);
High_mapping:Hi port map(clk,high_out,high_out_finall);
execute:EX port map(ALU_OP,D0_reg_out,D1_reg_out,D2_reg_out,mem_data_out(7 downto 0),ALUSrc_A,clk,ALUSrc_B,pc_src,ALU_out_ex,
pc_address_in_new,zerobit_signal,high_out);
--pc_address_in<=pc_address_in_new after 10 ns;


--AG

AG_mapping:AG port map(ALU_out_ex,D2_reg_out,BA_out,mem_data_out(11 downto 8),reg_wr,mem_to_reg,clk,IorDorBA,mem_read,mem_write,memory_data_signal);

A0_mapping:A0 port map (clk,memory_data_signal,A0_reg);

--Write Back

write_back:Reg_Write port map (mem_data_out(11 downto 8),A0_reg,mem_to_reg,reg_wr,clk);

ALU_RESULT_FINAL<= ALU_out_ex;
MEMORY_DATA_FINAL<=memory_data_signal;
PC_OUT_FINAL<=pc_address_in_new;
HIGH_OUT_FINAL<=high_out_finall;





end structural;