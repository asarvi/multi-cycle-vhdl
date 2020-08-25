library ieee;
use ieee.std_logic_1164.all;

entity SR is
port(clk:in std_logic;
data:in std_logic_vector(15 downto 0);
SRout:out std_logic_vector(15 downto 0));
end SR;


architecture SR of SR is

signal SR_out:std_logic_vector(15 downto 0);
begin

process(clk)
begin

if(clk'event and clk='1')then

SR_out<=data;

end if;

end process;

SRout<=SR_out;

end SR; 