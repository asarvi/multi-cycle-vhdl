library ieee;
use ieee.std_logic_1164.all;

entity Lo is
port(clk:in std_logic;
data:inout std_logic_vector(15 downto 0);
Lowout:inout std_logic_vector(15 downto 0));
end Lo;


architecture Lo of Lo is

signal Lo_out:std_logic_vector(15 downto 0);
begin

process(clk)
begin

if(clk'event and clk='1')then

Lo_out<=data;

end if;

end process;

Lowout<=Lo_out;

end Lo; 