library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
library xil_defaultlib;
use xil_defaultlib.types.all;
use xil_defaultlib.item_to_encoder.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity encoder_tb is
end;

architecture bench of encoder_tb is

  component encoder
    Port ( 
      CLK: in std_logic;
      RESULTS_FROM_TCAMS: in ENCODER_ARRAY;
      CHOSEN_OUTPUT: out integer
    );
  end component;

  signal CLK: std_logic;
  signal RESULTS_FROM_TCAMS: ENCODER_ARRAY=ITEM_TO_ENCODER;
  signal CHOSEN_OUTPUT: integer;

  
  constant T : time := 20 ns;
  file output_buf : text; -- text is keyword
  file input_buf : text;
begin

  uut: encoder port map ( CLK                => CLK,
                          RESULTS_FROM_TCAMS => RESULTS_FROM_TCAMS,
                          CHOSEN_OUTPUT      => CHOSEN_OUTPUT );

  clk_proc: process
  begin
        clk <= '0';
        wait for T/2;
        clk <= '1';
        wait for T/2;
 end process clk_proc;

take_and_write: process
    variable write_col_to_output_buf : line;
    variable read_col_from_input_buf : line;
--    variable test_vector : ENCODER_ARRAY:=ITEM_TO_ENCODER;
begin

  file_open(output_buf, "/home/klara/magisterka/magisterka.srcs/sim_1/new/output_encoder.txt", write_mode);

    wait until rising_edge(clk);
    write(write_col_to_output_buf, CHOSEN_OUTPUT);
    writeline(output_buf, write_col_to_output_buf);
    file_close(output_buf);
    wait;
end process;

end;