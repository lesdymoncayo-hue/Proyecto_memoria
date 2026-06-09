library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory is
    Port (
        address    : in  STD_LOGIC_VECTOR(7 downto 0);
        data_in    : in  STD_LOGIC_VECTOR(7 downto 0);
        writee      : in  STD_LOGIC;
        clock      : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        port_in_xx : in  STD_LOGIC_VECTOR(7 downto 0);
        data_out   : out STD_LOGIC_VECTOR(7 downto 0);
        port_out_xx: out STD_LOGIC_VECTOR(7 downto 0)
    );
end memory;

architecture Behavioral of memory is

    signal rom_data  : STD_LOGIC_VECTOR(7 downto 0);
    signal ram_data  : STD_LOGIC_VECTOR(7 downto 0);
    signal port_data : STD_LOGIC_VECTOR(7 downto 0);
    signal mux_sel   : STD_LOGIC_VECTOR(1 downto 0);

    component rom_128x8_sync
        Port (
            address  : in  STD_LOGIC_VECTOR(6 downto 0);
            clock    : in  STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component rw_96x8_sync
        Port (
            address  : in  STD_LOGIC_VECTOR(6 downto 0);
            data_in  : in  STD_LOGIC_VECTOR(7 downto 0);
            writee    : in  STD_LOGIC;
            clock    : in  STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component output_port
        Port (
            address  : in  STD_LOGIC_VECTOR(6 downto 0);
            data_in  : in  STD_LOGIC_VECTOR(7 downto 0);
            writee    : in  STD_LOGIC;
            clock    : in  STD_LOGIC;
            reset    : in  STD_LOGIC;
            port_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component input_port
        Port (
            port_in  : in  STD_LOGIC_VECTOR(7 downto 0);
            data_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

begin

    -- ================================================================
    -- MUX SELECTOR: los 2 bits más significativos de address
    -- deciden qué componente responde
    -- ================================================================
    mux_sel <= address(7 downto 6);
    --
    --  address(7:6) = "00" → ROM  (direcciones 0x00 a 0x3F)
    --  address(7:6) = "10" → RAM  (direcciones 0x80 a 0xBF)
    --  address(7:6) = "11" → Puertos (0xC0 en adelante)

    ROM_INST: rom_128x8_sync
        port map(
            address  => address(6 downto 0),
            clock    => clock,
            data_out => rom_data
        );

    RAM_INST: rw_96x8_sync
        port map(
            address  => address(6 downto 0),
            data_in  => data_in,
            writee    => writee,
            clock    => clock,
            data_out => ram_data
        );

    OUT_PORT: output_port
        port map(
            address  => address(6 downto 0),
            data_in  => data_in,
            writee    => writee,
            clock    => clock,
            reset    => reset,
            port_out => port_out_xx
        );

    IN_PORT: input_port
        port map(
            port_in  => port_in_xx,
            data_out => port_data
        );

    -- ================================================================
    -- MUX: según mux_sel elige qué dato sale por data_out
    -- ================================================================
   -- MUX síncrono con reset
    process(clock, reset)
    begin
        if reset = '1' then
            data_out <= (others => '0');
        elsif rising_edge(clock) then
            case mux_sel is
                when "00"   => data_out <= rom_data;
                when "10"   => data_out <= ram_data;
                when "11"   => data_out <= port_data;
                when others => data_out <= (others => '0');
            end case;
        end if;
    end process;

end Behavioral;