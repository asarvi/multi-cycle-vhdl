library ieee;
use ieee.std_logic_1164.all;
--Clock 4
entity  AG  is

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

end AG;



architecture AG of AG is



signal gnd:std_logic_vector(15 downto 0):=X"0000";
signal reg_write_data:std_logic_vector(15 downto 0); -- input of register file
signal mem_in_addr:std_logic_vector(15 downto 0);   --for LW


component register_file is


 generic
        ( ADDR_WIDTH : integer  ;
         DATA_WIDTH : integer
        );
    port
        ( clk          : in std_logic
        ; read_reg_1   : in  STD_LOGIC_VECTOR (3 downto 0)
        ; read_reg_2   : in  STD_LOGIC_VECTOR (3 downto 0)
        ; write_reg    : in  STD_LOGIC_VECTOR (3 downto 0)
        ; write_data   : in  STD_LOGIC_VECTOR (15 downto 0)
        ; write_enable : in  STD_LOGIC
        ; read_data_1  : out  STD_LOGIC_VECTOR (15 downto 0)
        ; read_data_2  : out  STD_LOGIC_VECTOR (15 downto 0)
        );

end component;



component unified_mem is

port(addr:in std_logic_vector(15 downto 0);
wdata:in std_logic_vector(15 downto 0);
rdata:out std_logic_vector(15 downto 0);
 memwrite: in std_logic;
 memread :in std_logic;
 clk:in std_logic);
 
 
 end component;
 
 
component mux_4_to_1  is


 Port ( inputA : in  STD_LOGIC_VECTOR (15 downto 0);
           inputB : in  STD_LOGIC_VECTOR (15 downto 0);
           inputC : in  STD_LOGIC_VECTOR (15 downto 0);
           inputD : in  STD_LOGIC_VECTOR (15 downto 0);
           sel : in  STD_LOGIC_VECTOR(1 downto 0);
           output : out  STD_LOGIC_VECTOR (15 downto 0));
           
           
end component;  



component BinaryMux is

Port ( inputA : in  STD_LOGIC_VECTOR (15 downto 0);
           inputB : in  STD_LOGIC_VECTOR (15 downto 0);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (15 downto 0));
           
           
           
end component;                     


begin

mux1:BinaryMux port map(register_data,gnd,memtoreg,reg_write_data);

registerfile:register_file generic map(ADDR_WIDTH=>16,DATA_WIDTH=>16) 
                           port map(clk,"0000","0000",reg_dest,reg_write_data,regwrite,open,open);
                           
mux2:mux_4_to_1 port map(gnd,register_data,base_address,gnd,I_or_D_or_BA,mem_in_addr);


memory:unified_mem port map ( mem_in_addr,register_data_out,memdata,memwrite,memread,clk);



end AG;