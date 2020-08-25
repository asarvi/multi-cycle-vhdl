library ieee;
use ieee.std_logic_1164.all;

entity Hi is
port(clk:in std_logic;
data:inout std_logic_vector(15 downto 0);
Hiout:inout std_logic_vector(15 downto 0));
end Hi;


architecture Hi of Hi is

signal Hi_out:std_logic_vector(15 downto 0);
begin

process(clk)
begin

if(clk'event and clk='1')then

Hi_out<=data;

end if;

end process;

Hiout<=Hi_out;

end Hi; 