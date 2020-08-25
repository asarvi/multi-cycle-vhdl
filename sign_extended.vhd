library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Sign_Extend is
    Port ( Input : in  STD_LOGIC_VECTOR (7 downto 0);       --8 bit input
           Output : out  STD_LOGIC_VECTOR (15 downto 0));   --16bit output
end Sign_Extend;

architecture Behavioral of Sign_Extend is

begin
  
  Output <= std_logic_vector(resize(signed(Input), Output'length));    --chane 8 bit to 16 bit

end Behavioral;
