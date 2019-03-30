library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
library xil_defaultlib;
use xil_defaultlib.types.all;
use xil_defaultlib.data_to_tcam.all;


entity main_tb is
end;

architecture bench of main_tb is

  component main
    Port ( 
      CLK: in std_logic;
      DATA_IN: in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_TO_TCAM: in TCAM_ARRAY_3D;
      CHOSEN_OUTPUT: out integer
    );
  end component;

  signal CLK: std_logic:= '0';
  signal DATA_IN: std_logic_vector(DATA_SIZE-1 downto 0);
  signal DATA_TO_TCAM: TCAM_ARRAY_3D:= xil_defaultlib.data_to_tcam.DATA_TO_TCAM;
  signal CHOSEN_OUTPUT: integer ;
  constant clk_period : time := 1ps;

begin

  uut: main port map ( CLK           => CLK,
                       DATA_IN       => DATA_IN,
                       DATA_TO_TCAM  => DATA_TO_TCAM,
                       CHOSEN_OUTPUT => CHOSEN_OUTPUT );

  stimulus: process
  begin
  
    CLK <= not CLK after 1ps;
    DATA_IN <= "00110011001011111000100100011001";
    DATA_TO_TCAM <= DATA_TO_TCAM;


  end process;


end;
  