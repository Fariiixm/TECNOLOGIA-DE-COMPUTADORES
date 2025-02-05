----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.01.2025 13:56:18
-- Design Name: 
-- Module Name: Contador_descendente - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Contador_descendente is
  Port ( 
        rst : in std_logic;
		clk : in std_logic;
		enable : in std_logic;
		salida : out std_logic_vector(3 downto 0));
end Contador_descendente;

architecture Behavioral of Contador_descendente is
signal num_aux: std_logic_vector(3 downto 0);

begin

process (rst, clk, enable, num_aux) --un temporizador
	begin
		if rst = '1' then
			num_aux <= "1010"; 
		else
			if rising_edge(clk) then
				if enable = '1' then
					if num_aux = "0000" then 
						num_aux <= "1010"; --10 segs
						
					else
						num_aux <= num_aux - 1; --cont--
					end if;
				end if;
			end if;
		end if;
		salida <= num_aux;
	end process;

end Behavioral;
