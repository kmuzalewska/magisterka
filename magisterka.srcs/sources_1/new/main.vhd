
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library xil_defaultlib;
use xil_defaultlib.types.all;
--Library xpm;
--use xpm.vcomponent.all;
use xil_defaultlib.data_to_tcam.all;


entity main is
  Port ( 
    CLK: in std_logic;
    DATA_IN: in std_logic_vector(DATA_SIZE-1 downto 0);
   -- DATA_TO_TCAM: in TCAM_ARRAY_3D;
    CHOSEN_OUTPUT: out integer
  );
end main;

architecture Behavioral of main is
    signal data_to_encoder: ENCODER_ARRAY;
--    signal DANE_OD_PDULINSKIEGO: TCAM_ARRAY_3D;

component array_of_tcam
 Port (
    CLK: in std_logic;
    DATA_IN: in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT: out ENCODER_ARRAY;
    MEM_CONTENT : in TCAM_ARRAY_3D
  );
end component;

component encoder
  Port ( 
    CLK: in std_logic;
    RESULTS_FROM_TCAMS: in ENCODER_ARRAY;
    CHOSEN_OUTPUT: out integer
  );
end component;


begin

ARRAY_OF_TCAM_INST: entity xil_defaultlib.array_of_tcam
port map(
    CLK => CLK,
    DATA_IN => DATA_IN,
    DATA_OUT => data_to_encoder,
    MEM_CONTENT => DATA_TO_TCAM
);

ENCODER_INST: entity xil_defaultlib.encoder
port map(
    CLK => CLK,
    RESULTS_FROM_TCAMS => data_to_encoder,
    CHOSEN_OUTPUT=> CHOSEN_OUTPUT
);

end Behavioral;