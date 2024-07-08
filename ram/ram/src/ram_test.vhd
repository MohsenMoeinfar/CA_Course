library IEEE;	 

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram_test is
end ram_test;

architecture Behavioral of ram_test is 

    signal clk_in : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal enable_in : STD_LOGIC :='0';
    signal write_enable_in : STD_LOGIC := '0';
    signal address_in : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal data_in : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal data_out : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

	component ram
    Port ( clk_in : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_in : in STD_LOGIC;
           write_enable_in : in STD_LOGIC;
           address_in : in STD_LOGIC_VECTOR (15 downto 0);
           data_in : in STD_LOGIC_VECTOR (15 downto 0);
           data_out : out STD_LOGIC_VECTOR (15 downto 0)); 
	end component;
	
	constant period : time := 10 ns;
	
begin
	
	uut : ram PORT MAP (
	clk_in => clk_in,
	reset => reset,
	enable_in => enable_in,
	write_enable_in => write_enable_in,
	address_in => address_in,
	data_in => data_in,
	data_out => data_out
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
		write_enable_in <= '1';
		enable_in <= '1';
		address_in <= x"A001";
		data_in <= x"0123";	
		wait for period;
		write_enable_in <='0';
		data_in <= x"0000";
		wait for period;
		assert data_out = x"0123"
		report "Test case 1 failed."
		Severity note;
		assert data_out /= x"0123"
		report "Test case 1 passed."
		Severity note;			
		
		-- WRITE and READ
		write_enable_in <= '1';
		address_in <= x"A000";
		data_in <= x"123A";	
		wait for period;
		write_enable_in <='0';
		data_in <= x"0000";
		wait for period;
		assert data_out = x"123A"
		report "Test case 2 failed."
		Severity note;
		assert data_out /= x"123A"
		report "Test case 2 passed."
		Severity note;			
		
		-- READ
		address_in <= x"A001";		
		write_enable_in <='0';
		wait for period;
		assert data_out = x"0123"
		report "Test case 3 failed."
		Severity note;
		assert data_out /= x"0123"
		report "Test case 3 passed."
		Severity note;			
		
	wait;
	end process;
end Behavioral;