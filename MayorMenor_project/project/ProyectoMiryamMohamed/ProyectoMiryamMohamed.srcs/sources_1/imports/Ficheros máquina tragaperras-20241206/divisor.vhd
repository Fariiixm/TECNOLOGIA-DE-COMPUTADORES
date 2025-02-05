----------------------------------------------------------------------------------
-- Company: Universidad Complutense de Madrid
-- Engineer: Hortensia Mecha
-- 
-- Design Name: divisor 
-- Module Name:    divisor - divisor_arch 
-- Project Name: 
-- Target Devices: 
-- Description: Creación de un reloj de 1Hz a partir de
--		un clk de 100 MHz
--
----------------------------------------------------------------------------------
--library IEEE;
--use IEEE.std_logic_1164.all;
--USE IEEE.std_logic_unsigned.ALL;

--entity divisor is
--    port (
--        rst: in STD_LOGIC;
--        clk_entrada: in STD_LOGIC; -- reloj de entrada de la entity superior
--        clk_salida: out STD_LOGIC -- reloj que se utiliza en los process del programa principal
--    );
--end divisor;

--architecture divisor_arch of divisor is
-- SIGNAL cuenta: std_logic_vector(27 downto 0);
-- SIGNAL clk_aux: std_logic;
  
--  begin

 
--clk_salida<=clk_aux;
--  contador:
--  PROCESS(rst, clk_entrada)
--  BEGIN
--    IF (rst='1') THEN
--      cuenta<= (OTHERS=>'0');
--      clk_aux<='0';
--    ELSIF(rising_edge(clk_entrada)) THEN
--      IF (cuenta="0101111101011110000100000000") THEN 
--      	clk_aux <= '1';
--        cuenta<= (OTHERS=>'0');
--      ELSE
--        cuenta <= cuenta+'1';
--	   clk_aux<='0';
--      END IF;
--    END IF;
--  END PROCESS contador;

--end divisor_arch;
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity divisor is
	Port (
		rst : in std_logic;
		clk_entrada : in std_logic;
		clk_salida : out std_logic_vector(3 downto 0)
	);
end divisor;

architecture divisor_arch of divisor is
	signal cuenta_2Hz : std_logic_vector(27 downto 0);
	signal cuenta_display1 : std_logic_vector(27 downto 0);
	signal cuenta_4Hz : std_logic_vector(27 downto 0);
	signal cuenta_1Hz:  std_logic_vector(27 downto 0);
	signal clk_aux : std_logic_vector(3 downto 0);

begin
	
	process (rst, clk_entrada)
	begin
		if rst = '1' then
			cuenta_2Hz <= (others => '0');
			cuenta_display1 <= (others => '0');
			cuenta_4Hz <= (others => '0');
			cuenta_1Hz <= (others => '0');
			clk_aux <= "0000";
		elsif rising_edge(clk_entrada) then
			if cuenta_2Hz = "0010111110101111000010000000" then 
				clk_aux(0) <= '1';
				cuenta_2Hz <= (others => '0');
			else
				cuenta_2Hz <= cuenta_2Hz + '1';
				clk_aux(0) <= '0';
			end if;
			if cuenta_display1 = "0000000000001000010000000000" then
				clk_aux(1) <= '1';
				cuenta_display1 <= (others => '0');
			else
				cuenta_display1 <= cuenta_display1 + '1';
				clk_aux(1) <= '0';
			end if;
			if cuenta_4Hz = "1011111010111100001000000" then 
				clk_aux(2) <= '1';
				cuenta_4Hz <= (others => '0');
			else
				cuenta_4Hz <= cuenta_4Hz + '1';
				clk_aux(2) <= '0';
			end if;
			if cuenta_1Hz = "101111101011110000100000000" then 
				clk_aux(3) <= '1';
				cuenta_1Hz <= (others => '0');
			else
				cuenta_1Hz <= cuenta_1Hz + '1';
				clk_aux(3) <= '0';
			end if;
		end if;
	end process;
clk_salida <= clk_aux;
end divisor_arch;

