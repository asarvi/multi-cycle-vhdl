library ieee;
use ieee.std_logic_1164.all;

entity D1 is
port(clk:in std_logic;
data:in std_logic_vector(15 downto 0);
D1out:out std_logic_vector(15 downto 0));
end D1;


architecture D1 of D1 is

signal D1_out:std_logic_vector(15 downto 0);
begin

process(clk)
begin

if(clk'event and clk='1')then

D1_out<=data;

end if;

end process;

D1out<=D1_out;

end D1; 