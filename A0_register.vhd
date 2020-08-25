library ieee;
use ieee.std_logic_1164.all;

entity A0 is
port(clk:in std_logic;
data:in std_logic_vector(15 downto 0);
A0out:out std_logic_vector(15 downto 0));
end A0;


architecture A0 of A0 is

signal A0_out:std_logic_vector(15 downto 0);
begin

process(clk)
begin

if(clk'event and clk='1')then

A0_out<=data;

end if;

end process;

A0out<=A0_out;

end A0; 