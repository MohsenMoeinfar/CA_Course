library IEEE;	 

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity registerfile_test is
end registerfile_test;

architecture Behavioral of registerfile_test is 


	signal clk_in : STD_LOGIC := '0';
	signal enable_in : STD_LOGIC := '0';
	signal write_enable_in : STD_LOGIC := '0';
	signal rM_data_out : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	signal rN_data_out : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	signal rD_data_in : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	signal sel_rM_in : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
	signal sel_rN_in : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
	signal sel_rD_in : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');

	component registerfile
    Port ( clk_in : in STD_LOGIC;
           enable_in : in STD_LOGIC;
           write_enable_in : in STD_LOGIC;
           rM_data_out : out STD_LOGIC_VECTOR (15 downto 0);
           rN_data_out : out STD_LOGIC_VECTOR (15 downto 0);
           rD_data_in : in STD_LOGIC_VECTOR (15 downto 0);
           sel_rM_in : in STD_LOGIC_VECTOR (2 downto 0);
           sel_rN_in : in STD_LOGIC_VECTOR (2 downto 0);
           sel_rD_in : in STD_LOGIC_VECTOR (2 downto 0));
	end component;
	
	constant period : time := 10 ns;
	
begin
	
	uut : registerfile PORT MAP (
	clk_in => clk_in,
	enable_in => enable_in,
	write_enable_in => write_enable_in,
	rM_data_out => rM_data_out,
	rN_data_out => rN_data_out,
	rD_data_in => rD_data_in,
	sel_rM_in => sel_rM_in,
	sel_rN_in => sel_rN_in,
	sel_rD_in => sel_rD_in	
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
		
		-- WRITE and READ
		enable_in <= '1';
		rD_data_in <= x"FFFF";
		sel_rD_in <= "010";
		write_enable_in <= '1';
		wait for period;
		write_enable_in <= '0';
		sel_rM_in <= "010";
		wait for period;
		assert rM_data_out = x"FFFF"
		report "Test case 1 failed"
		Severity note;
		assert rM_data_out /= x"FFFF"
		report "Test case 1 passed"
		Severity note;
		
		-- WRITE and READ
		enable_in <= '1';
		rD_data_in <= x"010F";
		sel_rD_in <= "011";
		write_enable_in <= '1';
		wait for period;
		write_enable_in <= '0';
		sel_rN_in <= "011";	
		wait for period;
		assert rN_data_out = x"010F"
		report "Test case 2 failed"
		Severity note;
		assert rN_data_out /= x"010F"
		report "Test case 2 passed"
		Severity note;		
		
		-- UPDATE and READ
		enable_in <= '1';
		rD_data_in <= x"4321";
		sel_rD_in <= "010";
		write_enable_in <= '1';
		wait for period;
		write_enable_in <= '0';
		sel_rM_in <= "010";
		wait for period;
		assert rM_data_out = x"4321"
		report "Test case 3 failed"
		Severity note;
		assert rM_data_out /= x"4321"
		report "Test case 3 passed"
		Severity note;		
		
	wait;
	end process;
end Behavioral;