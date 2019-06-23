library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library xil_defaultlib;
use xil_defaultlib.types.all;
library xpm;
use xpm.vcomponents.all;

entity encoder is
  Port ( 
    CLK: in std_logic;
    RESULTS_FROM_TCAMS: in ENCODER_ARRAY;--:=(others => (others => '0'));
    CHOSEN_OUTPUT: out integer:=0
  );
end encoder;

architecture Behavioral of encoder is
    signal inst_tcam_encoder_array_2d : TCAM_ENCODER_ARRAY_2D:=(others => (others => (others => (others=>'0'))));
--    signal choosen_switch_output : choosen_switch_output_array:=(others => (others => '0'));
--    type choosen_switch_output_3D is array (log2_int(TCAM_MAX_SIZE)+1 downto 0) of choosen_switch_output_array;    
--    signal inst_choosen_switch_output: choosen_switch_output_3D:=(others => (others => (others => '0')));
--    attribute dont_touch : string;
--    attribute dont_touch of  inst_tcam_encoder_array_2d : signal is "true";
    signal inst_choosen_switch_output_array_2d: choosen_switch_output_array_2D:=(others => (others => (others => '0')));

    
begin

FOR_MEMORIES: for i in 0 to NUMBER_OF_MEMORIES-1 generate -- ona has to adjust clock frequency
    FOR_DEPTH: for depth in 0 to log2_int(TCAM_SIZES(i)) generate  
        FOR_INDEXES: for pair in 0 to (TCAM_SIZES(i)/2-1) generate --499 generate
        --one should check if even numbersr of TCAM arrays is always required (even if it is dummy last number !)
            SEARCH_FOR_INDEX: process(all)
                begin
                if rising_edge(CLK) then                  
                    if depth = 0 then
                        if RESULTS_FROM_TCAMS(i)(pair*2) /= '0' then                      
                            inst_tcam_encoder_array_2d(i)(depth)(pair) <= std_logic_vector(to_unsigned(pair*2+1, (log2_int(TCAM_MAX_SIZE)+1) ));  
                        elsif RESULTS_FROM_TCAMS(i)(pair*2+1) /= '0' then                         
                            inst_tcam_encoder_array_2d(i)(depth)(pair) <= std_logic_vector(to_unsigned(pair*2+2, (log2_int(TCAM_MAX_SIZE)+1) ));                          
                        else    
                            inst_tcam_encoder_array_2d(i)(depth)(pair) <= (others =>'0');
                        end if;                     
                    else                                    
                        if inst_tcam_encoder_array_2d(i)(depth-1)(pair*2) /= (inst_tcam_encoder_array_2d(i)(depth-1)(pair)'range => '0') and depth > 0 then
                            inst_tcam_encoder_array_2d(i)(depth)(pair) <= inst_tcam_encoder_array_2d(i)(depth-1)(pair*2);                                     
                        else    
                            inst_tcam_encoder_array_2d(i)(depth)(pair) <= inst_tcam_encoder_array_2d(i)(depth-1)(pair*2+1);                           
                        end if;                                         
                    end if;                               
                end if;                                        
             end process SEARCH_FOR_INDEX;                            
        end generate FOR_INDEXES;
    end generate FOR_DEPTH;
end generate FOR_MEMORIES;
    
GEN_PMAP_MEMORIES: for i in 0 to NUMBER_OF_MEMORIES-1 generate  
  DECODER_OUT_MEM: xpm_memory_spram
   generic map (
      ADDR_WIDTH_A => log2_int(TCAM_SIZES(i))+1,             -- DECIMAL
      AUTO_SLEEP_TIME => 0,           -- DECIMAL
      BYTE_WRITE_WIDTH_A => log2_int(NUMBER_OF_PHYSICAL_OUT_INTERFACES),       -- DECIMAL
      ECC_MODE => "no_ecc",           -- String
      MEMORY_INIT_FILE => file_name(i),     -- String --sciezka do pliku z ktorego czta --tu tablica stringow
      MEMORY_INIT_PARAM => "0",       -- String
      MEMORY_OPTIMIZATION => "true",  -- String
      MEMORY_PRIMITIVE => "block",     -- String
      MEMORY_SIZE => TCAM_SIZES(i)*log2_int(NUMBER_OF_PHYSICAL_OUT_INTERFACES),        -- memory size in bits, TCAM_SIZES(i) of individaual memories multiplied by bits required to distinguish output interfaces   
      MESSAGE_CONTROL => 0,           -- DECIMAL
      READ_DATA_WIDTH_A => log2_int(NUMBER_OF_PHYSICAL_OUT_INTERFACES),        -- DECIMAL
      READ_LATENCY_A => 2,            -- DECIMAL
      READ_RESET_VALUE_A => "0",      -- String
      USE_MEM_INIT => 1,              -- DECIMAL
      WAKEUP_TIME => "disable_sleep", -- String
      WRITE_DATA_WIDTH_A => log2_int(NUMBER_OF_PHYSICAL_OUT_INTERFACES),       -- DECIMAL
      WRITE_MODE_A => "read_first"    -- String
   )
   port map (
      dbiterra => open,             -- 1-bit output: Status signal to indicate double bit error occurrence
                                        -- on the data output of port A.

      douta => inst_choosen_switch_output_array_2d(0)(i),                     -- READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
      sbiterra => open,             -- 1-bit output: Status signal to indicate single bit error occurrence
                                        -- on the data output of port A.

      --addra => std_logic_vector(to_unsigned(inst_tcam_encoder_array_2d(i)(log2_int(TCAM_SIZES(i))-1)(0), TCAM_ADDR_SIZES(i) )),                   -- ADDR_WIDTH_A-bit input: Address for port A write and read operations.
     -- addra => std_logic_vector(to_unsigned(0, 10)),                   -- ADDR_WIDTH_A-bit input: Address for port A write and read operations.
      addra => inst_tcam_encoder_array_2d(i)(log2_int(TCAM_SIZES(i)))(0)(log2_int(TCAM_SIZES(i)) downto 0),       
      clka => CLK,                     -- 1-bit input: Clock signal for port A.
      dina => x"0",                     -- WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      ena => '1',                       -- 1-bit input: Memory enable signal for port A. Must be high on clock
                                        -- cycles when read or write operations are initiated. Pipelined
                                        -- internally.

      injectdbiterra => '0', -- 1-bit input: Controls double bit error injection on input data when
                                        -- ECC enabled (Error injection capability is not available in
                                        -- "decode_only" mode).

      injectsbiterra => '0', -- 1-bit input: Controls single bit error injection on input data when
                                        -- ECC enabled (Error injection capability is not available in
                                        -- "decode_only" mode).

      regcea => '1',                 -- 1-bit input: Clock Enable for the last register stage on the output
                                        -- data path.

      rsta => '0',                     -- 1-bit input: Reset signal for the final port A output register
                                        -- stage. Synchronously resets output port douta to the value specified
                                        -- by parameter READ_RESET_VALUE_A.

      sleep => '0',                   -- 1-bit input: sleep signal to enable the dynamic power saving feature.
      wea => "0"                        -- WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input
                                        -- data port dina. 1 bit wide when word-wide writes are used. In
                                        -- byte-wide write configurations, each bit controls the writing one
                                        -- byte of dina to address addra. For example, to synchronously write
                                        -- only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be
                                        -- 4'b0010.

   );
end generate GEN_PMAP_MEMORIES;

--wydaje mi sie ze inaczej te fory powinny wygladac
--przede wszystkim tylko dwa lewele

FOR_DEPTH_SWITCH: for depth in 0 to log2_int(NUMBER_OF_MEMORIES)-1 generate  --0 to 3
   FOR_INDEXES_SWITCH: for pair in 0 to NUMBER_OF_MEMORIES/2-1 generate  --0 to 4
   --FOR_INDEXES: for pair in 0 to TCAM_SIZES(i)/2-1 generate
       --loop_process:process(CLK)    
       
       --begin
       ---    if rising_edge(CLK) then
       --FIRST_LEVEL: if depth = 0 generate
           process(all)
           begin                
               if inst_choosen_switch_output_array_2D(depth)(pair*2) /= ((inst_choosen_switch_output_array_2D(0)(pair*2)'range) => '0') then 
                  inst_choosen_switch_output_array_2D(depth+1)(pair) <= inst_choosen_switch_output_array_2D(depth)(pair*2); 
               --elsif choosen_switch_output(pair*2+1) /= ((choosen_switch_output(pair*2)'range) => '0') then 
               --    --wpisac tu do nowego array aktualny port
               --    inst_choosen_switch_output_array_2D(depth)(pair) <= choosen_switch_output(pair*2+1);                         
               else    
                   inst_choosen_switch_output_array_2D(depth+1)(pair) <= inst_choosen_switch_output_array_2D(depth)(pair*2+1); 
               end if;                
           end process;     
        --end generate  FIRST_LEVEL;    
        --NEXT_LEVELS: if depth > 0 generate
--            process(all)
--            begin                
--                if inst_choosen_switch_output_array_2D(depth-1)(pair*2) /= ((inst_choosen_switch_output_array_2D(depth-1)(pair)'range) => '0') then 
--                    inst_choosen_switch_output_array_2D(depth)(pair) <= inst_choosen_switch_output_array_2D(depth-1)(pair*2);             
--                else    
--                    inst_choosen_switch_output_array_2D(depth)(pair) <= inst_choosen_switch_output_array_2D(depth-1)(pair*2+1);   
--                end if;   
----                  assert 2<1 report "depth " & integer'image(depth) & " memory " & integer'image(i) & " " & integer'image(inst_choosen_switch_output_array_2D(depth)(pair)) severity error;
             
--            end process;     
        --end generate  NEXT_LEVELS;
   end generate FOR_INDEXES_SWITCH;
   
end generate FOR_DEPTH_SWITCH;


CHOSEN_OUTPUT <= to_integer(unsigned(inst_choosen_switch_output_array_2D(log2_int(NUMBER_OF_MEMORIES))(0)));

end Behavioral;