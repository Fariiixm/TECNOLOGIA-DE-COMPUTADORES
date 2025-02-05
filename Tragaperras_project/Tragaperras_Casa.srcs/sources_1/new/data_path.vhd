library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_path is
  Port (
        rst : in  std_logic;
        clk : in  std_logic;
        control: in std_logic_vector (4 downto 0);
        enable_contador_display1: in std_logic;
        enable_contador_display2: in std_logic;
        enable_contador_5seg: in std_logic;
        cont1: out std_logic_vector (3 downto 0);
        cont2: out std_logic_vector (3 downto 0);
        equals_cd1_cd2: out std_logic;
        equals_9: out std_logic;
        leds: out std_logic_vector (15 downto 0)
    );
end data_path;

architecture Behavioral of data_path is

    signal clk_2Hz: std_logic;
    signal clk_05Hz: std_logic;
    signal clk_1kHz: std_logic;
    signal clk_2kHz: std_logic;
    
    signal cont_5seg: std_logic_vector (3 downto 0);
    signal cont1_aux: std_logic_vector (3 downto 0);
    signal cont2_aux: std_logic_vector (3 downto 0);
    
    signal control_aux: std_logic_vector(4 downto 0);
    alias leds_apagados: std_logic is control_aux(0);
    alias leds_atraer: std_logic is control_aux(1);
    alias leds_gana: std_logic is control_aux(2);
    alias leds_pierde: std_logic is control_aux(3);
    
    alias leds_espera: std_logic is control_aux(4);
    
    signal leds_aux: std_logic_vector(15 downto 0);
    
    
--    signal l_status: std_logic_vector (15 downto 0);
    
    signal l_win: std_logic_vector (15 downto 0);
    signal l_loose: std_logic_vector (15 downto 0);
    signal l_attract: std_logic_vector (15 downto 0);
    
    signal l_espera: std_logic_vector (15 downto 0);

component divisor is
        generic (
            N: std_logic_vector (27 downto 0));
        port (
            rst: in STD_LOGIC;
            clk_in: in STD_LOGIC;
            clk_out: out STD_LOGIC
        );
end component;

component ContMod10 is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        cont : out std_logic_vector (3 downto 0)
    );
end component;

begin

    freq_2Hz : divisor
        generic map (
            N => "0101111101011110000100000000" --25Hz
        )
        port map(
            rst => rst,
            clk_in => clk, 
            clk_out => clk_2Hz 
        );
        
     freq_05Hz : divisor
        generic map (
            N => "0010111110101111000010000000"--100Hz
        )
        port map(
            rst => rst,
            clk_in => clk,
            clk_out => clk_05Hz 
        );
     freq_1kHz : divisor
        generic map (
            N => "0000010011000100101101000000"--50KHz
        )
        port map(
            rst => rst,
            clk_in => clk,
            clk_out => clk_1kHz 
        );
        
     freq_2kHz : divisor
        generic map (
            N => "0000100110001001011010000000"--25kHz
        )
        port map(
            rst => rst,
            clk_in => clk,
            clk_out => clk_2kHz 
        );    
        
        
        process (clk_2Hz)
        begin    
            if (rising_edge(clk_2Hz)) then
                if(leds_apagados = '1') then
                    leds_aux <= (others => '0');
                elsif (leds_gana = '1') then 
                    if (l_win(14) = '0') then
                        l_win <= (others => '1');
                    else
                        l_win <= (others => '0');
                    end if;
                    leds_aux <= l_win;
                    
                elsif (leds_pierde = '1') then
                    if (l_loose(0) = '0') then
                        l_loose <= "0101010101010101";
                    else
                        l_loose <= "1010101010101010";
                    end if;
                    leds_aux <= l_loose;
                elsif (leds_atraer = '1') then
                    l_attract(14 downto 0) <= l_attract(15 downto 1);
                    l_attract(15) <= not l_attract(0);
                    leds_aux <= l_attract;
    
                elsif(leds_espera = '1') then 
                    if(l_espera(0) = '1') then
                        l_espera <= "1111111100000000";
                    else 
                        l_espera <= "0000000011111111";
                    end if;
                    leds_aux <= l_espera;
                end if;
            end if;
            
    end process;

-- process (clk_2Hz)
--        begin    
--            if (rising_edge(clk_2Hz)) then
--                if(leds_apagados = '1') then
                    
--                    l_status <= (others => '0');
--                elsif (leds_gana = '1') then 
--                    if (l_status(14) = '0') then
--                        l_status <= (others => '1');
--                    else
--                        l_status <= (others => '0');
--                    end if;
                 
                    
--                elsif (leds_pierde = '1') then
--                    if (l_status(0) = '0') then
--                        l_status <= "0101010101010101";
--                    else
--                        l_status <= "1010101010101010";
--                    end if;
                   
--                elsif (leds_atraer = '1') then
--                    l_status(14 downto 0) <= l_status(15 downto 1);
--                    l_status(15) <= not l_status(0);
                   
    
--                elsif(leds_espera = '1') then 
--                    if(l_status(0) = '1') then
--                        l_status <= "1111111100000000";
--                    else 
--                        l_status <= "0000000011111111";
--                    end if;
--                 --   leds_aux <= l_status;
--                end if;
--                leds_aux <= l_status;
--            end if;
            
--    end process;
    
   
    
    
    cont_1: process (clk_1kHz, rst)
        begin
            if (rst = '1') then
                cont1_aux <= (others => '0');
            elsif (rising_edge(clk_1kHz)) then
                if (enable_contador_display1 = '1') then
                    cont1_aux <= std_logic_vector(unsigned(cont1_aux) + 1);
                end if;
            end if;
            if (cont1_aux = "1001") then
                cont1_aux <= "0000";
            end if;
    end process;
    
    cont_2: process (clk_2kHz, rst)
        begin
            if (rst = '1') then
                cont2_aux <= (others => '0');
            elsif (rising_edge(clk_2kHz)) then
                if (enable_contador_display2 = '1') then
                    cont2_aux <= std_logic_vector(unsigned(cont2_aux) + 1);
                end if;
            end if;
            if (cont2_aux = "1001") then
                cont2_aux <= "0000";   
            end if;
    end process;
    
    contador_5seg: process (clk_05Hz, rst)
        begin
            cont_5seg <= (others => '0');
            if (rst = '1') then
                cont_5seg <= (others => '0');
            elsif (rising_edge(clk_05Hz)) then
                if (enable_contador_5seg = '1') then
                    cont_5seg <= std_logic_vector(unsigned(cont_5seg) + 1);
                end if;
            end if;
    end process;
    
    
    leds <= leds_aux;
    equals_cd1_cd2 <= '1' when cont1_aux = cont2_aux else '0';
    equals_9 <= '1' when cont_5seg = "1001" else '0';
    control_aux <= control;
    cont1 <= cont1_aux;
    cont2 <= cont2_aux;
 


end Behavioral;
