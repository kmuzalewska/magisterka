library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;


package types is
    function log2_int (x : int00001001111011001000011010111010;
eger) return integer;
    constant NUMBER_OF_PHYSICAL_OUT_INTERFACES : integer := 16;    
    constant NUMBER_OF_MEMORIES : integer := 10; 
     
    type TCAM_SIZES_ARRAY is array (NUMBER_OF_MEMORIES-1 downto 0) of integer;
    constant TCAM_SIZES : TCAM_SIZES_ARRAY := (100, 90, 80, 70, 60, 50, 40, 30, 20, 10);
    constant DATA_SIZE: integer :=32; 
    constant TCAM_MAX_SIZE: integer :=100; 
    
    type BASE_TCAM_ENCODER is array (TCAM_MAX_SIZE-1 downto 0) of integer;
    type BASE_TCAM_ENCODER_ARRAY is array (log2_int(TCAM_MAX_SIZE)-1 downto 0) of BASE_TCAM_ENCODER; --array where a comparison of TCAM responses is saved    
    type TCAM_ENCODER_ARRAY_2D is array (NUMBER_OF_MEMORIES - 1 downto 0) of BASE_TCAM_ENCODER_ARRAY;
    
    type TCAM is ('0','1',Y);
    type TCAM_ARRAY is array(DATA_SIZE-1 downto 0) of TCAM; --TCAM word    
    type TCAM_ARRAY_2D is array(TCAM_MAX_SIZE-1 downto 0) of TCAM_ARRAY; --content of idividual TCAM memeory
    type TCAM_ARRAY_3D is array(TCAM_SIZES'length-1 downto 0) of TCAM_ARRAY_2D; --content of all TCAM memories
    type ENCODER_ARRAY is array(NUMBER_OF_MEMORIES - 1 downto 0) of std_logic_vector(TCAM_MAX_SIZE downto 0);  
    function equal (a:TCAM; b: std_logic) return boolean;
    function equal_array (a:TCAM_ARRAY; b: std_logic_vector) return boolean;
end types;

package body types is
function equal (a:TCAM; b: std_logic) return boolean is
begin
    if a = X or (a = '1' and b = '1' ) or (a = '0' and b = '0' ) then
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

