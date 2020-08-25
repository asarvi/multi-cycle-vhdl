library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ;


entity multiply is
port(data1:in std_logic_vector(15 downto 0);       --first 16 bit register  
data2:in std_logic_vector(15 downto 0);            --second 16 bit register
out1_high:inout std_logic_vector(15 downto 0);
out2_low:inout std_logic_vector(15 downto 0);
clk:in std_logic);          
end multiply;

architecture multiply of multiply is
   

signal d1:integer;
signal d2:integer;
signal out2:integer;
signal firstout:std_logic_vector(31 downto 0);
 

 begin
 d1<= to_integer(unsigned(data1(15 downto 0)));      --change first one to integer
 d2<= to_integer(unsigned(data2));                   --change second one to integer 
 out2<=d1*d2;                                        --multiply  
firstout<= std_logic_vector(to_unsigned(out2,32));       --change output to std_logic_vector 32 bit

out1_high<=firstout(31 downto 16);
out2_low<=firstout(15 downto 0);

end multiply;
