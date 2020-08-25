library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.NUMERIC_STD.ALL;

entity ShiftLeft is
    Port ( input : in  STD_LOGIC_VECTOR (15 downto 0);
        number_of_shift:in STD_LOGIC_VECTOR (15 downto 0);           
        output : out STD_LOGIC_VECTOR(15 downto 0));
        
end ShiftLeft;

architecture Behavioral of ShiftLeft is
signal numshift:integer;
begin
  numshift<= to_integer(unsigned(input(15 downto 0))); 
    output <=  std_logic_vector(unsigned(input) sll numshift );

end Behavioral;