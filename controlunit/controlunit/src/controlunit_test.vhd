library IEEE;	 

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controlunit_test is
end controlunit_test;

architecture Behavioral of controlunit_test is 

	signal clk_in : STD_LOGIC := '0';
    signal reset_in : STD_LOGIC := '0';
	signal alu_op_in : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
	signal stage_out : STD_LOGIC_VECTOR (5 downto 0) := (others => '0');

	component controlunit
    Port ( clk_in : in STD_LOGIC;
           reset_in : in STD_LOGIC;
           alu_op_in : in STD_LOGIC_VECTOR (4 downto 0);
           stage_out : out STD_LOGIC_VECTOR (5 downto 0));
	end component;
	constant period : time := 10 ns;
begin
	
	uut : controlunit PORT MAP (
	clk_in => clk_in,
	reset_in => reset_in,
	alu_op_in => alu_op_in,
	stage_out => stage_out
	); 
	
	clk_process: process
	begin
		clk_in <= '0';
		wait for period/2;
		clk_in <= '1';
		wait for period/2;
	end process;
	
	stimulus_process : process
	begin
		
		-- RESET
		reset_in <= '1';
		wait for period;
		assert stage_out = "000001"
		report "Test case 1 failed."
		Severity note;
		assert stage_out /= "000001"
		report "Test case 1 passed."
		Severity note;		 				
		
		-- WAIT
		reset_in <= '0';
		wait for period;
		assert stage_out = "000010"
		report "Test case 2 failed."
		Severity note;
		assert stage_out /= "000010"
		report "Test case 2 passed."
		Severity note;	
		
		-- skipping memory stage
		alu_op_in <= "01001";
		wait for period;
		wait for period;
		wait for period;
		assert stage_out = "100000"
		report "Test case 3 failed."
		Severity note;
		assert stage_out /= "100000"
		report "Test case 3 passed."
		Severity note;	
		
		-- going to memory stage
		reset_in <= '1';
		alu_op_in <= "01101";
		wait for period;
		reset_in <= '0';		
		wait for period;
		wait for period;
		wait for period;
		wait for period;		
		assert stage_out = "010000"
		report "Test case 4 failed."
		Severity note;
		assert stage_out /= "010000"
		report "Test case 4 passed."
		Severity note;	
		
		-- WAIT
		wait for period;
		assert stage_out = "100000"
		report "Test case 5 failed."
		Severity note;
		assert stage_out /= "100000"
		report "Test case 5 passed."
		Severity note;			
		
	wait;
	end process;
end Behavioral;