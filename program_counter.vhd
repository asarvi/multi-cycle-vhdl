library ieee;
use ieee.std_logic_1164.all;

entity pc is
port(clk:in std_logic;
pcsignal:in std_logic;        -- (pc write con and zero) or pcwrite 
data1:in std_logic_vector(15 downto 0);
pc_out:out std_logic_vector(15 downto 0));
end pc;


architecture pc of pc is

signal pcout:std_logic_vector(15 downto 0);
begin



pc_out<=pcout;


process(clk,pcsignal,data1)
begin

if(clk'event and clk='1' )then
if (pcsignal='1')then

pcout<=data1;

end if;
end if;
end process;



end pc; 