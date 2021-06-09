﻿  
CREATE PARTITION FUNCTION PF_DatePartition (date)       
AS RANGE RIGHT FOR VALUES ('2020-01-01', '2020-02-01', '2020-03-01', '2020-04-01', '2020-05-01', '2020-06-01', '2020-07-01', '2020-08-01'
                          , '2020-09-01', '2020-10-01', '2020-11-01', '2020-12-01', '2021-01-01', '2021-02-01', '2021-03-01', '2021-04-01'
						  , '2021-05-01', '2021-06-01', '2021-07-01', '2021-08-01', '2021-09-01', '2021-10-01', '2021-11-01', '2021-12-01'
						  , '2022-01-01', '2022-02-01', '2022-03-01', '2022-04-01', '2022-05-01', '2022-06-01', '2022-07-01', '2022-08-01'
						  , '2022-09-01', '2022-10-01', '2022-11-01', '2022-12-01', '2023-01-01', '2023-02-01', '2023-03-01', '2023-04-01'
						  , '2023-05-01', '2023-06-01', '2023-07-01', '2023-08-01', '2023-09-01', '2023-10-01', '2023-11-01', '2023-12-01'
						  , '2024-01-01', '2024-02-01', '2024-03-01', '2024-04-01', '2024-05-01', '2024-06-01', '2024-07-01', '2024-08-01'
						  , '2024-09-01', '2024-10-01', '2024-11-01', '2024-12-01', '2025-01-01', '2025-02-01', '2025-03-01', '2025-04-01'
						  , '2025-05-01', '2025-06-01', '2025-07-01', '2025-08-01', '2025-09-01', '2025-10-01', '2025-11-01', '2025-12-01'
						  , '2026-01-01', '2026-02-01', '2026-03-01', '2026-04-01', '2026-05-01', '2026-06-01', '2026-07-01', '2026-08-01'
						  , '2026-09-01', '2026-10-01', '2026-11-01', '2026-12-01', '2027-01-01', '2027-02-01', '2027-03-01', '2027-04-01'
						  , '2027-05-01', '2027-06-01', '2027-07-01', '2027-08-01', '2027-09-01', '2027-10-01', '2027-11-01', '2027-12-01'
						  , '2028-01-01', '2028-02-01', '2028-03-01', '2028-04-01', '2028-05-01', '2028-06-01', '2028-07-01', '2028-08-01'
						  , '2028-09-01', '2028-10-01', '2028-11-01', '2028-12-01', '2029-01-01', '2029-02-01', '2029-03-01', '2029-04-01'
						  , '2029-05-01', '2029-06-01', '2029-07-01', '2029-08-01', '2029-09-01', '2029-10-01', '2029-11-01', '2029-12-01'
						  , '2030-01-01', '2030-02-01', '2030-03-01', '2030-04-01', '2030-05-01', '2030-06-01', '2030-07-01', '2030-08-01'
						  , '2030-09-01', '2030-10-01', '2030-11-01', '2030-12-01', '2031-01-01', '2031-02-01', '2031-03-01', '2031-04-01'
						  , '2031-05-01', '2031-06-01', '2031-07-01', '2031-08-01', '2031-09-01', '2031-10-01', '2031-11-01', '2031-12-01'
						  , '2032-01-01', '2032-02-01', '2032-03-01', '2032-04-01', '2032-05-01', '2032-06-01', '2032-07-01', '2032-08-01'
						  , '2032-09-01', '2032-10-01', '2032-11-01', '2032-12-01', '2033-01-01', '2033-02-01', '2033-03-01', '2033-04-01'
						  , '2033-05-01', '2033-06-01', '2033-07-01', '2033-08-01', '2033-09-01', '2033-10-01', '2033-11-01', '2033-12-01', '2034-01-01', '2034-02-01', '2034-03-01', '2034-04-01', '2034-05-01', '2034-06-01', '2034-07-01', '2034-08-01', '2034-09-01', '2034-10-01', '2034-11-01', '2034-12-01', '2035-01-01', '2035-02-01', '2035-03-01', '2035-04-01', '2035-05-01', '2035-06-01', '2035-07-01', '2035-08-01', '2035-09-01', '2035-10-01', '2035-11-01', '2035-12-01', '2036-01-01', '2036-02-01', '2036-03-01', '2036-04-01', '2036-05-01', '2036-06-01', '2036-07-01', '2036-08-01', '2036-09-01', '2036-10-01', '2036-11-01', '2036-12-01', '2037-01-01', '2037-02-01', '2037-03-01', '2037-04-01', '2037-05-01', '2037-06-01', '2037-07-01', '2037-08-01', '2037-09-01', '2037-10-01', '2037-11-01', '2037-12-01', '2038-01-01', '2038-02-01', '2038-03-01', '2038-04-01', '2038-05-01', '2038-06-01', '2038-07-01', '2038-08-01', '2038-09-01', '2038-10-01', '2038-11-01', '2038-12-01', '2039-01-01', '2039-02-01', '2039-03-01', '2039-04-01', '2039-05-01', '2039-06-01', '2039-07-01', '2039-08-01', '2039-09-01', '2039-10-01', '2039-11-01', '2039-12-01', '2040-01-01', '2040-02-01', '2040-03-01', '2040-04-01', '2040-05-01', '2040-06-01', '2040-07-01', '2040-08-01', '2040-09-01', '2040-10-01', '2040-11-01', '2040-12-01', '2041-01-01', '2041-02-01', '2041-03-01', '2041-04-01', '2041-05-01', '2041-06-01', '2041-07-01', '2041-08-01', '2041-09-01', '2041-10-01', '2041-11-01', '2041-12-01', '2042-01-01', '2042-02-01', '2042-03-01', '2042-04-01', '2042-05-01', '2042-06-01', '2042-07-01', '2042-08-01', '2042-09-01', '2042-10-01', '2042-11-01', '2042-12-01', '2043-01-01', '2043-02-01', '2043-03-01', '2043-04-01', '2043-05-01', '2043-06-01', '2043-07-01', '2043-08-01', '2043-09-01', '2043-10-01', '2043-11-01', '2043-12-01', '2044-01-01', '2044-02-01', '2044-03-01', '2044-04-01', '2044-05-01', '2044-06-01', '2044-07-01', '2044-08-01', '2044-09-01', '2044-10-01', '2044-11-01', '2044-12-01', '2045-01-01', '2045-02-01', '2045-03-01', '2045-04-01', '2045-05-01', '2045-06-01', '2045-07-01', '2045-08-01', '2045-09-01', '2045-10-01', '2045-11-01', '2045-12-01', '2046-01-01', '2046-02-01', '2046-03-01', '2046-04-01', '2046-05-01', '2046-06-01', '2046-07-01', '2046-08-01', '2046-09-01', '2046-10-01', '2046-11-01', '2046-12-01', '2047-01-01', '2047-02-01', '2047-03-01', '2047-04-01', '2047-05-01', '2047-06-01', '2047-07-01', '2047-08-01', '2047-09-01', '2047-10-01', '2047-11-01', '2047-12-01', '2048-01-01', '2048-02-01', '2048-03-01', '2048-04-01', '2048-05-01', '2048-06-01', '2048-07-01', '2048-08-01', '2048-09-01', '2048-10-01', '2048-11-01', '2048-12-01', '2049-01-01', '2049-02-01', '2049-03-01', '2049-04-01', '2049-05-01', '2049-06-01', '2049-07-01', '2049-08-01', '2049-09-01', '2049-10-01', '2049-11-01', '2049-12-01', '2050-01-01', '2050-02-01', '2050-03-01', '2050-04-01', '2050-05-01', '2050-06-01', '2050-07-01', '2050-08-01', '2050-09-01', '2050-10-01', '2050-11-01', '2050-12-01', '2051-01-01', '2051-02-01', '2051-03-01', '2051-04-01', '2051-05-01', '2051-06-01', '2051-07-01', '2051-08-01', '2051-09-01', '2051-10-01', '2051-11-01', '2051-12-01', '2052-01-01', '2052-02-01', '2052-03-01', '2052-04-01', '2052-05-01', '2052-06-01', '2052-07-01', '2052-08-01', '2052-09-01', '2052-10-01', '2052-11-01', '2052-12-01', '2053-01-01', '2053-02-01', '2053-03-01', '2053-04-01', '2053-05-01', '2053-06-01', '2053-07-01', '2053-08-01', '2053-09-01', '2053-10-01', '2053-11-01', '2053-12-01', '2054-01-01', '2054-02-01', '2054-03-01', '2054-04-01', '2054-05-01', '2054-06-01', '2054-07-01', '2054-08-01', '2054-09-01', '2054-10-01', '2054-11-01', '2054-12-01', '2055-01-01', '2055-02-01', '2055-03-01', '2055-04-01', '2055-05-01', '2055-06-01', '2055-07-01', '2055-08-01', '2055-09-01', '2055-10-01', '2055-11-01', '2055-12-01', '2056-01-01', '2056-02-01', '2056-03-01', '2056-04-01', '2056-05-01', '2056-06-01', '2056-07-01', '2056-08-01', '2056-09-01', '2056-10-01', '2056-11-01', '2056-12-01', '2057-01-01', '2057-02-01', '2057-03-01', '2057-04-01', '2057-05-01', '2057-06-01', '2057-07-01', '2057-08-01', '2057-09-01', '2057-10-01', '2057-11-01', '2057-12-01', '2058-01-01', '2058-02-01', '2058-03-01', '2058-04-01', '2058-05-01', '2058-06-01', '2058-07-01', '2058-08-01', '2058-09-01', '2058-10-01', '2058-11-01', '2058-12-01', '2059-01-01', '2059-02-01', '2059-03-01', '2059-04-01', '2059-05-01', '2059-06-01', '2059-07-01', '2059-08-01', '2059-09-01', '2059-10-01', '2059-11-01', '2059-12-01', '2060-01-01', '2060-02-01', '2060-03-01', '2060-04-01', '2060-05-01', '2060-06-01', '2060-07-01', '2060-08-01', '2060-09-01', '2060-10-01', '2060-11-01', '2060-12-01', '2061-01-01', '2061-02-01', '2061-03-01', '2061-04-01', '2061-05-01', '2061-06-01', '2061-07-01', '2061-08-01', '2061-09-01', '2061-10-01', '2061-11-01', '2061-12-01', '2062-01-01', '2062-02-01', '2062-03-01', '2062-04-01', '2062-05-01', '2062-06-01', '2062-07-01', '2062-08-01', '2062-09-01', '2062-10-01', '2062-11-01', '2062-12-01', '2063-01-01', '2063-02-01', '2063-03-01', '2063-04-01', '2063-05-01', '2063-06-01', '2063-07-01', '2063-08-01', '2063-09-01', '2063-10-01', '2063-11-01', '2063-12-01', '2064-01-01', '2064-02-01', '2064-03-01', '2064-04-01', '2064-05-01', '2064-06-01', '2064-07-01', '2064-08-01', '2064-09-01', '2064-10-01', '2064-11-01', '2064-12-01', '2065-01-01', '2065-02-01', '2065-03-01', '2065-04-01', '2065-05-01', '2065-06-01', '2065-07-01', '2065-08-01', '2065-09-01', '2065-10-01', '2065-11-01', '2065-12-01', '2066-01-01', '2066-02-01', '2066-03-01', '2066-04-01', '2066-05-01', '2066-06-01', '2066-07-01', '2066-08-01', '2066-09-01', '2066-10-01', '2066-11-01', '2066-12-01', '2067-01-01', '2067-02-01', '2067-03-01', '2067-04-01', '2067-05-01', '2067-06-01', '2067-07-01', '2067-08-01', '2067-09-01', '2067-10-01', '2067-11-01', '2067-12-01', '2068-01-01', '2068-02-01', '2068-03-01', '2068-04-01', '2068-05-01', '2068-06-01', '2068-07-01', '2068-08-01', '2068-09-01', '2068-10-01', '2068-11-01', '2068-12-01', '2069-01-01', '2069-02-01', '2069-03-01', '2069-04-01', '2069-05-01', '2069-06-01', '2069-07-01', '2069-08-01', '2069-09-01', '2069-10-01', '2069-11-01', '2069-12-01', '2070-01-01', '2070-02-01', '2070-03-01', '2070-04-01', '2070-05-01', '2070-06-01', '2070-07-01', '2070-08-01', '2070-09-01', '2070-10-01', '2070-11-01', '2070-12-01', '2071-01-01', '2071-02-01', '2071-03-01', '2071-04-01', '2071-05-01', '2071-06-01', '2071-07-01', '2071-08-01', '2071-09-01', '2071-10-01', '2071-11-01', '2071-12-01', '2072-01-01', '2072-02-01', '2072-03-01', '2072-04-01', '2072-05-01', '2072-06-01', '2072-07-01', '2072-08-01', '2072-09-01', '2072-10-01', '2072-11-01', '2072-12-01', '2073-01-01', '2073-02-01', '2073-03-01', '2073-04-01', '2073-05-01', '2073-06-01', '2073-07-01', '2073-08-01', '2073-09-01', '2073-10-01', '2073-11-01', '2073-12-01', '2074-01-01', '2074-02-01', '2074-03-01', '2074-04-01', '2074-05-01', '2074-06-01', '2074-07-01', '2074-08-01', '2074-09-01', '2074-10-01', '2074-11-01', '2074-12-01', '2075-01-01', '2075-02-01', '2075-03-01', '2075-04-01', '2075-05-01', '2075-06-01', '2075-07-01', '2075-08-01', '2075-09-01', '2075-10-01', '2075-11-01', '2075-12-01', '2076-01-01', '2076-02-01', '2076-03-01', '2076-04-01', '2076-05-01', '2076-06-01', '2076-07-01', '2076-08-01', '2076-09-01', '2076-10-01', '2076-11-01', '2076-12-01', '2077-01-01', '2077-02-01', '2077-03-01', '2077-04-01', '2077-05-01', '2077-06-01', '2077-07-01', '2077-08-01', '2077-09-01', '2077-10-01', '2077-11-01', '2077-12-01', '2078-01-01', '2078-02-01', '2078-03-01', '2078-04-01', '2078-05-01', '2078-06-01', '2078-07-01', '2078-08-01', '2078-09-01', '2078-10-01', '2078-11-01', '2078-12-01', '2079-01-01', '2079-02-01', '2079-03-01', '2079-04-01', '2079-05-01', '2079-06-01', '2079-07-01', '2079-08-01', '2079-09-01', '2079-10-01', '2079-11-01', '2079-12-01', '2080-01-01', '2080-02-01', '2080-03-01', '2080-04-01', '2080-05-01', '2080-06-01', '2080-07-01', '2080-08-01', '2080-09-01', '2080-10-01', '2080-11-01', '2080-12-01', '2081-01-01', '2081-02-01', '2081-03-01', '2081-04-01', '2081-05-01', '2081-06-01', '2081-07-01', '2081-08-01', '2081-09-01', '2081-10-01', '2081-11-01', '2081-12-01', '2082-01-01', '2082-02-01', '2082-03-01', '2082-04-01', '2082-05-01', '2082-06-01', '2082-07-01', '2082-08-01', '2082-09-01', '2082-10-01', '2082-11-01', '2082-12-01', '2083-01-01', '2083-02-01', '2083-03-01', '2083-04-01', '2083-05-01', '2083-06-01', '2083-07-01', '2083-08-01', '2083-09-01', '2083-10-01', '2083-11-01', '2083-12-01', '2084-01-01', '2084-02-01', '2084-03-01', '2084-04-01', '2084-05-01', '2084-06-01', '2084-07-01', '2084-08-01', '2084-09-01', '2084-10-01', '2084-11-01', '2084-12-01', '2085-01-01', '2085-02-01', '2085-03-01', '2085-04-01', '2085-05-01', '2085-06-01', '2085-07-01', '2085-08-01', '2085-09-01', '2085-10-01', '2085-11-01', '2085-12-01', '2086-01-01', '2086-02-01', '2086-03-01', '2086-04-01', '2086-05-01', '2086-06-01', '2086-07-01', '2086-08-01', '2086-09-01', '2086-10-01', '2086-11-01', '2086-12-01', '2087-01-01', '2087-02-01', '2087-03-01', '2087-04-01', '2087-05-01', '2087-06-01', '2087-07-01', '2087-08-01', '2087-09-01', '2087-10-01', '2087-11-01', '2087-12-01', '2088-01-01', '2088-02-01', '2088-03-01', '2088-04-01', '2088-05-01', '2088-06-01', '2088-07-01', '2088-08-01', '2088-09-01', '2088-10-01', '2088-11-01', '2088-12-01', '2089-01-01', '2089-02-01', '2089-03-01', '2089-04-01', '2089-05-01', '2089-06-01', '2089-07-01', '2089-08-01', '2089-09-01', '2089-10-01', '2089-11-01', '2089-12-01', '2090-01-01', '2090-02-01', '2090-03-01', '2090-04-01', '2090-05-01', '2090-06-01', '2090-07-01', '2090-08-01', '2090-09-01', '2090-10-01', '2090-11-01', '2090-12-01', '2091-01-01', '2091-02-01', '2091-03-01', '2091-04-01', '2091-05-01', '2091-06-01', '2091-07-01', '2091-08-01', '2091-09-01', '2091-10-01', '2091-11-01', '2091-12-01', '2092-01-01', '2092-02-01', '2092-03-01', '2092-04-01', '2092-05-01', '2092-06-01', '2092-07-01', '2092-08-01', '2092-09-01', '2092-10-01', '2092-11-01', '2092-12-01', '2093-01-01', '2093-02-01', '2093-03-01', '2093-04-01', '2093-05-01', '2093-06-01', '2093-07-01', '2093-08-01', '2093-09-01', '2093-10-01', '2093-11-01', '2093-12-01', '2094-01-01', '2094-02-01', '2094-03-01', '2094-04-01', '2094-05-01', '2094-06-01', '2094-07-01', '2094-08-01', '2094-09-01', '2094-10-01', '2094-11-01', '2094-12-01', '2095-01-01', '2095-02-01', '2095-03-01', '2095-04-01', '2095-05-01', '2095-06-01', '2095-07-01', '2095-08-01', '2095-09-01', '2095-10-01', '2095-11-01', '2095-12-01', '2096-01-01', '2096-02-01', '2096-03-01', '2096-04-01', '2096-05-01', '2096-06-01', '2096-07-01', '2096-08-01', '2096-09-01', '2096-10-01', '2096-11-01', '2096-12-01', '2097-01-01', '2097-02-01', '2097-03-01', '2097-04-01', '2097-05-01', '2097-06-01', '2097-07-01', '2097-08-01', '2097-09-01', '2097-10-01', '2097-11-01', '2097-12-01', '2098-01-01', '2098-02-01', '2098-03-01', '2098-04-01', '2098-05-01', '2098-06-01', '2098-07-01', '2098-08-01', '2098-09-01', '2098-10-01', '2098-11-01', '2098-12-01', '2099-01-01', '2099-02-01', '2099-03-01', '2099-04-01', '2099-05-01', '2099-06-01', '2099-07-01', '2099-08-01', '2099-09-01', '2099-10-01', '2099-11-01', '2099-12-01', '2100-01-01');
go

CREATE PARTITION SCHEME PS_DatePartition 
AS PARTITION PF_DatePartition
ALL TO ([PRIMARY]);
go