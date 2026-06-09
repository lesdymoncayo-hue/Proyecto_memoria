library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rom_128x8_sync is
    Port (
        address  : in  STD_LOGIC_VECTOR(6 downto 0);
        clock    : in  STD_LOGIC;
        data_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end rom_128x8_sync;

architecture rom_arch of rom_128x8_sync is
    type rom_type is array (0 to 127) of STD_LOGIC_VECTOR(7 downto 0);
    constant ROM : rom_type := (
        0  => x"A1",
        1  => x"3F",
        2  => x"7C",
        3  => x"B2",
        4  => x"09",
        5  => x"F4",
        6  => x"5E",
        7  => x"D8",
        8  => x"12",
        9  => x"6B",
        10 => x"C3",
        11 => x"4A",
        12 => x"E7",
        13 => x"2D",
        14 => x"91",
        15 => x"58",
        others => x"00"
    );
begin
    process(clock)
    begin
        if rising_edge(clock) then
            data_out <= ROM(to_integer(unsigned(address)));
        end if;
    end process;
end rom_arch;