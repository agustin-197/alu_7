library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity calculadora is 
    generic(W : positive:=4);
    port (

        clk_in   : in  std_logic; -- Reloj de 12 MHz
        interruptores     : in  std_logic_vector(7 downto 0);

        segmento  : out std_logic_vector(6 downto 0);
        punto     : out std_logic
    );
end calculadora;


architecture arch of calculadora is

    --señales alu
    signal A       :   std_logic_vector(W-1 downto 0);
    signal B       :   std_logic_vector(W-1 downto 0);
    signal sel_fn  :   std_logic_vector(3 downto 0);
    signal Y       :   std_logic_vector(W-1 downto 0);
    signal Z       :   std_logic;
    --señales det flanco       
    signal clk     :   std_logic;
    signal entrada_f :   std_logic;
    signal pulso   :   std_logic;
    --señales deco
    signal entrada_d :   std_logic_vector(3 downto 0);
    signal segmento_d:   std_logic_vector(6 downto 0);
        
    --registros A y B
    signal reg_A : std_logic_vector(3 downto 0) := (others => '0');
    signal reg_B : std_logic_vector(3 downto 0) := (others => '0');
    
    --señales para pulsos
    signal pulso_4 : std_logic; 
    signal pulso_5 : std_logic; 
    signal pulso_6   : std_logic; 

    --señales para conectar ALU
    signal alu_Y_salida : std_logic_vector(3 downto 0);

    --señal para el display
    signal dato_display : std_logic_vector(3 downto 0);

begin

    --3 detectores de flanco
    
    det_flanco_4 : entity det_flanco
        port map (
            clk     => clk_in,
            entrada => interruptores(4),
            pulso   => pulso_4
        );

    det_flanco_5 : entity det_flanco
        port map (
            clk     => clk_in,
            entrada => interruptores(5),
            pulso   => pulso_5
        );

    det_flanco_6 : entity det_flanco
        port map (
            clk     => clk_in,
            entrada => interruptores(6),
            pulso   => pulso_6
        );


    ALU : entity work.alu
        generic map (W=>W)
        port map (
            A      => reg_A,         
            B      => reg_B,         
            sel_fn => interruptores(3 downto 0), 
            Y      => alu_Y_salida,    
            Z      => punto      
        );


    registro_de_carga : process(clk_in)
    begin
        if rising_edge(clk_in) then
    
            if pulso_6 = '1' then
                reg_A <= alu_Y_salida; 
            elsif pulso_4 = '1' then
                reg_A <= interruptores(3 downto 0);
            end if;

            if pulso_5 = '1' then
                reg_B <= interruptores(3 downto 0); 
            end if;
            
        end if;
    end process;

    dato_display <= reg_A when interruptores(7) = '0' 
                else reg_B;

    deco : entity deco_hexa
        port map (
            entrada => dato_display, 
            segmento  => segmento          
        );
    

end arch;