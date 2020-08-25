library ieee;
use ieee.std_logic_1164.all;

entity D2 is
port(clk:in std_logic;
data:in std_logic_vector(15 downto 0);
D2out:out std_logic_vector(15 downto 0));
end D2;


architecture D2 of D2 is

signal D2_out:std_logic_vector(15 downto 0);
begin

process(clk)
begin

if(clk'event and clk='1')then

D2_out<=data;

end if;

end process;

D2out<=D2_out;

end D2; 