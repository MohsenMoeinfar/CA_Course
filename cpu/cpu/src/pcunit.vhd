library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity pcunit is
    Port ( clk_in : in STD_LOGIC;
           pc_op_in : in STD_LOGIC_VECTOR (1 downto 0);
           pc_in : in STD_LOGIC_VECTOR (15 downto 0);
           pc_out : out STD_LOGIC_VECTOR (15 downto 0));
end pcunit;

architecture Behavioral of pcunit is
    signal pc: STD_LOGIC_VECTOR(15 downto 0) := x"0000";
begin
    process (clk_in)
    begin
        if rising_edge(clk_in) then
            case pc_op_in is
                when "00" => 
                    pc <= x"0000";
                when "01" => 
                    pc <= STD_LOGIC_VECTOR(unsigned(pc) + 1);
                when "10" => 
                    pc <= pc_in;
                when "11" => 
				
                when others =>
            end case;
        end if;
    end process;
    pc_out <= pc;

end Behavioral;
