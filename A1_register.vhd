library ieee;
use ieee.std_logic_1164.all;

entity A1 is          --A1 is Memory Data Register
port(clk:in std_logic;
data:inout std_logic_vector(15 downto 0);
A1out:inout std_logic_vector(15 downto 0));
end A1;


architecture A1 of A1 is

signal A1_out:std_logic_vector(15 downto 0);
begin

process(clk)
begin

if(clk'event and clk='1')then

A1_out<=data;

end if;

end process;

A1out<=A1_out;

end A1; 