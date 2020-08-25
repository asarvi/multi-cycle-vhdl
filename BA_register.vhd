library ieee;
use ieee.std_logic_1164.all;

entity BA is
port(clk:in std_logic;
data:in std_logic_vector(15 downto 0);
BA_out:out std_logic_vector(15 downto 0));
end BA;


architecture BA of BA is

signal BAout:std_logic_vector(15 downto 0);
begin

process(clk)
begin

if(clk'event and clk='1')then

BAout<=data;

end if;

end process;

BA_out<=BAout;

end BA; 