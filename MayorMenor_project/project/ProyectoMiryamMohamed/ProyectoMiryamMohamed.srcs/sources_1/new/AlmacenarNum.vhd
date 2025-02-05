----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.01.2025 14:15:00
-- Design Name: 
-- Module Name: AlmacenarNum - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AlmacenarNum is
  Port ( 
        rst: in std_logic;
        clk: in std_logic;
        save: in std_logic;
        num: in std_logic_vector(3 downto 0);
        numero_guardado: out std_logic_vector(3 downto 0));
end AlmacenarNum;

architecture Behavioral of AlmacenarNum is

begin

process (rst, clk)
    begin
        if rst = '1' then
            numero_guardado <= (others => '0');
        elsif rising_edge(clk) then
            if save = '1' then
                numero_guardado <= num;
            end if;
        end if;
    end process;

end Behavioral;
