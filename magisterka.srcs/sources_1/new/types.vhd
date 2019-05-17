library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;


package types is
    function log2_int (x : integer) return integer;
    constant NUMBER_OF_PHYSICAL_OUT_INTERFACES : integer := 16; --(0 considered as negative answer zn d16 is virtual- do not exists)    
    constant NUMBER_OF_MEMORIES : integer := 10; 
    type file_names_type is array(NUMBER_OF_MEMORIES-1 downto 0) of String(24 downto 1);
    constant file_name : file_names_type := ("mem_seq_readout_gen0.mem", "mem_seq_readout_gen1.mem", "mem_seq_readout_gen2.mem", "mem_seq_readout_gen3.mem", "mem_seq_readout_gen4.mem", "mem_seq_readout_gen5.mem","mem_seq_readout_gen6.mem","mem_seq_readout_gen7.mem","mem_seq_readout_gen8.mem","mem_seq_readout_gen9.mem" );
--    constant file_name : file_names_type := ( "mem_seq_readout_gen5.mem","mem_seq_readout_gen6.mem","mem_seq_readout_gen7.mem","mem_seq_readout_gen8.mem","mem_seq_readout_gen9.mem" );

    type TCAM_SIZES_ARRAY is array (NUMBER_OF_MEMORIES-1 downto 0) of integer;
--    constant TCAM_SIZES : TCAM_SIZES_ARRAY := (10, 20, 30, 40, 50, 60, 70, 80, 90, 100);
    constant TCAM_SIZES : TCAM_SIZES_ARRAY := (10, 10, 10, 100, 100, 100, 1000, 1000, 1000, 10000);
--    constant TCAM_SIZES : TCAM_SIZES_ARRAY := ( 60, 70, 80, 90, 100);
--    constant TCAM_ADDR_SIZES : TCAM_SIZES_ARRAY := (log2_int(10)+1, log2_int(20)+1, log2_int(30)+1, log2_int(40)+1, log2_int(50)+1, log2_int(60)+1, log2_int(70)+1, log2_int(80)+1, log2_int(90)+1, log2_int(100)+1);
--    constant TCAM_ADDR_SIZES : TCAM_SIZES_ARRAY := ( log2_int(60)+1, log2_int(70)+1, log2_int(80)+1, log2_int(90)+1, log2_int(100)+1);
    constant TCAM_ADDR_SIZES : TCAM_SIZES_ARRAY := (log2_int(10)+1, log2_int(10)+1, log2_int(10)+1, log2_int(100)+1, log2_int(100)+1, log2_int(100)+1, log2_int(1000)+1, log2_int(1000)+1, log2_int(1000)+1, log2_int(10000)+1);

    constant DATA_SIZE: integer :=32; 
    constant TCAM_MAX_SIZE: integer :=10000; 
    
    type BASE_TCAM_ENCODER is array (TCAM_MAX_SIZE-1 downto 0) of std_logic_vector(9 downto 0);
    type BASE_TCAM_ENCODER_ARRAY is array (log2_int(TCAM_MAX_SIZE)-1 downto 0) of BASE_TCAM_ENCODER; --array where a comparison of TCAM responses is saved    
    type TCAM_ENCODER_ARRAY_2D is array (NUMBER_OF_MEMORIES - 1 downto 0) of BASE_TCAM_ENCODER_ARRAY;
    
    type TCAM is ('0','1','Y');
    type TCAM_ARRAY is array(DATA_SIZE-1 downto 0) of TCAM; --TCAM word    
    type TCAM_ARRAY_2D is array(TCAM_MAX_SIZE-1 downto 0) of TCAM_ARRAY; --content of idividual TCAM memeory
    type TCAM_ARRAY_3D is array(TCAM_SIZES'length-1 downto 0) of TCAM_ARRAY_2D; --content of all TCAM memories
    type ENCODER_ARRAY is array(NUMBER_OF_MEMORIES - 1 downto 0) of std_logic_vector(TCAM_MAX_SIZE-1 downto 0);  
    function equal (a:TCAM; b: std_logic) return boolean;
    function equal_array (a:TCAM_ARRAY; b: std_logic_vector) return boolean;
end types;

package body types is
function equal (a:TCAM; b: std_logic) return boolean is
begin
    if a = 'Y' or (a = '1' and b = '1' ) or (a = '0' and b = '0' ) then
        return true;
    else 
        return false;
    end if;
end function equal;   

function log2_int (x : integer) return integer is
    variable temp : integer := 0;
    variable n    : integer := 0;
  begin
    temp := x;
    while temp > 1 loop
      temp := temp / 2;
      n    := n + 1;
    end loop;
    return n;
end function log2_int;

function equal_array (a:TCAM_ARRAY; b: std_logic_vector) return boolean is
begin
    for i in a'low to a'high loop
        if equal(a(i), b(i)) then
            next;
        else 
            return false;
        end if;
    end loop;
    return true;
end function equal_array;

end types;
