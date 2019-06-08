library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library xil_defaultlib;
use xil_defaultlib.types.all;

entity tcam is
  Port (
  CLK: in std_logic;
  DATA_IN: in std_logic_vector(DATA_SIZE-1 downto 0);
  DATA_OUT: out std_logic_vector(TCAM_MAX_SIZE-1 downto 0);
  ONE_MEM_CONTENT : in TCAM_ARRAY_2D -- it should be written from outside - e.g. Z.Dulinski algorithm
   );
end tcam;

architecture Behavioral of tcam is        
begin

GENERATE_TCAM_RESPONSE: for mem_address in 0 to TCAM_MAX_SIZE-1 generate
    COMP_PROC: process(CLK)
    begin
        if rising_edge(CLK) then
            if (equal_array(ONE_MEM_CONTENT(mem_address), DATA_IN)) then
                DATA_OUT(mem_address) <= '1';
            else
                DATA_OUT(mem_address) <= '0';
            end if;
        end if;
    end process;
end generate GENERATE_TCAM_RESPONSE;

end Behavioral;
