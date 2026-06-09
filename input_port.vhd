library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity input_port is
    Port (
        port_in  : in  STD_LOGIC_VECTOR(7 downto 0);
        data_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end input_port;

architecture entrada_arch of input_port is
begin
    data_out <= port_in;
end entrada_arch;