library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
library xil_defaultlib;
use xil_defaultlib.types.all;
use xil_defaultlib.data_to_tcam.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

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

  signal CLK: std_logic;
  signal DATA_IN: std_logic_vector(DATA_SIZE-1 downto 0);
  signal DATA_TO_TCAM: TCAM_ARRAY_3D:= DATA_TO_TCAM;
  signal CHOSEN_OUTPUT: integer ;
  constant T : time := 20 ns;
    constant num_of_clocks : integer := 0; 
    signal i : integer := 0; -- loop variable
    file output_buf : text; -- text is keyword
    file input_buf : text;

begin

  uut: main port map ( CLK           => CLK,
                       DATA_IN       => DATA_IN,
                       DATA_TO_TCAM  => DATA_TO_TCAM,
                       CHOSEN_OUTPUT => CHOSEN_OUTPUT );
clk_proc: process
  begin
        clk <= '0';
        wait for T/2;
        clk <= '1';
        wait for T/2;
 end process clk_proc;
 
  stimulus: process
  variable write_col_to_output_buf : line;
  variable read_col_from_input_buf : line;
  variable test_vector : std_logic_vector(DATA_SIZE-1 downto 0);
    variable prev_test_vector : std_logic_vector(DATA_SIZE-1 downto 0);
    constant data_s : natural := 32;
  begin
  
    
    file_open(input_buf, "/home/klara/magisterka/magisterka.srcs/sim_1/new/input.txt", read_mode);
  file_open(output_buf, "/home/klara/magisterka/magisterka.srcs/sim_1/new/main_output.txt", write_mode);
   
    while not endfile(input_buf) loop
    
        readline(input_buf, read_col_from_input_buf);
        read(read_col_from_input_buf, test_vector);
        
        DATA_IN <= test_vector;
        wait until rising_edge(clk);
        write(write_col_to_output_buf, prev_test_vector);
        write(write_col_to_output_buf, string'(", ")); 
         write(write_col_to_output_buf, CHOSEN_OUTPUT); 
--        wait until rising_edge(clk);
        
        prev_test_vector := test_vector;
        
        writeline(output_buf, write_col_to_output_buf);
        --file_close(output_buf);
        
    end loop;
--  end if;
      file_close(input_buf);
      file_close(output_buf);
      wait;

  end process;


end;
  

  