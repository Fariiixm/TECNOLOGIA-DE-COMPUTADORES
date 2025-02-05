----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.01.2025 12:53:03
-- Design Name: 
-- Module Name: MayorMenor - Behavioral
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

entity MayorMenor is
  Port ( 
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
        leds: out std_logic_vector(15 downto 0));
end MayorMenor;

architecture Behavioral of MayorMenor is
   
component controller
    port(
        rst: in std_logic;
        clk: in std_logic;
        inicio: in std_logic;
        ok: in std_logic;
        Menor: in std_logic;
        Mayor: in std_logic;
        contAscen: in std_logic_vector(3 downto 0);
        numGuardado: in std_logic_vector(3 downto 0);
        contDescen: in std_logic_vector(3 downto 0);
        contador_5seg: in std_logic_vector(3 downto 0);
        control: out std_logic_vector(11 downto 0)
    );
end component;
    
component datapath
    port(
        rst: in std_logic;
        clk: in std_logic;
        control: in std_logic_vector(11 downto 0);
        contAscen: inout std_logic_vector(3 downto 0);
        numGuardado: inout std_logic_vector(3 downto 0);
        diff: out std_logic_vector(3 downto 0);
        contDescen: out std_logic_vector(3 downto 0);
        contador_5seg: out std_logic_vector(3 downto 0);
        leds: out std_logic_vector(15 downto 0)
    );
end component;
    
    signal control_aux: std_logic_vector(11 downto 0);
    signal contAscen_aux: std_logic_vector(3 downto 0);
    signal contDescen_aux: std_logic_vector(3 downto 0);
    signal numGuardado_aux: std_logic_vector(3 downto 0);
    signal diferencia_aux: std_logic_vector(3 downto 0);
    signal cont_5seg: std_logic_vector(3 downto 0);

begin
    contAscen <= contAscen_aux;
    contDescen <= contDescen_aux;
    numGuardado <= numGuardado_aux;
    diff <= diferencia_aux;
    
    my_datapath: datapath port map (rst => rst, clk => clk, control => control_aux, contAscen => contAscen_aux, numGuardado => numGuardado_aux, diff => diferencia_aux, contDescen => contDescen_aux, contador_5seg => cont_5seg, leds => leds);
    my_controller: controller port map (rst => rst, clk => clk, inicio => inicio, ok => ok, Menor => Menor, Mayor => Mayor, contAscen => contAscen_aux, numGuardado => numGuardado_aux, contDescen => contDescen_aux, contador_5seg => cont_5seg, control => control_aux);
end Behavioral;
