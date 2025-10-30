library ieee;
use ieee.std_logic_1164.all;

entity deco_hexa is
    port (
        entrada : in  std_logic_vector(3 downto 0); -- Entrada de 4 bits
        segmento : out std_logic_vector(6 downto 0) -- Salida de 7 bits
    );
end deco_hexa;

architecture arch of deco_hexa is
begin

    deco: process(entrada)
    begin

        case entrada is
            -- (g,f,e,d,c,b,a)
            when "0000" => segmento <= "0111111"; -- 0
            when "0001" => segmento <= "0000110"; -- 1
            when "0010" => segmento <= "1011011"; -- 2
            when "0011" => segmento <= "1001111"; -- 3
            when "0100" => segmento <= "1100110"; -- 4
            when "0101" => segmento <= "1101101"; -- 5
            when "0110" => segmento <= "1111101"; -- 6
            when "0111" => segmento <= "0000111"; -- 7
            when "1000" => segmento <= "1111111"; -- 8
            when "1001" => segmento <= "1101111"; -- 9
            when "1010" => segmento <= "1110111"; -- A
            when "1011" => segmento <= "1111100"; -- b
            when "1100" => segmento <= "0111001"; -- C
            when "1101" => segmento <= "1011110"; -- d
            when "1110" => segmento <= "1111001"; -- E
            when "1111" => segmento <= "1110001"; -- F

            when others => segmento <= "0000000"; -- Apagado
        
        end case;
    end process;
    
end arch;