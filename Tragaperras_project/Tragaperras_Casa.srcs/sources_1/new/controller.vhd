library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
    Port (
        rst : IN  std_logic;
        clk : IN  std_logic;
        inicio : IN  std_logic;
        fin : in  std_logic;
        control: out std_logic_vector (4 downto 0);
        enable_contador_display1: out std_logic;
        enable_contador_display2: out std_logic;
        enable_contador_5seg: out std_logic;
        equals_cd1_cd2: in std_logic;
        equals_9: in std_logic
    );
end controller;

architecture Behavioral of controller is
    type STATES is (s0, s_espera, s1, s2, s3);
    signal STATE, NEXT_STATE: STATES;
    
    signal control_aux: std_logic_vector(4 downto 0);
    alias leds_apagados: std_logic is control_aux(0);
    alias leds_atraer: std_logic is control_aux(1);
    alias leds_gana: std_logic is control_aux(2);
    alias leds_pierde: std_logic is control_aux(3);
    
    --leds de espera
    alias leds_espera: std_logic is control_aux(4);
    
begin 
    SYNC: process (clk, rst) --sincrono
    begin
        if (rst = '1') then
            STATE <= s0;
        elsif rising_edge(clk) then
            STATE <= NEXT_STATE;
        end if;
    end process SYNC;
    
    control <= control_aux;
    
    COMB: process(STATE, inicio, fin, equals_9, equals_cd1_cd2)
    begin
    
        leds_atraer <= '1';
        leds_pierde <= '0';
        leds_gana <= '0';
        leds_apagados <= '0';
        leds_espera <='0';
          
        
        case STATE is
            when s0 =>
                leds_atraer <= '1';
                leds_pierde <= '0';
                leds_gana <= '0';
                
                
                enable_contador_display1 <= '0';
                enable_contador_display2 <= '0';
                
                if (inicio = '1') then
                    NEXT_STATE <= s_espera;
                else
                    NEXT_STATE <= s0;
                end if;
                
            when s_espera => --nuevo estados
                enable_contador_display1 <= '1';
            
                enable_contador_5seg <= '0';
                
                leds_espera <= '1';
                
                leds_atraer <= '0';
                
                
                if (inicio = '1') then
                    NEXT_STATE <= s1;
                else
                    NEXT_STATE <= s_espera;
                end if;
                
                
            when s1 =>
                enable_contador_display1 <= '1';
                enable_contador_display2 <= '1';
                
                
                leds_apagados <= '1';
                
             
                leds_espera<='0';
                
                
                if (fin = '1') then
                    NEXT_STATE <= s2;
                else
                    NEXT_STATE <= s1;
                end if;
                
                
           when s2 =>
                
                enable_contador_display1 <= '0';
                enable_contador_display2 <= '0';
                
                leds_apagados <= '0';
                if (equals_cd1_cd2 = '0') then
                    leds_pierde <= '1';
                else    
                    leds_gana <= '1';
                end if;
                enable_contador_5seg <= '1';
                if (equals_9 = '1') then
                    enable_contador_5seg <= '0';
                    NEXT_STATE <= s0;
                else
                    NEXT_STATE <= s2;
                end if;

                
            when others =>
                NEXT_STATE <= s0;
        end case;
    end process COMB;
end Behavioral;
