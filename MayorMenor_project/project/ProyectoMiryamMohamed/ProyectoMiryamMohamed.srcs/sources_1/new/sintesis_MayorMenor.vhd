----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.01.2025 12:37:10
-- Design Name: 
-- Module Name: sintesis_MayorMenor - Behavioral
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

entity sintesis_MayorMenor is
  Port ( 
        rst: in std_logic;
        clk: in std_logic;
        boton_inicio: in std_logic;
        boton_fin: in std_logic;
        Menor: in std_logic;
        Mayor: in std_logic;
        display: out std_logic_vector(6 downto 0);
        leds: out std_logic_vector(15 downto 0);
        s_display: out std_logic_vector (3 downto 0)
  );
end sintesis_MayorMenor;

architecture Behavioral of sintesis_MayorMenor is
component MayorMenor is
    port(
        rst: in std_logic;
        clk: in std_logic;
        inicio: in std_logic;
        ok: in std_logic;
        Menor: in std_logic;
        Mayor: in std_logic;
        contAscen: out std_logic_vector(3 downto 0);
        numGuardado: out std_logic_vector(3 downto 0);
        diff: out std_logic_vector(3 downto 0);
        contDescen: out std_logic_vector(3 downto 0);
        leds: out std_logic_vector(15 downto 0)
    );
end component;
    
component debouncer is
    port (
    rst: in std_logic;
    clk: in std_logic;
    x: in std_logic;
    xDeb: out std_logic;
    xDebFallingEdge: out std_logic;
    xDebRisingEdge: out std_logic
    );
end component;
    
component displays is
    port (
    rst: in std_logic;
    clk: in std_logic;
    digito_0: in std_logic_vector(3 downto 0);
    digito_1: in std_logic_vector(3 downto 0);
    digito_2: in std_logic_vector(3 downto 0);
    digito_3: in std_logic_vector(3 downto 0);
    display: out std_logic_vector(6 downto 0);
    display_enable: out std_logic_vector(3 downto 0)
    );
end component;
    
    signal s_displays: std_logic_vector(3 downto 0);
    signal inicio, ok: std_logic;
    signal reset_n: std_logic;
    
    signal contDescen: std_logic_vector(3 downto 0);
    signal num: std_logic_vector(3 downto 0);
    signal contAscen: std_logic_vector(3 downto 0);
    signal diferencia: std_logic_vector(3 downto 0);
begin
    reset_n <= not rst;
    
    debouncerInsts_displayce1 : debouncer PORT MAP(reset_n, clk, boton_inicio, OPEN, OPEN, inicio);
	debouncerInsts_displayce2 : debouncer PORT MAP(reset_n, clk, boton_fin, OPEN, OPEN, ok);
	MayorMenorInsts_displayce : MayorMenor PORT MAP(rst => rst, clk => clk, inicio => inicio, ok => ok, Menor => Menor, Mayor => Mayor, contAscen => contAscen, numGuardado => num, diff => diferencia, contDescen => contDescen, leds => leds);
	displays_inst : displays PORT MAP(rst, clk, contAscen, num, diferencia, contDescen, display, s_display);
    --usamos los 4 displays, siendo           'x4(rand)  , x3 ,   x2      ,   x1(temporizador) ' (invertido)

end Behavioral;
