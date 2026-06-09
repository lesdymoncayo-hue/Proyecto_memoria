library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_4 is
    Port (
        A       : in  STD_LOGIC_VECTOR(7 downto 0);
        B       : in  STD_LOGIC_VECTOR(7 downto 0);
        ALU_Sel : in  STD_LOGIC_VECTOR(2 downto 0);
        Result  : out STD_LOGIC_VECTOR(7 downto 0);
        N       : out STD_LOGIC;
        Z       : out STD_LOGIC;
        V       : out STD_LOGIC;
        C       : out STD_LOGIC
    );
end ALU_4;

architecture ALU_ARCH of ALU_4 is
begin

ALU_PROCESS : process(A, B, ALU_Sel)
    variable Res9 : unsigned(8 downto 0);
    variable Av   : unsigned(8 downto 0);
    variable Bv   : unsigned(8 downto 0);
begin
    Av := unsigned('0' & A);
    Bv := unsigned('0' & B);

    Res9 := (others => '0');
    N <= '0'; Z <= '0'; V <= '0'; C <= '0';

    case ALU_Sel is

        -- =============== 4 SUMAS ===============

        when "000" =>  -- SUMA NORMAL: A + B
            Res9 := Av + Bv;
            C <= Res9(8);
            if ((A(7)='0' and B(7)='0' and Res9(7)='1') or
                (A(7)='1' and B(7)='1' and Res9(7)='0')) then
                V <= '1'; N <= '0';
            else
                V <= '0'; N <= Res9(7);
            end if;

        when "010" =>  -- SUMA CON CARRY FORZADO: A + B + 1
            Res9 := Av + Bv + 1;
            C <= Res9(8);
            if ((A(7)='0' and B(7)='0' and Res9(7)='1') or
                (A(7)='1' and B(7)='1' and Res9(7)='0')) then
                V <= '1'; N <= '0';
            else
                V <= '0'; N <= Res9(7);
            end if;

        when "011" =>  -- INCREMENTO: A + 1
            Res9 := Av + 1;
            C <= Res9(8);
            if (A = "01111111") then
                V <= '1'; N <= '0';
            else
                V <= '0'; N <= Res9(7);
            end if;

        when "100" =>  -- SUMA CON B NEGADO: A + (~B)
            Res9 := Av + unsigned('0' & (not B));
            C <= Res9(8);
            if ((A(7)='0' and B(7)='1' and Res9(7)='1') or
                (A(7)='1' and B(7)='0' and Res9(7)='0')) then
                V <= '1'; N <= '0';
            else
                V <= '0'; N <= Res9(7);
            end if;

        -- =============== 4 RESTAS ===============

        when "001" =>  -- RESTA NORMAL: A - B
            Res9 := Av - Bv;
            C <= Res9(8);
            if ((A(7)='0' and B(7)='1' and Res9(7)='1') or
                (A(7)='1' and B(7)='0' and Res9(7)='0')) then
                V <= '1'; N <= '0';
            else
                V <= '0'; N <= Res9(7);
            end if;

        when "101" =>  -- RESTA CON BORROW: A - B - 1
            Res9 := Av - Bv - 1;
            C <= Res9(8);
            if ((A(7)='0' and B(7)='1' and Res9(7)='1') or
                (A(7)='1' and B(7)='0' and Res9(7)='0')) then
                V <= '1'; N <= '0';
            else
                V <= '0'; N <= Res9(7);
            end if;

        when "110" =>  -- DECREMENTO: A - 1
            Res9 := Av - 1;
            C <= Res9(8);
            if (A = "10000000") then
                V <= '1'; N <= '0';
            else
                V <= '0'; N <= Res9(7);
            end if;

        when "111" =>  -- RESTA INVERTIDA: B - A
            Res9 := Bv - Av;
            C <= Res9(8);
            if ((B(7)='0' and A(7)='1' and Res9(7)='1') or
                (B(7)='1' and A(7)='0' and Res9(7)='0')) then
                V <= '1'; N <= '0';
            else
                V <= '0'; N <= Res9(7);
            end if;

        when others =>
            Res9 := (others => '0');

    end case;

    -- Z y Result comunes a todas las operaciones
    Result <= std_logic_vector(Res9(7 downto 0));
    if (Res9(7 downto 0) = "00000000") then
        Z <= '1';
    else
        Z <= '0';
    end if;

end process;

end ALU_ARCH;