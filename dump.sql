--
-- PostgreSQL database dump
--

\restrict Kd2J3rbigwj8Se8c8f2b0RGOJoc5dxOUCSOTE7qn55iAkP6lrpJvEEJ01cqBKYt

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: brand; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.brand (
    id integer NOT NULL,
    manufacturer_id integer NOT NULL,
    name character varying(100) NOT NULL,
    founded_year integer
);


--
-- Name: brand_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.brand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: brand_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.brand_id_seq OWNED BY public.brand.id;


--
-- Name: manufacturer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.manufacturer (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    founded_year integer,
    headquarters_country character varying(100),
    est_value numeric(10,2),
    industry character varying(50),
    headquarters_city character varying(100),
    is_public boolean
);


--
-- Name: revenue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.revenue (
    id integer NOT NULL,
    manufacturer_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    year integer NOT NULL
);


--
-- Name: csv_export; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.csv_export AS
 SELECT m.name,
    m.founded_year,
    m.headquarters_country,
    m.headquarters_city,
    m.est_value,
    m.industry,
    (m.is_public)::text AS is_public,
    r.amount AS revenue_amount,
    r.year AS revenue_year,
    b.name AS brand_name,
    b.founded_year AS brand_founded
   FROM ((public.manufacturer m
     JOIN public.brand b ON ((b.manufacturer_id = m.id)))
     JOIN LATERAL ( SELECT revenue.amount,
            revenue.year
           FROM public.revenue
          WHERE (revenue.manufacturer_id = m.id)
          ORDER BY revenue.year DESC) r ON (true))
  ORDER BY m.name, b.name, r.year;


--
-- Name: json_export; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.json_export AS
 SELECT json_agg(json_build_object('name', name, 'founded_year', founded_year, 'headquarters_country', headquarters_country, 'headquarters_city', headquarters_city, 'est_value', est_value, 'industry', industry, 'is_public', is_public, 'revenue', ( SELECT json_agg(json_build_object('amount', r.amount, 'year', r.year) ORDER BY r.year) AS json_agg
           FROM public.revenue r
          WHERE (r.manufacturer_id = m.id)), 'brands', ( SELECT json_agg(json_build_object('name', b.name, 'founded', b.founded_year) ORDER BY b.name) AS json_agg
           FROM public.brand b
          WHERE (b.manufacturer_id = m.id))) ORDER BY id) AS data
   FROM public.manufacturer m;


--
-- Name: manufacturer_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.manufacturer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: manufacturer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.manufacturer_id_seq OWNED BY public.manufacturer.id;


--
-- Name: revenue_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.revenue_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: revenue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.revenue_id_seq OWNED BY public.revenue.id;


--
-- Name: brand id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brand ALTER COLUMN id SET DEFAULT nextval('public.brand_id_seq'::regclass);


--
-- Name: manufacturer id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturer ALTER COLUMN id SET DEFAULT nextval('public.manufacturer_id_seq'::regclass);


--
-- Name: revenue id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revenue ALTER COLUMN id SET DEFAULT nextval('public.revenue_id_seq'::regclass);


--
-- Data for Name: brand; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.brand (id, manufacturer_id, name, founded_year) FROM stdin;
1	1	Buick	1899
2	1	Chevrolet	1911
3	1	Cadillac	1902
4	2	Toyota	1937
5	2	Lexus	1989
7	3	Volkswagen	1937
8	3	Porsche	1931
9	3	Audi	1909
10	3	Bentley	1919
11	3	Skoda	1895
12	3	SEAT	1950
13	3	Lamborghini	1963
14	4	Peugeot	1810
15	4	Citroen	1919
16	4	Opel	1862
17	4	Fiat	1899
18	4	Jeep	1941
19	4	Alfa Romeo	1910
20	4	Maserati	1914
21	5	Mercedes-Benz	1926
22	5	Mercedes-AMG	1967
23	5	Mercedes-Maybach	2014
24	6	BMW	1916
25	6	Rolls-Royce	1906
26	6	MINI	1956
27	7	Renault	1899
28	7	Dacia	1966
29	7	Alpine	1955
30	8	Hyundai	1967
31	8	Kia	1944
32	9	Ford	1903
33	9	Lincoln	1917
34	10	Honda	1948
35	10	Acura	1986
36	11	BYD	1995
37	12	Tesla	2003
38	2	Daihatsu	1907
\.


--
-- Data for Name: manufacturer; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.manufacturer (id, name, founded_year, headquarters_country, est_value, industry, headquarters_city, is_public) FROM stdin;
1	General Motors	1908	USA	74.20	Automotive	Detroit	t
2	Toyota	1937	Japan	230.50	Automotive	Toyota City	t
3	Volkswagen	1937	Germany	39.20	Automotive	Wolfsburg	t
4	Stellantis	2021	Netherlands	13.47	Automotive	Amsterdam	t
5	Mercedes-Benz Group	1926	Germany	43.37	Automotive	Stuttgart	t
6	BMW Group	1916	Germany	38.86	Automotive	Munich	t
7	Renault	1899	France	8.98	Automotive	Boulogne-Billancourt	t
8	Hyundai	1967	South Korea	55.99	Automotive	Seoul	t
9	Ford	1903	USA	48.91	Automotive	Dearborn	t
10	Honda	1948	Japan	44.06	Automotive	Tokyo	t
11	BYD	1995	China	111.52	Automotive	Shenzhen	t
12	Tesla	2003	USA	1580.00	Automotive	Austin	t
\.


--
-- Data for Name: revenue; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.revenue (id, manufacturer_id, amount, year) FROM stdin;
1	1	171.84	2023
2	1	187.44	2024
3	1	185.01	2025
11	2	307.60	2023
12	2	305.26	2024
13	2	337.34	2025
44	3	293.17	2022
14	3	350.00	2023
15	3	349.23	2024
50	5	157.66	2022
20	5	166.17	2023
21	5	156.62	2024
53	6	149.68	2022
23	6	168.86	2023
24	6	153.16	2024
26	7	57.89	2023
27	7	58.51	2024
28	7	68.04	2025
29	8	123.54	2023
30	8	127.24	2024
31	8	131.84	2025
7	9	176.19	2023
8	9	184.99	2024
9	9	187.26	2025
35	10	136.48	2023
36	10	142.20	2024
37	10	142.81	2025
68	11	62.17	2022
32	11	84.92	2023
33	11	107.87	2024
4	12	96.77	2023
5	12	97.69	2024
6	12	94.82	2025
74	4	205.14	2023
75	4	169.80	2024
76	4	173.68	2025
\.


--
-- Name: brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.brand_id_seq', 38, true);


--
-- Name: manufacturer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.manufacturer_id_seq', 12, true);


--
-- Name: revenue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.revenue_id_seq', 76, true);


--
-- Name: brand brand_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brand
    ADD CONSTRAINT brand_pkey PRIMARY KEY (id);


--
-- Name: manufacturer manufacturer_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturer
    ADD CONSTRAINT manufacturer_name_key UNIQUE (name);


--
-- Name: manufacturer manufacturer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturer
    ADD CONSTRAINT manufacturer_pkey PRIMARY KEY (id);


--
-- Name: revenue revenue_manufacturer_id_year_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revenue
    ADD CONSTRAINT revenue_manufacturer_id_year_key UNIQUE (manufacturer_id, year);


--
-- Name: revenue revenue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revenue
    ADD CONSTRAINT revenue_pkey PRIMARY KEY (id);


--
-- Name: brand brand_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brand
    ADD CONSTRAINT brand_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.manufacturer(id);


--
-- Name: revenue revenue_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revenue
    ADD CONSTRAINT revenue_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.manufacturer(id);


--
-- PostgreSQL database dump complete
--

\unrestrict Kd2J3rbigwj8Se8c8f2b0RGOJoc5dxOUCSOTE7qn55iAkP6lrpJvEEJ01cqBKYt

