----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2024 17:30:05
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
 port(clk, reset, inicio: in std_logic;
 less_or_equals: in std_logic;
 MSB_dividend: in std_logic;
 control: out std_logic_vector(8 downto 0);
 fin: out std_logic);
 end controller;

architecture ARCH of controller is
 type STATES is (s0, s1, s2, s3, s4, s5, s6, s7);    --Define the states here
 signal STATE, NEXT_STATE: STATES;
 signal control_aux: std_logic_vector(8 downto 0);
 alias load_dividend : std_logic is control_aux(0);
 alias load_divisor : std_logic is control_aux(1);
 alias shift_right_divisor: std_logic is control_aux(2);
 alias load_quotient : std_logic is control_aux(3);
 alias shift_left_quotient : std_logic is control_aux(4);
 alias load_k : std_logic is control_aux(5);
 alias count_k : std_logic is control_aux(6);
 alias mux_dividend : std_logic is control_aux(7);
 alias operation : std_logic is control_aux(8);
 
-- signal flag_finish: std_logic;
-- signal aux:std_logic:= '0';
 --signal fin_reg: std_logic;
 
 
 begin --Processes SYNC and COMB of the finite state machine (as in Lab 2)
    process(reset, clk)
    begin
        if(reset = '1') then 
            STATE <= s0;
--            flag_finish <= '0';
        elsif rising_edge(clk) then 
            
            STATE <= NEXT_STATE;
            
        end if;
    end process;
    
     
    control <= control_aux;   
    
    process(STATE, inicio, less_or_equals, MSB_dividend) 
    begin
    
        case STATE is  
        when s0=>
        fin <= '1';
            if(inicio = '1') then 
                NEXT_STATE <= s1;
            else
                NEXT_STATE <=s0;
            end if;
                 
        when s1=>
            load_dividend <= '1';
            load_divisor <= '1';
            shift_right_divisor <= '1';
            load_quotient <= '1';
            shift_left_quotient <= '1';
            load_k <= '1';
            count_k <= '1';
            mux_dividend <= '1';
            fin <= '0';
            NEXT_STATE <=s2;
        
        when s2=>
            load_dividend <= '1';
            load_divisor <= '0';
            shift_right_divisor <= '0';
            load_quotient <= '0';
            shift_left_quotient <= '0';
            load_k <= '0';
            count_k <= '0';
            mux_dividend <= '0';
            operation <= '1';
            NEXT_STATE <= s3;
        
        when s3=>
            load_dividend <= '0';
            load_divisor <= '0';
            shift_right_divisor <= '0';
            load_quotient <= '0';
            shift_left_quotient <= '0';
            load_k <= '0';
            count_k <= '0';
            mux_dividend <= '0';
            if (MSB_dividend = '1') then
                    NEXT_STATE <= s4;
            else
                    NEXT_STATE <= s5;
            end if;    
            
        when s4=>    
            load_dividend <= '1'; 
            shift_left_quotient <= '1';
            mux_dividend <= '0';
            operation <= '0'; 
            NEXT_STATE <= s6;
        
        when s5=>     
            shift_left_quotient <= '1';
            NEXT_STATE <= s6;
        
        when s6=>   
            load_dividend <= '0';
            shift_right_divisor <= '1';
            shift_left_quotient <= '0';
            count_k <= '1';
            NEXT_STATE <= s7;
              
        when s7=>
            shift_right_divisor <= '0';
            count_k <= '0';
            if (less_or_equals = '1') then
                NEXT_STATE <= s2;
            --    aux <= '0';
            else
                NEXT_STATE <= s0; 
              --  aux <= '1'; 
            end if;
        end case;
  end process;   
  
 --process(flag_finish) 
 --begin 
 --   if flag_finish = '1' then 
 --       fin <= '1'; 
 --   else fin <= '0'; 
 --   end if; 
 --end process;   
 
 end ARCH;
