----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2024 20:23:58
-- Design Name: 
-- Module Name: divisor - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divisor is
    generic (
        N : std_logic_vector(27 downto 0) -- Valor genérico que define el divisor
    );
    port (
        rst        : in  std_logic;       -- Señal de reset
        clk_in: in  std_logic;       -- Reloj de entrada (100 MHz)
        clk_out : out std_logic        -- Reloj de salida con frecuencia dividida
    );
end entity divisor;

architecture Behavioral of divisor is
    signal contador : std_logic_vector(27 downto 0) := (others => '0'); -- Contador
    signal clk_temp : std_logic := '0';                                 -- Señal temporal para el reloj
begin
    process (clk_in, rst)
    begin
        if rst = '1' then
            contador <= (others => '0');
            clk_temp <= '0';
        elsif rising_edge(clk_in) then
            if contador = N then
                contador <= (others => '0'); -- Reinicia el contador
                clk_temp <= not clk_temp;   -- Cambia el estado del reloj
            else
                contador <= contador + 1;   -- Incrementa el contador
            end if;
        end if;
    end process;

    clk_out <= clk_temp; -- Asigna la señal temporal al puerto de salida
end Behavioral;

