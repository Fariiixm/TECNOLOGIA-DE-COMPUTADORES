----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2024 17:35:58
-- Design Name: 
-- Module Name: data_path - ARCH
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
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_path is
 generic (n: natural := 8;
            m: natural := 4);
 port (clk, reset:  in std_logic;    
        dividendo:   in std_logic_vector(n - 1 downto 0);   
        divisor:     in std_logic_vector(m - 1 downto 0);   
        control:       in std_logic_vector(8 downto 0);  
        cociente:       out std_logic_vector(n - 1 downto 0);
        less_or_equals: out std_logic;
        MSB_dividend:   out std_logic);
 end data_path;

 architecture ARCH of data_path is
 signal control_aux: std_logic_vector(8 downto 0);
 alias load_dividend : std_logic is control_aux(0);
 alias load_divisor : std_logic is control_aux(1);
 alias shift_right_divisor: std_logic is control_aux(2);
 alias load_quotient : std_logic is control_aux(3);
 alias shift_left_quotient : std_logic is control_aux(4);
 alias load_k : std_logic is control_aux(5);
 alias count_k : std_logic is control_aux(6);
 alias mux_dividend : std_logic is control_aux(7);
 alias operation : std_logic is control_aux(8);-- declaration of components and remaining intermediate signals...


 signal aux_dividendo:  std_logic_vector (n downto 0);
 signal aux_divisor:  std_logic_vector (n downto 0);
 signal aux_cociente:  std_logic_vector (n - 1 downto 0);
 signal aux_count: std_logic_vector(n downto 0);
 signal adder_out: std_logic_vector(n downto 0);
 signal multiplexor_out: std_logic_vector(n downto 0);

 begin -- code of the datapath...
 
 
    control_aux <= control;
 
    
    
    process(clk, reset) --controlador divisor
    begin
        if reset = '1' then
            aux_divisor <= (others => '0');
        elsif rising_edge(clk) then
            if load_divisor = '1' then
                aux_divisor(n downto n-m) <= '0' & divisor; 
                aux_divisor(n-m-1 downto 0) <= (others=>'0');
            elsif shift_right_divisor = '1' then
                aux_divisor <= '0' & aux_divisor(n downto 1);
            end if;
        end if;
    end process;
    
    process (clk, reset) --controlador dividendo
        begin
            if reset = '1' then
                aux_dividendo <= (others => '0'); 
            elsif (rising_edge(clk)) then
                if load_dividend = '1' then
                    aux_dividendo <= multiplexor_out;
                end if;
            end if;
    end process;
    adder_out <= aux_dividendo - aux_divisor when operation = '1' else aux_dividendo + aux_divisor;
    multiplexor_out <= '0' & dividendo when mux_dividend = '1' else adder_out;
    
    process(clk, reset) --control del contador y cociente
        begin
            if reset = '1' then
                aux_count <= (others => '0');
                aux_cociente <= (others => '0');
            elsif rising_edge(clk) then
                if load_quotient = '1' then --controlador del cociente
                    aux_cociente <= (others => '0');
                elsif shift_left_quotient = '1' then
                    aux_cociente <= aux_cociente(n-2 downto 0) & not(aux_dividendo(n));
                end if;
                if load_k = '1' then --controlador del cont
                    aux_count <= (others => '0');
                elsif count_k = '1' then
                    aux_count <= std_logic_vector(to_unsigned(to_integer(unsigned(aux_count)) + 1, n+1));
                    if (unsigned(aux_count) < (n - m)) then
                        less_or_equals <= '1';
                    else 
                        less_or_equals <= '0'; --termina
                    end if;
                    
                end if;
            end if;
    end process;
    
    cociente <= aux_cociente;
    MSB_dividend <= aux_dividendo(n);
 
 end ARCH;
