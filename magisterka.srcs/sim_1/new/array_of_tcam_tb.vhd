library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
library xil_defaultlib;
use xil_defaultlib.types.all;
use xil_defaultlib.data_to_tcam.all;

entity array_of_tcam_tb is
end;

architecture bench of array_of_tcam_tb is

  component array_of_tcam
   Port (
      CLK: in std_logic;
      DATA_IN: in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT: out ENCODER_ARRAY;
      MEM_CONTENT : in TCAM_ARRAY_3D
    );
  end component;

  signal CLK: std_logic:='0';
  signal DATA_IN: std_logic_vector(DATA_SIZE-1 downto 0);
  signal DATA_OUT: ENCODER_ARRAY;
  signal MEM_CONTENT: TCAM_ARRAY_3D:= DATA_TO_TCAM;

begin

  uut: array_of_tcam port map ( CLK         => CLK,
                                DATA_IN     => DATA_IN,
                                DATA_OUT    => DATA_OUT,
                                MEM_CONTENT => MEM_CONTENT );

  stimulus: process
  begin
  
    CLK <= not CLK after 1ps;
    DATA_IN <= "00110011001011111000100100011001";
    MEM_CONTENT <= MEM_CONTENT;


    wait;
  end process;


end;