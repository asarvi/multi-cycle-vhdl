library ieee;
use ieee.std_logic_1164.all;

entity IR is
port(clk:in std_logic;
IRWrite:in std_logic;
instr:in std_logic_vector(15 downto 0);
Opcode:out std_logic_vector(3 downto 0);
rd:out std_logic_vector(3 downto 0);
rs:out std_logic_vector(3 downto 0);
immidiate:out std_logic_vector(7 downto 0));
end IR;


architecture IR of IR is

signal out1:std_logic_vector(3 downto 0);
signal out2:std_logic_vector(3 downto 0);
signal out3:std_logic_vector(3 downto 0);
signal out4:std_logic_vector(7 downto 0);


begin
  
  
process(clk,instr)
begin
  
out1<=instr(15 downto 12);
out2<=instr(11 downto 8);
out3<=instr(7 downto 4);
out4<=instr(7 downto 0);

end process;

Opcode<=out1;
rd<=out2;
rs<=out3;
immidiate<=out4;

end IR; 