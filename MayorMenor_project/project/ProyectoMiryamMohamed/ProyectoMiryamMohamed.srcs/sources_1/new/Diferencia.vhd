----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2025 21:52:34
-- Design Name: 
-- Module Name: Diferencia - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Diferencia is
  Port (
    clk: in std_logic;
    rst: in std_logic;
    calc_enable: in std_logic;
    num1: in std_logic_vector(3 downto 0);
    num2: in std_logic_vector(3 downto 0);
    result: out std_logic_vector(3 downto 0)
  );
end Diferencia;

architecture Behavioral of Diferencia is
  
  
  signal diff_unsigned: unsigned(3 downto 0);
  signal diff_aux: std_logic_vector(3 downto 0); 
begin
  process(clk, rst)
  begin
    if rst = '1' then
      result <= (others => '0');
    elsif rising_edge(clk) then
      if calc_enable = '1' then
        

        
        if unsigned(num1) >= unsigned(num2) then
          diff_unsigned <= unsigned(num1) - unsigned(num2);
        else
          diff_unsigned <= unsigned(num2) - unsigned(num1);
        end if;

        diff_aux <= std_logic_vector(diff_unsigned); -- convertir el resultado de vuelta a std_logic_vector.
        result <= diff_aux;
      end if;
    end if;
  end process;
  
end Behavioral;