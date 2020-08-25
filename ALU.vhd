library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ALU is

port(data0:in std_logic_vector(15 downto 0);
data1:in std_logic_vector(15 downto 0);
data2:in std_logic_vector(15 downto 0);
data3:in std_logic_vector(15 downto 0);
ALUOp:in std_logic_vector(3 downto 0);
ALUSrc_A:in std_logic;
ALUSrc_B:in std_logic_vector(1 downto 0);
low_result:out std_logic_vector(15 downto 0);
high_result:out std_logic_vector(15 downto 0);
sr_result:out std_logic_vector(15 downto 0);
zero:out std_logic);
 end ALU;

architecture ALU of ALU is

signal input1:std_logic_vector(16 downto 0);
signal input2:std_logic_vector(16 downto 0);
signal data_A:std_logic_vector(15 downto 0);
signal data_B:std_logic_vector(15 downto 0);
signal shift_out:std_logic_vector(15 downto 0);
signal result:std_logic_vector(15 downto 0);    --low output  signal
signal result1:std_logic_vector(15 downto 0);   --high output signal 
signal ALU_output: std_logic_vector(16 downto 0);   --one bit for overflow
signal multout1:std_logic_vector(15 downto 0);
signal multout2:std_logic_vector(15 downto 0);
signal sr:std_logic_vector(15 downto 0):=X"0000";

  
component ShiftLeft is
         Port ( input : in  STD_LOGIC_VECTOR (15 downto 0); 
        number_of_shift:in STD_LOGIC_VECTOR (15 downto 0);          
        output : out STD_LOGIC_VECTOR(15 downto 0));
        end component;
        
component multiply is
port(data1:in std_logic_vector(15 downto 0);       --first 16 bit register  
data2:in std_logic_vector(15 downto 0);            --second 16 bit register
out1_high:out std_logic_vector(15 downto 0);

out2_low:out std_logic_vector(15 downto 0));        
 end component;
 
 
 
component BinaryMUX  is
 
  Port ( inputA : in  STD_LOGIC_VECTOR (15 downto 0);
           inputB : in  STD_LOGIC_VECTOR (15 downto 0);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (15 downto 0));
end component;




component  mux_4_to_1  is
 
 
  Port ( inputA : in  STD_LOGIC_VECTOR (15 downto 0);
           inputB : in  STD_LOGIC_VECTOR (15 downto 0);
           inputC : in  STD_LOGIC_VECTOR (15 downto 0);
           inputD : in  STD_LOGIC_VECTOR (15 downto 0);
           sel : in  STD_LOGIC_VECTOR(1 downto 0);
           output : out  STD_LOGIC_VECTOR (15 downto 0));
end component;


 
                
begin


shift2:ShiftLeft port map (data_A,data_B,shift_out);
mult:multiply port map (data_A,data_B,multout1,multout2);
mux1:BinaryMux port map(data0,data1,ALUSrc_A,data_A);

mux2:mux_4_to_1 port map(data2,"0000000000000010",data3,"0000000000000000" ,ALUSrc_B,data_B);
input1<='0' & data_A;
input2<='0' & data_B;

process(data0,data1,data2,data3,ALUSrc_A,ALUSrc_B,ALUOp,input1,input2,ALU_output,sr,multout1,multout2,data_A,data_B,shift_out)


begin

 
if ALUOp="0000" then
     
             ALU_output <= (input1 + input2) ;
               low_result<=ALU_output(15 downto 0);
                sr(12)<=  ALU_output(16);   --overflow bit
                
                
                 if(sr(12)= '0')then          --check if it does'nt have overflow n is the last bit(sign bit) 
                    sr(14)<=  ALU_output(15);
                    else 
                  sr(14)<='0';          -- we assume that when we have overflow the result is always bigger than 0
                  end if;
                  
                  
                 if(ALU_output(15 downto 0) =X"0000")then    -- set the zero bit of status register
                    sr(15)<='1';
                    else
                        sr(15)<='0';
                        end if;
                        
                high_result<=X"0000"; 
                
     
      elsif  ALUOp="0010" then 
       
             ALU_output <= input1 - input2 ;
               low_result<=ALU_output(15 downto 0);
                sr(12)<=  ALU_output(16);   --overflow bit
                
                
                 if(sr(12)= '0')then          --check if it does'nt have overflow n is the last bit(sign bit) 
                    sr(14)<=  ALU_output(15);
                    else 
                  sr(14)<='0';          -- we assume that when we have overflow the result is always bigger than 0
                  end if;
                  
                  
                 if(ALU_output(15 downto 0) =X"0000")then    -- set the zero bit of status register
                    sr(15)<='1';
                    else
                        sr(15)<='0';
                        end if;
                high_result<=X"0000"; 
                
     
      elsif  ALUOp="0100"then
         
          high_result<= multout1  ;
         low_result <= multout2  ;
         
         
       elsif ALUOp="0101" then 
                
             low_result <= data_A and data_B ;
             high_result<=X"0000"; 
                  
                 if(ALU_output(15 downto 0) =X"0000")then    -- set the zero bit of status register
                    sr(15)<='1';
                    else
                        sr(15)<='0';
                        end if;
       
       
       
                
       elsif ALUOp="0110" then 
             low_result <= shift_out  ;
             high_result<=X"0000"; 
             
             
                 if(sr(12)= '0')then          --check if it does'nt have overflow n is the last bit(sign bit) 
                    sr(14)<=  ALU_output(15);
                    else 
                  sr(14)<='0';          -- we assume that when we have overflow the result is always bigger than 0
                  end if;
                  
                  
                 if(ALU_output(15 downto 0) =X"0000")then    -- set the zero bit of status register
                    sr(15)<='1';
                    else
                        sr(15)<='0';
                        end if;
                        
                        
                        
                        
                        
                        
                        
                        
                         
          elsif ALUOp="1101" then     --compara
              ALU_output <= input1 - input2 ;
               low_result<=ALU_output(15 downto 0);
                sr(12)<=  ALU_output(16);   --overflow bit
                
                
                 if(sr(12)= '0')then          --check if it does'nt have overflow n is the last bit(sign bit) 
                    sr(14)<=  ALU_output(15);
                    else 
                  sr(14)<='0';          -- we assume that when we have overflow the result is always bigger than 0
                  end if;
                  
                  
                 if(ALU_output(15 downto 0) =X"0000")then    -- set the zero bit of status register
                    sr(15)<='1';
                    else
                        sr(15)<='0';
                        end if;
                high_result<=X"0000";      
                
                
                  

 end if;
 
 end process;
 sr_result<=sr;
 
 end ALU;  
  
  
  
  