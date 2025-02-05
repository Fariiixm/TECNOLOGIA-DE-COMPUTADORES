----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.01.2025 13:59:35
-- Design Name: 
-- Module Name: ContMod10 - Behavioral
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

entity ContMod10 is
  Port ( 
        rst: in std_logic;
        clk: in std_logic;
        enable: in std_logic;
        salida: out std_logic_vector(3 downto 0));
end ContMod10;

architecture Behavioral of ContMod10 is
signal num_aux: std_logic_vector(3 downto 0);
begin
 process (rst, clk, enable)
    begin
        if rst = '1' then
            num_aux <= "0000";
        elsif rising_edge(clk) then
            if enable = '1' then
                if num_aux = "1001" then --hasta 9
                    num_aux <= "0000";
                else
                    num_aux <= num_aux + '1';
                end if;
            end if;
        end if;
    end process;
salida <= num_aux;

end Behavioral;
