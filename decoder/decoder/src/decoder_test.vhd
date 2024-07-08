library IEEE;	 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decoder_test is
end decoder_test;

architecture Behavioral of decoder_test is 

	signal clk_in : STD_LOGIC := '0';	
    signal enable_in : STD_LOGIC := '0';
    signal instruction_in : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal alu_op_out : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal imm_data_out : STD_LOGIC_VECTOR (7 downto 0) := (others => '0'); -- 16 or 8
    signal write_enable_out : STD_LOGIC := '0';
    signal sel_rM_out : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    signal sel_rN_out : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    signal sel_rD_out : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');

	component decoder
    Port (  clk_in : in STD_LOGIC;
            enable_in : in STD_LOGIC;
            instruction_in : in STD_LOGIC_VECTOR (15 downto 0);
            alu_op_out : out STD_LOGIC_VECTOR (4 downto 0);
            imm_data_out : out STD_LOGIC_VECTOR (7 downto 0); -- 16 or 8
            write_enable_out : out STD_LOGIC;
            sel_rM_out : out STD_LOGIC_VECTOR (2 downto 0);
            sel_rN_out : out STD_LOGIC_VECTOR (2 downto 0);
            sel_rD_out : out STD_LOGIC_VECTOR (2 downto 0)); 
	end component;
	
	constant period : time := 10 ns;
	
begin
	
	uut : decoder PORT MAP (
	clk_in => clk_in,
	enable_in => enable_in,
	instruction_in => instruction_in,
	alu_op_out => alu_op_out,
	imm_data_out => imm_data_out,
	write_enable_out => write_enable_out,
	sel_rM_out => sel_rM_out,
	sel_rN_out => sel_rN_out,
	sel_rD_out => sel_rD_out
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
		
		-- ADD , RRR
		enable_in <= '1';
		instruction_in <= '1' & "0000" & "001" & "010" & "100" & "00";
		wait for period;
		assert (alu_op_out = "10000" and sel_rD_out = "001" and sel_rM_out = "010" and sel_rN_out = "100" and write_enable_out = '1')
		report "Test case 1 failed."
		Severity note;
		assert (alu_op_out /= "10000" or sel_rD_out /= "001" or sel_rM_out /= "010" or sel_rN_out /= "100" or write_enable_out /= '1')
		report "Test case 1 passed."
		Severity note;		
		
		-- SUB , RRR
		instruction_in <= '1' & "0001" & "001" & "010" & "100" & "00";
		wait for period;
		assert (alu_op_out = "10001" and sel_rD_out = "001" and sel_rM_out = "010" and sel_rN_out = "100" and write_enable_out = '1')
		report "Test case 2 failed."
		Severity note;
		assert (alu_op_out /= "10001" or sel_rD_out /= "001" or sel_rM_out /= "010" or sel_rN_out /= "100" or write_enable_out /= '1')
		report "Test case 2 passed."
		Severity note;
		
		-- NOT , RRU
		instruction_in <= '1' & "0010" & "111" & "110" & "00000";
		wait for period;
		assert (alu_op_out = "10010" and sel_rD_out = "111" and sel_rM_out = "110" and write_enable_out = '1')
		report "Test case 3 failed."
		Severity note;
		assert (alu_op_out /= "10010" or sel_rD_out /= "111" or sel_rM_out /= "110" or write_enable_out /= '1')
		report "Test case 3 passed."
		Severity note;
		
		-- AND , RRR
		instruction_in <= '1' & "0011" & "001" & "010" & "100" & "00";
		wait for period;
		assert (alu_op_out = "10011" and sel_rD_out = "001" and sel_rM_out = "010" and sel_rN_out = "100" and write_enable_out = '1')
		report "Test case 4 failed."
		Severity note;
		assert (alu_op_out /= "10011" or sel_rD_out /= "001" or sel_rM_out /= "010" or sel_rN_out /= "100" or write_enable_out /= '1')
		report "Test case 4 passed."
		Severity note;		
		
		-- OR , RRR
		instruction_in <= '1' & "0100" & "001" & "010" & "100" & "00";
		wait for period;
		assert (alu_op_out = "10100" and sel_rD_out = "001" and sel_rM_out = "010" and sel_rN_out = "100" and write_enable_out = '1')
		report "Test case 5 failed."
		Severity note;
		assert (alu_op_out /= "10100" or sel_rD_out /= "001" or sel_rM_out /= "010" or sel_rN_out /= "100" or write_enable_out /= '1')
		report "Test case 5 passed."
		Severity note;		
		
		-- XOR , RRR
		instruction_in <= '1' & "0101" & "001" & "010" & "100" & "00";
		wait for period;
		assert (alu_op_out = "10101" and sel_rD_out = "001" and sel_rM_out = "010" and sel_rN_out = "100" and write_enable_out = '1')
		report "Test case 6 failed."
		Severity note;
		assert (alu_op_out /= "10101" or sel_rD_out /= "001" or sel_rM_out /= "010" or sel_rN_out /= "100" or write_enable_out /= '1')
		report "Test case 6 passed."
		Severity note;
		
		-- LSL , RRI(5)
		instruction_in <= '1' & "0110" & "001" & "010" & "10000";
		wait for period;
		assert (alu_op_out = "10110" and sel_rD_out = "001" and sel_rM_out = "010" and imm_data_out = "00010000" and write_enable_out = '1')
		report "Test case 7 failed."
		Severity note;
		assert (alu_op_out /= "10110" or sel_rD_out /= "001" or sel_rM_out /= "010" or imm_data_out /= "00010000" or write_enable_out /= '1')
		report "Test case 7 passed."
		Severity note;		
		
		-- LSR , RRI(5)
		instruction_in <= '1' & "0111" & "001" & "010" & "10000";
		wait for period;
		assert (alu_op_out = "10111" and sel_rD_out = "001" and sel_rM_out = "010" and imm_data_out = "00010000" and write_enable_out = '1')
		report "Test case 8 failed."
		Severity note;
		assert (alu_op_out /= "10111" or sel_rD_out /= "001" or sel_rM_out /= "010" or imm_data_out /= "00010000" or write_enable_out /= '1')
		report "Test case 8 passed."
		Severity note;			
		
		-- CMP , RRR
		instruction_in <= '1' & "1000" & "001" & "010" & "100" & "00";
		wait for period;
		assert (alu_op_out = "11000" and sel_rD_out = "001" and sel_rM_out = "010" and sel_rN_out = "100" and write_enable_out = '1')
		report "Test case 9 failed."
		Severity note;
		assert (alu_op_out /= "11000" or sel_rD_out /= "001" or sel_rM_out /= "010" or sel_rN_out /= "100" or write_enable_out /= '1')
		report "Test case 9 passed."
		Severity note;		
		
		-- B , UI(8)
		instruction_in <= '1' & "1001" & "001" & "01010100";
		wait for period;
		assert (alu_op_out = "11001" and imm_data_out = "01010100" and write_enable_out = '0')
		report "Test case 10 failed."
		Severity note;
		assert (alu_op_out /= "11001" or imm_data_out /= "01010100" or write_enable_out /= '0')
		report "Test case 10 passed."
		Severity note;			
		
		-- BEQ , URR
		instruction_in <= '1' & "1010" & "001" & "010" & "100" & "00";
		wait for period;
		assert (alu_op_out = "11010" and sel_rM_out = "010" and sel_rN_out = "100" and write_enable_out = '0')
		report "Test case 11 failed."
		Severity note;
		assert (alu_op_out /= "11010" or sel_rM_out /= "010" or sel_rN_out /= "100" or write_enable_out /= '0')
		report "Test case 11 passed."
		Severity note;			
		
		-- IMMEDIATE , RI(8)
		instruction_in <= '1' & "1011" & "001" & "01010100";
		wait for period;
		assert (alu_op_out = "11011" and sel_rD_out = "001" and imm_data_out = "01010100" and write_enable_out = '1')
		report "Test case 12 failed."
		Severity note;
		assert (alu_op_out /= "11011" or sel_rD_out /= "001" or imm_data_out /= "01010100" or write_enable_out /= '1')
		report "Test case 12 passed."
		Severity note;			
		
		-- LD , RRU
		instruction_in <= '1' & "1000" & "111" & "110" & "00000";
		wait for period;
		assert (alu_op_out = "11000" and sel_rD_out = "111" and sel_rM_out = "110" and write_enable_out = '1')
		report "Test case 13 failed."
		Severity note;
		assert (alu_op_out /= "11000" or sel_rD_out /= "111" or sel_rM_out /= "110" or write_enable_out /= '1')
		report "Test case 13 passed."
		Severity note;		
		
		-- BEQ , URR
		instruction_in <= '1' & "1101" & "001" & "010" & "100" & "00";
		wait for period;
		assert (alu_op_out = "11101" and sel_rM_out = "010" and sel_rN_out = "100" and write_enable_out = '0')
		report "Test case 14 failed."
		Severity note;
		assert (alu_op_out /= "11101" or sel_rM_out /= "010" or sel_rN_out /= "100" or write_enable_out /= '0')
		report "Test case 14 passed."
		Severity note;			
		
	wait;
	end process;
end Behavioral;