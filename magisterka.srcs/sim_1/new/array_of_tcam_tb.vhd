library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
library xil_defaultlib;
use xil_defaultlib.types.all;
use xil_defaultlib.data_to_tcam.all;
use STD.textio.all;
use ieee.std_logic_textio.all;


entity array_of_tcam_tb is
end;

architecture bench of array_of_tcam_tb is

    constant T : time := 20 ns;
    constant num_of_clocks : integer := 0; 
    signal i : integer := 0; -- loop variable
    file output_buf : text; -- text is keyword
    file input_buf : text;

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
variable test_vector : std_logic_vector(DATA_SIZE-1 downto 0);
variable prev_test_vector : std_logic_vector(DATA_SIZE-1 downto 0);
constant data_s : natural := 32;
--variable save_data_in: ENCODER_ARRAY;
begin
  file_open(input_buf, "/home/klara/magisterka/magisterka.srcs/sim_1/new/input.txt", read_mode);
  file_open(output_buf, "/home/klara/magisterka/magisterka.srcs/sim_1/new/output.txt", write_mode);
   
    while not endfile(input_buf) loop
    
        readline(input_buf, read_col_from_input_buf);
        read(read_col_from_input_buf, test_vector);
        
        DATA_IN <= test_vector;
        wait until rising_edge(clk);
        write(write_col_to_output_buf, prev_test_vector);
        write(write_col_to_output_buf, string'(", ")); 
--        wait until rising_edge(clk);
        for j in DATA_OUT'range loop
            write(write_col_to_output_buf, DATA_OUT(j), right, data_s );
            write(write_col_to_output_buf, string'(" ")); 
        end loop;
        prev_test_vector := test_vector;
        
        writeline(output_buf, write_col_to_output_buf);
        --file_close(output_buf);
        
    end loop;
--  end if;
      file_close(input_buf);
      file_close(output_buf);
      wait;
  end process take_and_write;

end;