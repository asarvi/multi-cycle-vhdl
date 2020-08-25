library ieee;
use ieee.std_logic_1164.all;

entity D3 is
port(clk:in std_logic;
data:in std_logic_vector(15 downto 0);
D3out:out std_logic_vector(15 downto 0));
end D3;


architecture D3 of D3 is

signal D3_out:std_logic_vector(15 downto 0);
begin

process(clk)
begin

if(clk'event and clk='1')then

D3_out<=data;

end if;

end process;

D3out<=D3_out;

end D3; 