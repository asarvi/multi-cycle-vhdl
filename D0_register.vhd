library ieee;
use ieee.std_logic_1164.all;

entity D0 is
port(clk:in std_logic;
data_in:in std_logic_vector(15 downto 0);
D0out:out std_logic_vector(15 downto 0));
end D0;


architecture D0 of D0 is

signal D0_out:std_logic_vector(15 downto 0);
begin

process(clk)
begin

if(clk'event and clk='1')then

D0_out<=data_in;

end if;

end process;

D0out<=D0_out;

end D0; 