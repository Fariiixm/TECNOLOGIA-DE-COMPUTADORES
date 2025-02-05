----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.01.2025 12:57:46
-- Design Name: 
-- Module Name: datapath - Behavioral
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

entity datapath is
  Port (
        rst: in std_logic;
        clk: in std_logic;
        control: in std_logic_vector(11 downto 0);
        contAscen: inout std_logic_vector(3 downto 0);
        numGuardado: inout std_logic_vector(3 downto 0);
        diff: out std_logic_vector(3 downto 0);
        contDescen: out std_logic_vector(3 downto 0);
        contador_5seg: out std_logic_vector(3 downto 0);
        leds: out std_logic_vector(15 downto 0) );
end datapath;

architecture Behavioral of datapath is

component divisor
    port (
        rst: in std_logic;
        clk_entrada: in std_logic;
        clk_salida: out std_logic_vector(3 downto 0)
    );
  end component;

component AlmacenarNum
    port(
        rst: in std_logic;
        clk: in std_logic;
        save: in std_logic;
        num: in std_logic_vector(3 downto 0);
        numero_guardado: out std_logic_vector(3 downto 0)
    );
end component;

component Contador_ascendente
    port(
        rst: in std_logic;
        clk: in std_logic;
        enable: in std_logic;
        salida: out std_logic_vector(3 downto 0)
    );
end component;
    
component Contador_descendente
    port(
        rst: in std_logic;
        clk: in std_logic;
        enable: in std_logic;
        salida: out std_logic_vector(3 downto 0)
    );
end component;
    
component ContMod10
    port(
        rst: in std_logic;
        clk: in std_logic;
        enable: in std_logic;
        salida: out std_logic_vector(3 downto 0)
    );
end component;
    
component WinLeds
    port(
        rst: in std_logic;
        clk: in std_logic;
        leds: out std_logic_vector(15 downto 0)
    );
end component;
    
component LooseLeds
    port(
        rst: in std_logic;
        clk: in std_logic;
        leds: out std_logic_vector(15 downto 0)
    );
end component;

component DrawLeds
    port(
        rst: in std_logic;
        clk: in std_logic;
        leds: out std_logic_vector(15 downto 0)
    );
end component;
    
component WaitLeds 
    port(
        rst: in std_logic;
        clk: in std_logic;
        leds: out std_logic_vector(15 downto 0)
    );
end component;

component Diferencia
  Port (
    clk: in std_logic;
    rst: in std_logic;
    calc_enable: in std_logic;
    num1: in std_logic_vector(3 downto 0);
    num2: in std_logic_vector(3 downto 0);
    result: out std_logic_vector(3 downto 0)
  );
end component;
    
    signal clk_aux: std_logic_vector(3 downto 0);
    
    signal control_aux: std_logic_vector(11 downto 0);
    alias rst_contDescen: std_logic is control_aux(0);
    alias rst_cont5seg: std_logic is control_aux(1);
    alias rst_contAscen: std_logic is control_aux(2);
    alias enable_contAscen: std_logic is control_aux(3);
    alias guardarNum: std_logic is control_aux(4);
    alias enable_calcDiff: std_logic is control_aux(5);
    alias rst_calcDiff: std_logic is control_aux(6);
    alias enable_cont5seg: std_logic is control_aux(7);
    alias enable_contDescen: std_logic is control_aux(8);
    alias mux_leds: std_logic_vector(2 downto 0) is control_aux(11 downto 9);
    
    
    signal leds_ganar: std_logic_vector(15 downto 0);
    signal leds_perder: std_logic_vector(15 downto 0);
    signal leds_esperando: std_logic_vector(15 downto 0);
    signal leds_empate: std_logic_vector(15 downto 0);
  
    
    

begin

    control_aux <= control;
    
    my_divisor: divisor port map (rst => rst, clk_entrada => clk, clk_salida => clk_aux);
    my_Contador_ascendente: Contador_ascendente port map(rst => rst_contAscen, clk => clk_aux(1), enable => enable_contAscen, salida => contAscen);
    my_Contador_descendente: Contador_descendente port map(rst => rst_contDescen, clk => clk_aux(3), enable => enable_contDescen, salida => contDescen);
    my_ContMod10: ContMod10 port map(rst => rst_cont5seg, clk => clk_aux(0), enable => enable_cont5seg, salida => contador_5seg);
    my_WinLeds: WinLeds port map(rst => rst_contDescen, clk => clk_aux(0), leds => leds_ganar);
    my_LooseLeds: LooseLeds port map(rst => rst_contDescen, clk => clk_aux(0), leds => leds_perder);
    my_WaitLeds: WaitLeds port map(rst => rst_contDescen, clk => clk_aux(2), leds => leds_esperando);
    my_DrawLeds: DrawLeds port map(rst=>rst, clk=>clk_aux(0),leds=>leds_empate);
    my_AlmacenarNum: AlmacenarNum port map(rst => rst_contAscen, clk => clk_aux(1), save => guardarNum, num => contAscen, numero_guardado => numGuardado);
    my_Diferencia: Diferencia port map(clk => clk_aux(1), rst => rst_calcDiff, calc_enable => enable_calcDiff, num1 => contAscen, num2 => numGuardado, result => diff);

    process(leds_ganar, leds_perder, leds_esperando, leds_empate, control_aux, mux_leds, clk)
    begin
        if mux_leds = "000" then
            leds <= (others => '0');
        elsif mux_leds = "001" then
            leds <= leds_esperando;
        elsif mux_leds = "010" then
            leds <= leds_ganar;
        elsif mux_leds = "011" then
            leds <= leds_perder;
        elsif mux_leds = "100" then
            leds <= leds_empate;
        else
            leds <= (others => '0');
        end if;
    end process;

end Behavioral;
