library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
library xil_defaultlib;
use xil_defaultlib.types.all;
use xil_defaultlib.data_to_tcam.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity array_of_tcam_tb is
end;

architecture bench of array_of_tcam_tb is

    constant T : time := 20 ns;
    constant num_of_clocks : integer := 4; 
    signal i : integer := 0; -- loop variable
    file output_buf : text; -- text is keyword
    type test_vectors_type is array (3 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);
    constant test_vectors : test_vectors_type:= (
        -- a, b, sum , carry   -- positional method is used below
        "00000000101000111010101000010000", -- or (a => '0', b => '0', sum => '0', carry => '0')
        "01111000000100011111010110010010",
        "11011010101110000010000001011011",
        "01101000111010101011000010100111"
        );

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
  
  stimulus: process
  begin
       wait for T;  
        -- store 30 samples in file
        if (i = num_of_clocks) then
            file_close(output_buf);
--            wait until clk'event and clk='1';
        else
            DATA_IN <= test_vectors(i);
            i <= i + 1;
        end if;
        end process;
--    CLK <= not CLK after 1ps;
--    DATA_IN <= "00110011001011111000100100011001";
--    MEM_CONTENT <= MEM_CONTENT;
    file_open(output_buf, "counter_data.csv", write_mode);
    
    process(clk)
        variable write_col_to_output_buf : line; -- line is keyword
    begin
        if(clk'event and clk='1') then  -- avoid reset data
            -- comment below 'if statement' to avoid header in saved file
            if (i = 0) then 
              write(write_col_to_output_buf, string'("data_in,data_out"));
              writeline(output_buf, write_col_to_output_buf);
            end if; 

            write(write_col_to_output_buf, DATA_IN);
            write(write_col_to_output_buf, string'(","));
            -- Note that unsigned/signed values can not be saved in file, 
            -- therefore change into integer or std_logic_vector etc.
             -- following line saves the count in integer format
             for j in DATA_OUT'range loop
                write(write_col_to_output_buf, DATA_OUT(j)); 
                writeline(output_buf, write_col_to_output_buf);
              end loop;
        end if;
    end process;


--    wait;
  


end;