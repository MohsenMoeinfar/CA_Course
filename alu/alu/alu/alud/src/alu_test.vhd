library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_alu is
end tb_alu;

architecture Behavioral of tb_alu is
    signal clk_in : STD_LOGIC := '0';
    signal enable_in : STD_LOGIC := '0';
    signal alu_op_in : STD_LOGIC_VECTOR (4 downto 0);
    signal pc_in : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal rM_data_in : STD_LOGIC_VECTOR (15 downto 0);
    signal rN_data_in : STD_LOGIC_VECTOR (15 downto 0);
    signal imm_data_in : STD_LOGIC_VECTOR (7 downto 0);	  
	signal rD_write_enable_in : STD_LOGIC := '0';
    signal result_out : STD_LOGIC_VECTOR (15 downto 0);
    signal branch_out : STD_LOGIC;
    signal rD_write_enable_out : STD_LOGIC := '0';

    component alu is
        Port ( clk_in : in STD_LOGIC;
               enable_in : in STD_LOGIC;
               alu_op_in : in STD_LOGIC_VECTOR (4 downto 0);
               pc_in : in STD_LOGIC_VECTOR (15 downto 0);
               rM_data_in : in STD_LOGIC_VECTOR (15 downto 0);
               rN_data_in : in STD_LOGIC_VECTOR (15 downto 0);
               imm_data_in : in STD_LOGIC_VECTOR (7 downto 0);	
			   rD_write_enable_in : in STD_LOGIC;
               result_out : out STD_LOGIC_VECTOR (15 downto 0);
               branch_out : out STD_LOGIC;
               rD_write_enable_out : out STD_LOGIC);
    end component;

    -- Clock generation
    constant clk_period : time := 10 ns;

begin
    uut: alu
        Port map (
            clk_in => clk_in,
            enable_in => enable_in,
            alu_op_in => alu_op_in,
            pc_in => pc_in,
            rM_data_in => rM_data_in,
            rN_data_in => rN_data_in,
            imm_data_in => imm_data_in,	
			rD_write_enable_in => rD_write_enable_in,
            result_out => result_out,
            branch_out => branch_out,
            rD_write_enable_out => rD_write_enable_out
        );

    clk_process : process
    begin
        clk_in <= '0';
        wait for clk_period/2;
        clk_in <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin	 
		
        enable_in <= '1';
        rD_write_enable_in <= '1';
		

		-- Test case 1: ADD unsigned
        rM_data_in <= x"0005";
        rN_data_in <= x"0003";
        alu_op_in <= "00000"; -- ADD unsigned
        wait for clk_period;
        assert result_out = x"0008" and rD_write_enable_out = '1'
        report "Test case 1 failed." severity note;
        assert result_out /= x"0008" or rD_write_enable_out /= '1'
        report "Test case 1 passed." severity note;

        -- Test case 2: ADD signed with overflow
        rM_data_in <= x"7FFF";
        rN_data_in <= x"0001";
        alu_op_in <= "10000"; -- ADD signed
        wait for clk_period;
        assert rD_write_enable_out = '0'
        report "Test case 2 failed." severity note;
        assert rD_write_enable_out /= '0'
        report "Test case 2 passed." severity note;

        -- Test case 3: SUB unsigned
        rM_data_in <= x"000A";
        rN_data_in <= x"0003";
        alu_op_in <= "00001"; -- SUB unsigned
        wait for clk_period;
        assert result_out = x"0007" and rD_write_enable_out = '1'
        report "Test case 3 failed." severity note;
        assert result_out /= x"0007" or rD_write_enable_out /= '1'
        report "Test case 3 passed." severity note;

        -- Test case 4: SUB signed with overflow
        rM_data_in <= x"8000";
        rN_data_in <= x"0001";
        alu_op_in <= "10001"; -- SUB signed
        wait for clk_period;
        assert rD_write_enable_out = '0'
        report "Test case 4 failed." severity note;
        assert rD_write_enable_out /= '0'
        report "Test case 4 passed." severity note;

        -- Test case 5: NOT
        rN_data_in <= x"FFFF";
        alu_op_in <= "00010"; -- NOT
        wait for clk_period;
        assert result_out = x"0000"
        report "Test case 5 failed." severity note;
        assert result_out /= x"0000"
        report "Test case 5 passed." severity note;

        -- Test case 6: AND
        rM_data_in <= x"F0F0";
        rN_data_in <= x"0F0F";
        alu_op_in <= "00011"; -- AND
        wait for clk_period;
        assert result_out = x"0000"
        report "Test case 6 failed." severity note;
        assert result_out /= x"0000"
        report "Test case 6 passed." severity note;

        -- Test case 7: OR
        rM_data_in <= x"F0F0";
        rN_data_in <= x"0F0F";
        alu_op_in <= "00100"; -- OR
        wait for clk_period;
        assert result_out = x"FFFF"
        report "Test case 7 failed." severity note;
        assert result_out /= x"FFFF"
        report "Test case 7 passed." severity note;

        -- Test case 8: XOR
        rM_data_in <= x"F0F0";
        rN_data_in <= x"0F0F";
        alu_op_in <= "00101"; -- XOR
        wait for clk_period;
        assert result_out = x"FFFF"
        report "Test case 8 failed." severity note;
        assert result_out /= x"FFFF"
        report "Test case 8 passed." severity note;

        -- Test case 9: LSL
        rM_data_in <= x"0001";
        rN_data_in <= x"0004";
        alu_op_in <= "00110"; -- LSL
        wait for clk_period;
        assert result_out = x"0010"
        report "Test case 9 failed." severity note;
        assert result_out /= x"0010"
        report "Test case 9 passed." severity note;

        -- Test case 10: LSR
        rM_data_in <= x"0010";
        rN_data_in <= x"0004";
        alu_op_in <= "00111"; -- LSR
        wait for clk_period;
        assert result_out = x"0001"
        report "Test case 10 failed." severity note;
        assert result_out /= x"0001"
        report "Test case 10 passed." severity note;

        -- Test case 11: CMP unsigned
        rM_data_in <= x"0005";
        rN_data_in <= x"0005";
        alu_op_in <= "01000"; -- CMP unsigned
        wait for clk_period;
        assert result_out(14) = '1'
        report "Test case 11 failed." severity note;
        assert result_out(14) /= '1'
        report "Test case 11 passed." severity note;

        -- Test case 12: CMP signed
        rM_data_in <= x"8000";
        rN_data_in <= x"7FFF";
        alu_op_in <= "01000"; -- CMP signed
        wait for clk_period;
        assert result_out(15) = '0'
        report "Test case 12 failed." severity note;
        assert result_out(15) /= '0'
        report "Test case 12 passed." severity note;

        -- Test case 13: BEQ (branch if equal)
        rM_data_in <= x"0000";
        rN_data_in <= x"7000";
        alu_op_in <= "01010"; -- BEQ
        wait for clk_period;
        assert branch_out = '1'
        report "Test case 13 failed." severity note;
        assert branch_out /= '1'
        report "Test case 13 passed." severity note;

        -- Test case 14: B (branch)
        rM_data_in <= x"1234";
        imm_data_in <= x"56";
        alu_op_in <= "11001"; -- B with immediate
        wait for clk_period;
        assert result_out = x"1234" and branch_out = '1'
        report "Test case 14 failed." severity note;
        assert result_out /= x"1234" or branch_out /= '1'
        report "Test case 14 passed." severity note;

        -- Test case 15: 
        imm_data_in <= x"56";
        alu_op_in <= "01011"; 
        wait for clk_period;
        assert result_out = x"0056"
        report "Test case 15 failed." severity note;
        assert result_out /= x"0056"
        report "Test case 15 passed." severity note;

        -- Test case 16:
        imm_data_in <= x"56";
        alu_op_in <= "11011"; 
        wait for clk_period;
        assert result_out = x"5600"
        report "Test case 16 failed." severity note;
        assert result_out /= x"5600"
        report "Test case 16 passed." severity note;

        -- Test case 17: LD
        rM_data_in <= x"1234";
        alu_op_in <= "01100"; -- LD
        wait for clk_period;
        assert result_out = x"1234"
        report "Test case 17 failed." severity note;
        assert result_out /= x"1234"
        report "Test case 17 passed." severity note;

        -- Test case 18: ST
        rM_data_in <= x"5678";
        alu_op_in <= "01101"; -- ST
        wait for clk_period;
        assert result_out = x"5678"
        report "Test case 18 failed." severity note;
        assert result_out /= x"5678"
        report "Test case 18 passed." severity note;

        wait;
    end process;
end Behavioral;
