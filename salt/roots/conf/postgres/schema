--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: beacons; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE beacons (
    id integer NOT NULL,
    beacon_identifier character varying(1000) NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.beacons OWNER TO postgres;

--
-- Name: beacons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE beacons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.beacons_id_seq OWNER TO postgres;

--
-- Name: beacons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE beacons_id_seq OWNED BY beacons.id;


--
-- Name: beacons_printers; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE beacons_printers (
    id integer NOT NULL,
    printer_id integer NOT NULL,
    beacon_id integer NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.beacons_printers OWNER TO postgres;

--
-- Name: beacons_printers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE beacons_printers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.beacons_printers_id_seq OWNER TO postgres;

--
-- Name: beacons_printers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE beacons_printers_id_seq OWNED BY beacons_printers.id;


--
-- Name: printers; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE printers (
    id integer NOT NULL,
    printer_name character varying(1000) NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.printers OWNER TO postgres;

--
-- Name: printers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE printers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.printers_id_seq OWNER TO postgres;

--
-- Name: printers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE printers_id_seq OWNED BY printers.id;


--
-- Name: user_devices; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE user_devices (
    id integer NOT NULL,
    device_id character varying(1000) NOT NULL,
    username character varying(1000) NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    token character varying(1000) NOT NULL,
    domain character varying(1000) NOT NULL
);


ALTER TABLE public.user_devices OWNER TO postgres;

--
-- Name: user_devices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_devices_id_seq OWNER TO postgres;

--
-- Name: user_devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_devices_id_seq OWNED BY user_devices.id;


--
-- Name: vw_beacons_printers; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_beacons_printers AS
    SELECT beacons.beacon_identifier, printers.printer_name FROM ((beacons_printers JOIN beacons ON (((beacons.id = beacons_printers.beacon_id) AND (beacons.is_deleted = false)))) JOIN printers ON (((printers.id = beacons_printers.printer_id) AND (printers.is_deleted = false)))) WHERE (beacons_printers.is_deleted = false);


ALTER TABLE public.vw_beacons_printers OWNER TO postgres;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY beacons ALTER COLUMN id SET DEFAULT nextval('beacons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY beacons_printers ALTER COLUMN id SET DEFAULT nextval('beacons_printers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY printers ALTER COLUMN id SET DEFAULT nextval('printers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_devices ALTER COLUMN id SET DEFAULT nextval('user_devices_id_seq'::regclass);


--
-- Name: beacons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY beacons
    ADD CONSTRAINT beacons_pkey PRIMARY KEY (id);


--
-- Name: beacons_printers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY beacons_printers
    ADD CONSTRAINT beacons_printers_pkey PRIMARY KEY (id);


--
-- Name: printers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY printers
    ADD CONSTRAINT printers_pkey PRIMARY KEY (id);


--
-- Name: user_devices_device_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY user_devices
    ADD CONSTRAINT user_devices_device_id_key UNIQUE (device_id);


--
-- Name: user_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY user_devices
    ADD CONSTRAINT user_devices_pkey PRIMARY KEY (id);


--
-- Name: user_devices_username_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace:
--

CREATE INDEX user_devices_username_idx ON user_devices USING btree (username);


--
-- Name: beacons_printers_beacon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY beacons_printers
    ADD CONSTRAINT beacons_printers_beacon_id_fkey FOREIGN KEY (beacon_id) REFERENCES beacons(id);


--
-- Name: beacons_printers_printer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY beacons_printers
    ADD CONSTRAINT beacons_printers_printer_id_fkey FOREIGN KEY (printer_id) REFERENCES printers(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--
