----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2025 12:25:44
-- Design Name: 
-- Module Name: DrawLeds - Behavioral
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

entity DrawLeds is
  Port (
        rst: in std_logic;
        clk: in std_logic;
        leds: out std_logic_vector(15 downto 0));
end DrawLeds;

architecture Behavioral of DrawLeds is

signal leds_aux: std_logic_vector(15 downto 0);
begin

    
    process (rst, clk)
    begin
        if rst = '1' then
            leds_aux <= (others => '0');
        elsif rising_edge(clk) then
            if(leds_aux(0) = '1') then
                leds_aux <= "1111111100000000";
            else 
                leds_aux <= "0000000011111111";
            end if;
        end if;
    end process;
leds <= leds_aux;
end Behavioral;