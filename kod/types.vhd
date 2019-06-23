library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;


package types is
    function log2_int (x : integer) return integer;
    constant NUMBER_OF_PHYSICAL_OUT_INTERFACES : integer := 16; --(0 considered as negative answer zn d16 is virtual- do not exists)    
    constant NUMBER_OF_MEMORIES : integer := 10; 
    type file_names_type is array(NUMBER_OF_MEMORIES-1 downto 0) of String(24 downto 1);--tu te kolejnosc pamieci zmienilam
    constant file_name : file_names_type := ("mem_seq_readout_gen9.mem", "mem_seq_readout_gen8.mem", "mem_seq_readout_gen7.mem", "mem_seq_readout_gen6.mem", "mem_seq_readout_gen5.mem", "mem_seq_readout_gen4.mem","mem_seq_readout_gen3.mem","mem_seq_readout_gen2.mem","mem_seq_readout_gen1.mem","mem_seq_readout_gen0.mem" );--dy deklaruje sie rray to idzie od 9 do 0
--    constant file_name : file_names_type := ( "mem_seq_readout_gen5.mem","mem_seq_readout_gen6.mem","mem_seq_readout_gen7.mem","mem_seq_readout_gen8.mem","mem_seq_readout_gen9.mem" );

    type TCAM_SIZES_ARRAY is array (NUMBER_OF_MEMORIES-1 downto 0) of integer;
    constant TCAM_SIZES : TCAM_SIZES_ARRAY := (10, 10, 10, 10, 10,10, 10, 10, 10, 10);

    constant DATA_SIZE: integer :=32; 
    constant TCAM_MAX_SIZE: integer :=10; 
    
    type choosen_switch_output_array is array (NUMBER_OF_MEMORIES-1 downto 0) of std_logic_vector(log2_int(NUMBER_OF_PHYSICAL_OUT_INTERFACES)-1 downto 0);
    type choosen_switch_output_array_2D is array (log2_int(NUMBER_OF_MEMORIES) downto 0) of choosen_switch_output_array;  
    
    type BASE_TCAM_ENCODER is array (TCAM_MAX_SIZE/2 downto 0) of std_logic_vector(log2_int(TCAM_MAX_SIZE+1)-1 downto 0);--(9 downto 0);--(13 downto 
    type BASE_TCAM_ENCODER_ARRAY is array (log2_int(TCAM_MAX_SIZE) downto 0) of BASE_TCAM_ENCODER; --array where a comparison of TCAM responses is saved    
    type TCAM_ENCODER_ARRAY_2D is array (NUMBER_OF_MEMORIES - 1 downto 0) of BASE_TCAM_ENCODER_ARRAY;
    
    subtype TCAM is std_logic_vector(1 downto 0); --"00"- is 0, "01" is 1, "11" is don't care
    type TCAM_ARRAY is array(DATA_SIZE-1 downto 0) of TCAM; --TCAM word    
    type TCAM_ARRAY_2D is array(TCAM_MAX_SIZE-1 downto 0) of TCAM_ARRAY; --content of idividual TCAM memeory
    type TCAM_ARRAY_3D is array(NUMBER_OF_MEMORIES-1 downto 0) of TCAM_ARRAY_2D; --content of all TCAM memories
    type ENCODER_ARRAY is array(NUMBER_OF_MEMORIES-1 downto 0) of std_logic_vector(TCAM_MAX_SIZE-1 downto 0);  
    function equal (a:TCAM; b: std_logic) return boolean;
    function equal_array (a:TCAM_ARRAY; b: std_logic_vector) return boolean;
    function power (a:integer; p:integer) return integer;
    function division(array_size:integer; m:integer) return integer ;
end types;

package body types is
function equal (a:TCAM; b: std_logic) return boolean is
begin
    if a = "11" or (a = "01" and b = '1' ) or (a = "00" and b = '0' ) then
        return true;
    else 
        return false;
    end if;
end function equal;   

function log2_int (x : integer) return integer is
    variable temp : integer := 1;
    variable n    : integer := 0;
begin    
    while temp < x loop
      temp := temp * 2;
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

function power (a:integer; p:integer) return integer is
    variable temp : integer := 1;
    variable n    : integer := 0;
begin
    while n < p loop
        temp := temp * a;
        n   :=  n + 1;
    end loop;
    return temp;   
end function power;

function division(array_size:integer; m:integer) return integer is
    variable power_result : integer := 0;
    variable temp    : integer := 0;
    variable n:   integer:=0;
begin
    power_result := power(2, m+1);
    while temp < (array_size-1) loop
        temp := temp + power_result;
         n   :=  n + 1;
    end loop;    
    return n;
end function division;
end types;
