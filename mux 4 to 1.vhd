library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;



entity mux_4_to_1 is
    Port ( inputA : in  STD_LOGIC_VECTOR (15 downto 0);
           inputB : in  STD_LOGIC_VECTOR (15 downto 0);
           inputC : in  STD_LOGIC_VECTOR (15 downto 0);
           inputD : in  STD_LOGIC_VECTOR (15 downto 0);
           sel : in  STD_LOGIC_VECTOR(1 downto 0);
           output : out  STD_LOGIC_VECTOR (15 downto 0));
end mux_4_to_1;


architecture mux_4_to_1 of mux_4_to_1 is

begin

  output <= inputA when sel="00" else
            inputB when sel="01" else
            inputC when sel="10" else
            inputD;

end mux_4_to_1;
