library ieee;
use ieee.std_logic_1164.all;

--clock 5

entity Reg_Write is


port(rdest:in std_logic_vector(3 downto 0);
memorydata:in std_logic_vector(15 downto 0);    --writes memory data in register(LW)
memtoreg:in std_logic;
regwrite:in std_logic;
clk:in std_logic);


end  Reg_Write;


architecture Reg_Write of Reg_Write is

signal gnd:std_logic_vector(15 downto 0):=X"0000";
signal mux_out:std_logic_vector(15 downto 0);   --input of write data in register file


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



component  BinaryMux is

 Port ( inputA : in  STD_LOGIC_VECTOR (15 downto 0);
           inputB : in  STD_LOGIC_VECTOR (15 downto 0);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (15 downto 0));
           
           
end component;           

begin

mux:BinaryMux port map(gnd,memorydata,memtoreg,mux_out);

registers:register_file generic map (ADDR_WIDTH =>16,DATA_WIDTH =>16) 
                        port map (clk,"0000","0000",rdest,mux_out,regwrite,open,open);
                        
                        
                        
end   Reg_Write;                      