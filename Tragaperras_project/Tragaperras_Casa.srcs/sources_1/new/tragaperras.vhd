library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tragaperras IS
PORT (
    rst : in std_logic;
    clk : IN std_logic;
    inicio : IN std_logic;
    fin : IN std_logic;
    cont1: OUT std_logic_vector (3 DOWNTO 0);
    cont2: OUT std_logic_vector (3 DOWNTO 0);
    leds: OUT std_logic_vector (15 DOWNTO 0)
);
END tragaperras;

architecture Behavioral of tragaperras is
    signal enable_contador_display1 : std_logic;
    signal enable_contador_display2 : std_logic;
    signal enable_contador_5seg: std_logic;
    signal control: std_logic_vector(4 downto 0);
    signal equals_cd1_cd2: std_logic;
    signal equals_9: std_logic;
    
    component controller is
    port (
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
    end component;
    
    component data_path is
    port (
        rst : in  std_logic;
        clk : in  std_logic;
        control: in std_logic_vector (4 downto 0);
        enable_contador_display1: in std_logic;
        enable_contador_display2: in std_logic;
        enable_contador_5seg: in std_logic;
        cont1: out std_logic_vector (3 DOWNTO 0);
        cont2: out std_logic_vector (3 DOWNTO 0);
        equals_cd1_cd2: out std_logic;
        equals_9: out std_logic;
        leds: out std_logic_vector (15 DOWNTO 0)
    );
    end component;
    
begin
    my_controller: controller 
    PORT MAP (rst => rst, 
              clk => clk, 
              inicio => inicio, 
              fin => fin,
              control => control,
              enable_contador_display1 => enable_contador_display1,
              enable_contador_display2 => enable_contador_display2,
              enable_contador_5seg  => enable_contador_5seg,
              equals_cd1_cd2 => equals_cd1_cd2,
              equals_9 => equals_9
              );

    my_datapath: data_path
    PORT MAP (rst => rst, 
              clk => clk,
              control => control,
              leds => leds,
              enable_contador_display1 => enable_contador_display1,
              enable_contador_display2 => enable_contador_display2,
              enable_contador_5seg => enable_contador_5seg,
              cont1 => cont1,
              cont2 => cont2,
              equals_cd1_cd2 => equals_cd1_cd2,
              equals_9 => equals_9
              );
          

end Behavioral;
