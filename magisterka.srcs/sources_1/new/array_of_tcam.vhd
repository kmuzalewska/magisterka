library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library xil_defaultlib;
use xil_defaultlib.types.all;

entity array_of_tcam is
 Port (
    CLK: in std_logic;
    DATA_IN: in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT: out ENCODER_ARRAY:=(others => (others => '0'));
    MEM_CONTENT : in TCAM_ARRAY_3D
  );
end array_of_tcam;

architecture Behavioral of array_of_tcam is

begin

    GEN_TCAM_MEMORIES: for mem_index in 0 to NUMBER_OF_MEMORIES-1 generate
      TCAM_INST:  entity xil_defaultlib.tcam 
      generic map(tcam_nr => mem_index)
      port map(
      CLK       => CLK,           
      DATA_IN   => DATA_IN,      
      DATA_OUT  => DATA_OUT(mem_index),    
      ONE_MEM_CONTENT => MEM_CONTENT(mem_index)  
       );         
    end generate;
    

end Behavioral;