----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.01.2025 14:07:28
-- Design Name: 
-- Module Name: JugadorActual - Behavioral
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

entity JugadorActual is
  Port ( 
        rst: in std_logic;
        clk: in std_logic;
        jugador_1: in std_logic;
        placa: in std_logic;
        jugador: out std_logic_vector(3 downto 0));
end JugadorActual;

architecture Behavioral of JugadorActual is
signal jugador_aux: std_logic_vector(3 downto 0);
begin

process (rst, clk, jugador_1, placa)
    begin
        if (rst = '1') then
            jugador_aux <= "0000";
        end if;
        if (jugador_1 = '1') then -- mostrara por el display 1 si he ganado
            jugador_aux <= "0001";
        end if;
        if (placa = '1') then -- y 2 si ha ganado la placa
            jugador_aux <= "0010";
        end if;
end process;
jugador <= jugador_aux;

end Behavioral;
