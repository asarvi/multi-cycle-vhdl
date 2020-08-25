library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity unified_mem is
port(addr:in std_logic_vector(15 downto 0);
wdata:in std_logic_vector(15 downto 0);
rdata:out std_logic_vector(15 downto 0);
 memwrite: in std_logic;
 memread :in std_logic;
 clk:in std_logic);
       
 end unified_mem;
 
 architecture mem of unified_mem is

type memtype is array (2**12 -1 downto 0)of std_logic_vector( 15 downto 0);  
signal memcontent : memtype := (others=>(others=>'0'));
begin


process(clk)
 begin
 if(clk'event and clk='1'  )then  

 if( memread='1' and memwrite='1')then  

 rdata<=wdata;
memcontent(to_integer(unsigned(addr(15 downto 0))))<=wdata;


 elsif( memwrite ='1' )then   --and ctrladdr ='1'
memcontent(to_integer(unsigned(addr(11 downto 0))))<=wdata;    --another signal from memtype?

elsif (memread='1')then
rdata<=memcontent(to_integer(unsigned(addr(11 downto 0)))) ;

end if;
end if;
end process;

end mem;
