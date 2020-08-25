library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is

  generic
        ( ADDR_WIDTH : integer := 16 ;
         DATA_WIDTH : integer :=16
        );
    port
        ( clk          : in std_logic
        ; read_reg_1   : in  STD_LOGIC_VECTOR (3 downto 0)
        ; read_reg_2   : in  STD_LOGIC_VECTOR (3 downto 0)
        ; write_reg    : in  STD_LOGIC_VECTOR (3 downto 0)
        ; write_data   : in  STD_LOGIC_VECTOR (15 downto 0)
        ; write_enable : in  STD_LOGIC
        ; read_data_1  : out  STD_LOGIC_VECTOR (15 downto 0)
        ; read_data_2  : out  STD_LOGIC_VECTOR (15 downto 0)
        );

end register_file;

architecture Behavioral of register_file is

    subtype register_t is std_logic_vector(DATA_WIDTH - 1 downto 0);
    type regfile_t is array (DATA_WIDTH - 1 downto 0) of register_t;
    signal regfile : regfile_t;    --(15 downto 0);
    constant regfile_reset : regfile_t := (others => (others => '0'));   --(15 downto 0) := (others => (others => '0'));

begin

    process (clk, regfile, read_reg_1)
    begin
     
         if read_reg_1 = "0000"  then
            read_data_1 <= (others => '0'); -- Hardwire r0 to 0
        else
            read_data_1 <= regfile(to_integer(unsigned(read_reg_1)));
        end if;

    end process;
    
    
    process (clk, regfile, read_reg_2)
    begin 
    if read_reg_2 = "0000"  then
            read_data_2 <= (others => '0'); --Hardwire r0 to 0
        else
            read_data_2 <= regfile(to_integer(unsigned(read_reg_2)));
        end if;      
    end process;
    

    process (clk)
    begin
        if (clk'event and clk='1') then
            if write_enable = '1' then
                regfile(to_integer(unsigned(write_reg))) <= write_data;
            end if;
        end if;
    end process;

end Behavioral;