library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity alu is
    generic (
        constant W : positive
    );
    port (
        A : in std_logic_vector (W-1 downto 0);
        B : in std_logic_vector (W-1 downto 0);
        sel_fn : in std_logic_vector (3 downto 0);
        Y : out std_logic_vector (W-1 downto 0);
        Z : out std_logic
    );
end alu;


architecture arch of alu is

signal ys : std_logic_vector(W-1 downto 0);
-- señales auxiliares
signal Au, Bu : unsigned(W-1 downto 0);
signal As, Bs : signed(W-1 downto 0);
constant Ws : natural := integer(ceil(log2(real(W))));
begin

Au <= unsigned (A);
Bu <= unsigned (B);
As <= signed (A);
Bs <= signed (B);
    
operaciones:process(all) is

begin
    ys <= (others => '0');
    case sel_fn is

    when "0000" => --A+B
        ys <= std_logic_vector(Au + Bu);
    
    when "0001" => --A-B
        ys <= std_logic_vector(Au - Bu);

    when "0010" | "0011" => --A<<B desplazamiento izquierda
        ys <= std_logic_vector(shift_left(Au,to_integer(Bu(Ws-1 downto 0))));

    when "0100" | "0101" => --A<B complemento A2
        if As < Bs then
            ys <= (0 => '1' , others => '0');
        else
            ys <= (others => '0');
        end if;

    when "0110" | "0111" => --A<B binario natural
        if Au < Bu then
            ys <= (0 => '1', others => '0');
        else
            ys <= (others => '0');
        end if;

    when "1001" | "1000" => -- XOR
        ys <= A xor B;

    when "1010" => --A>>B binario natural 
        ys <= std_logic_vector(shift_right(Au,to_integer(Bu(Ws-1 downto 0))));

    when "1011" => --A>>B (Comp A2)
        ys <= std_logic_vector(shift_right(As,to_integer(Bu(Ws-1 downto 0))));
    
    when "1101" | "1100" => -- A o B
        ys <= A or B;

    when "1110" | "1111" =>-- A y B
        ys <= A and B;
    
    when others =>
        ys <= (others => '0');
    
    end case;
    end process;

    Y <= ys;
    Z <= '1' when ys = (ys'range => '0') else '0';

end arch;