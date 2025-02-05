----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.01.2025 12:56:39
-- Design Name: 
-- Module Name: controller - Behavioral
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

entity controller is
  Port ( rst: in std_logic;
        clk: in std_logic;
        inicio: in std_logic;
        ok: in std_logic;
        Menor: in std_logic;
        Mayor: in std_logic;
        contAscen: in std_logic_vector(3 downto 0);
        numGuardado: in std_logic_vector(3 downto 0);
        contDescen: in std_logic_vector(3 downto 0);
        contador_5seg: in std_logic_vector(3 downto 0);
        control: out std_logic_vector(11 downto 0));
end controller;

architecture Behavioral of controller is
    type STATES is (S0, S1, S2, S3, S4, S5, S6, S7, S8);   
    signal STATE, NEXT_STATE: STATES;
    
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
    
begin
control <= control_aux;
    
    process(clk, rst)
    begin
        if rst = '1' then
            STATE <= S0;
        elsif rising_edge(clk) then
            STATE <= NEXT_STATE;
        end if;
    end process;
    
    process(STATE, inicio, ok, contAscen, contDescen, Mayor, Menor, numGuardado, contador_5seg, enable_calcDiff) 

    begin
    control_aux <= (others => '0'); 
        case STATE is
            when S0 => --estado inicial
            
                rst_calcDiff <= '1';
                rst_contDescen <= '1';
                rst_contAscen <= '1';
                rst_cont5seg <= '1';
                
                guardarNum <= '0';
                
                enable_contAscen <= '0';
                enable_cont5seg <= '0';
                enable_contDescen <= '0';
                enable_calcDiff<='0';
                
                mux_leds <= "000";
                
                if inicio = '1' then
                    NEXT_STATE <= S1;
                else
                    NEXT_STATE <= S0;
                end if;
                
            when S1 => --inicio, primer random
            
                rst_contDescen <= '0';
                rst_cont5seg <= '0';
                rst_calcDiff <= '0';
                rst_contAscen <='0'; 
                
                enable_contAscen <= '1';
                enable_cont5seg <= '1';
                enable_contDescen <= '0';
                enable_calcDiff<='0';
                
                
                mux_leds <= "001"; --secuencia esperando
                
                if(contador_5seg = "1001") then --temporizador para el rand 5 segundos
                    NEXT_STATE <= S2;
                else
                    NEXT_STATE <= S1;
                end if;
                
            when S2=> --en caso de empate, o si ganamos seguimos jugando
                
                rst_contDescen <= '1';
                rst_contAscen <= '0';
                
                
                enable_contAscen <= '0';
                enable_cont5seg <= '0';
                enable_contDescen <= '0';
                enable_calcDiff<='0';
                
                
                mux_leds <= "000"; --luces apagadas
                
                NEXT_STATE <= S3;
                
            when S3 => --empieza el temporizador descendente 10 seg para responder
                rst_contDescen <= '0';
                rst_cont5seg <= '1';
                
                guardarNum <= '1';
                
                enable_contAscen <= '0';
                enable_cont5seg <= '0'; 
                enable_contDescen <= '1';
                enable_calcDiff<='0';
                
                mux_leds <= "000"; 

                if (contDescen = "0000" or ok = '1') then
                    if ((Mayor = '0' and Menor = '0') or (Mayor = '1' and Menor = '1')) then
                        NEXT_STATE <= S0; -- no se respondio o se selecciono las dos
                    else
                        NEXT_STATE <= S4; -- se respondio correctamente
                    end if;
                else
                    NEXT_STATE <= S3; -- sigue esperando
                end if;
                
            when S4 => --generamos segundo random
                rst_contDescen <= '0';
                rst_cont5seg <= '0';
               
                guardarNum <= '0';
                
                enable_contAscen <= '1';
                enable_cont5seg <= '1';    
                enable_contDescen <= '0';
                enable_calcDiff<='0';
               
                mux_leds <= "001";
                
                if(contador_5seg = "1001") then -- 5 segundos para siguiente random
                    NEXT_STATE <= S5;
                else
                    NEXT_STATE <= S4;
                end if;
                
            when S5 => --valorar los resultados
                rst_contDescen <= '0';
                rst_cont5seg <= '1';
                
                enable_contAscen <= '0';
                enable_cont5seg <= '0';
                enable_contDescen <= '0';
                
                mux_leds <= "000";
                
                if (contAscen = numGuardado) then
                    NEXT_STATE <= S8; -- Empate
                elsif ((Menor = '1' and (contAscen < numGuardado)) or 
                       (Mayor = '1' and (contAscen > numGuardado))) then
                    NEXT_STATE <= S6; -- Ganamos
                else
                    NEXT_STATE <= S7; -- perdemos
                end if;

                
            when S6 => --ganamos
                rst_cont5seg <= '0';
               
                enable_cont5seg <= '1'; 
                enable_calcDiff <= '1';
                
                mux_leds <= "010";
                
                if(contador_5seg = "1001") then
                    
                    NEXT_STATE <= S2; --seguimos jugando
                else
                    NEXT_STATE <= S6;
                end if;
                
            when S7 => --perdemos
                rst_cont5seg <= '0';
                
                
                enable_cont5seg <= '1';
                enable_calcDiff<='1';
                
                
                mux_leds <= "011";
                
                if(contador_5seg = "1001") then
                    NEXT_STATE <= S0;
                else
                    NEXT_STATE <= S7;
                end if;
                
            when S8=>
            
                enable_cont5seg <= '1';
                
                mux_leds <= "100";
                
                if(contador_5seg = "1001") then
                    NEXT_STATE <= S2;
                else
                    NEXT_STATE <= S8;
                end if;
                
            when others =>
                NEXT_STATE <= S0; 

        end case;
    
    end process;

end Behavioral;
