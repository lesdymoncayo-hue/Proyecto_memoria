library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rw_96x8_sync is
    Port (
        address  : in  STD_LOGIC_VECTOR(6 downto 0);
        data_in  : in  STD_LOGIC_VECTOR(7 downto 0);
        writee    : in  STD_LOGIC;
        clock    : in  STD_LOGIC;
        data_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end rw_96x8_sync;

architecture ram_arch of rw_96x8_sync is
    type ram_type is array (0 to 95) of STD_LOGIC_VECTOR(7 downto 0);
    signal RAM : ram_type := (others => (others => '0'));
begin
    process(clock)
    begin
        if rising_edge(clock) then
            if writee = '1' then
                RAM(to_integer(unsigned(address))) <= data_in;
            end if;
            data_out <= RAM(to_integer(unsigned(address)));
        end if;
    end process;
end ram_arch;