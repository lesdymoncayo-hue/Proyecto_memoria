library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity output_port is
    Port (
        address  : in  STD_LOGIC_VECTOR(6 downto 0);
        data_in  : in  STD_LOGIC_VECTOR(7 downto 0);
        writee    : in  STD_LOGIC;
        clock    : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        port_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end output_port;

architecture salida_arch of output_port is
begin
    process(clock, reset)
    begin
        if reset = '1' then
            port_out <= (others => '0');
        elsif rising_edge(clock) then
            if writee = '1' and address = "1000000" then
                port_out <= data_in;
            end if;
        end if;
    end process;
end salida_arch;