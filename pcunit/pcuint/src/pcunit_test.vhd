library IEEE;	 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pcunit_test is
end pcunit_test;

architecture Behavioral of pcunit_test is 

	signal clk_in : STD_LOGIC := '0';
	signal pc_op_in : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
	signal pc_in : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	signal pc_out : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

	component pcunit
    Port ( clk_in : in STD_LOGIC;
           pc_op_in : in STD_LOGIC_VECTOR (1 downto 0);
           pc_in : in STD_LOGIC_VECTOR (15 downto 0);
           pc_out : out STD_LOGIC_VECTOR (15 downto 0));  
	end component;
	
	constant period : time := 10 ns;
	
begin
	
	uut : pcunit PORT MAP (
	clk_in => clk_in,
	pc_op_in => pc_op_in,
	pc_in => pc_in,
	pc_out => pc_out
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
		
		--reset
		pc_op_in <= "00";
		wait for period;
		assert pc_out = x"0000"
		report "Test case 1 failed."
		Severity error;
		assert pc_out /= x"0000"
		report "Test case 1 passed."
		Severity note;
		
		--increment
		pc_op_in <= "01";
		wait for period;
		assert pc_out = x"0001"
		report "Test case 2 failed."
		Severity error;	
		assert pc_out /= x"0001"
		report "Test case 2 passed."
		Severity note;
		
		--increment
		wait for period;
		assert pc_out = x"0002"
		report "Test case 3 failed."
		Severity error;	
		assert pc_out /= x"0002"
		report "Test case 3 passed."
		Severity note;	
		
		--NOP
		pc_op_in <= "11";
		wait for period;
		assert pc_out = x"0002"
		report "Test case 4 failed."
		Severity error;	
		assert pc_out /= x"0002"
		report "Test case 4 passed."
		Severity note;
		
		--branch
		pc_in <= x"FFF8";
		pc_op_in <= "10";
		wait for period;
		assert pc_out = x"FFF8"
		report "Test case 5 failed."
		Severity error;	
		assert pc_out /= x"FFF8"
		report "Test case 5 passed."
		Severity note; 
		
		--increment
		pc_op_in <= "01";
		wait for period;
		assert pc_out = x"FFF9"
		report "Test case 6 failed."
		Severity error;	
		assert pc_out /= x"FFF9"
		report "Test case 6 passed."
		Severity note; 
		
		--reset
		pc_op_in <= "00";
		wait for period;
		assert pc_out = x"0000"
		report "Test case 7 failed."
		Severity error;
		assert pc_out /= x"0000"
		report "Test case 7 passed."
		Severity note;		
		
	wait;
	end process;
end Behavioral;