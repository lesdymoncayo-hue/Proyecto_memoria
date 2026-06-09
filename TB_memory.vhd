library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_memory is
end TB_memory;

architecture Behavioral of TB_memory is

    component memory
        Port (
            address    : in  STD_LOGIC_VECTOR(7 downto 0);
            data_in    : in  STD_LOGIC_VECTOR(7 downto 0);
            writee     : in  STD_LOGIC;
            clock      : in  STD_LOGIC;
            reset      : in  STD_LOGIC;
            port_in_xx : in  STD_LOGIC_VECTOR(7 downto 0);
            data_out   : out STD_LOGIC_VECTOR(7 downto 0);
            port_out_xx: out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    signal address    : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal data_in    : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal writee     : STD_LOGIC := '0';
    signal clock      : STD_LOGIC := '0';
    signal reset      : STD_LOGIC := '1';
    signal port_in_xx : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal data_out   : STD_LOGIC_VECTOR(7 downto 0);
    signal port_out_xx: STD_LOGIC_VECTOR(7 downto 0);

begin

    clock <= not clock after 5 ns;

    DUT: memory port map(
        address     => address,
        data_in     => data_in,
        writee      => writee,
        clock       => clock,
        reset       => reset,
        port_in_xx  => port_in_xx,
        data_out    => data_out,
        port_out_xx => port_out_xx
    );

    STIMULUS: process
    begin
        -- Reset inicial
        reset   <= '1';
        address <= "01000000";  -- dirección neutral
        wait for 50 ns;
        reset   <= '0';
        wait for 40 ns;

        -- PRUEBA 1: ESCRIBIR en RAM
        -- Esperado: RAM guarda 0xAB
        address <= "10000000";
        data_in <= x"AB";
        writee  <= '1';
        wait for 40 ns;
        writee  <= '0';
        wait for 40 ns;

        -- PRUEBA 2: LEER de RAM
        -- Esperado: data_out = 0xAB
        address <= "10000000";
        writee  <= '0';
        wait for 40 ns;

        -- PRUEBA 3: LEER de ROM
        -- Esperado: data_out = 0xA1
        address <= "00000000";
        writee  <= '0';
        wait for 40 ns;

        -- PRUEBA 4: PUERTO SALIDA
        -- Esperado: port_out_xx = 0xFF
        address <= "11000000";
        data_in <= x"FF";
        writee  <= '1';
        wait for 40 ns;
        writee  <= '0';
        wait for 80 ns;

        -- PRUEBA 5: PUERTO ENTRADA
        -- Esperado: data_out = 0x55
        port_in_xx <= x"55";
        address    <= "11000000";
        wait for 80 ns;

        wait;
    end process;

end Behavioral;