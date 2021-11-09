--
-- PostgreSQL database dump
--

-- Dumped from database version 10.18 (Ubuntu 10.18-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.18 (Ubuntu 10.18-0ubuntu0.18.04.1)

-- Started on 2021-11-02 10:52:28 CET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 5056317)
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- TOC entry 1 (class 3079 OID 13039)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 3 (class 3079 OID 5056318)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- TOC entry 2 (class 3079 OID 5057817)
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


--
-- TOC entry 1524 (class 1255 OID 5057958)
-- Name: affine(public.geometry, double precision, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.affine(public.geometry, double precision, double precision, double precision, double precision, double precision, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1,  $2, $3, 0,  $4, $5, 0,  0, 0, 1,  $6, $7, 0)$_$;


ALTER FUNCTION public.affine(public.geometry, double precision, double precision, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1525 (class 1255 OID 5057959)
-- Name: asgml(public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.asgml(public.geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, 15, 0, null, null)$_$;


ALTER FUNCTION public.asgml(public.geometry) OWNER TO postgres;

--
-- TOC entry 1401 (class 1255 OID 5057960)
-- Name: asgml(public.geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.asgml(public.geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, $2, 0, null, null)$_$;


ALTER FUNCTION public.asgml(public.geometry, integer) OWNER TO postgres;

--
-- TOC entry 1402 (class 1255 OID 5057961)
-- Name: askml(public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.askml(public.geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, ST_Transform($1,4326), 15, null)$_$;


ALTER FUNCTION public.askml(public.geometry) OWNER TO postgres;

--
-- TOC entry 1413 (class 1255 OID 5057962)
-- Name: askml(public.geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.askml(public.geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, ST_transform($1,4326), $2, null)$_$;


ALTER FUNCTION public.askml(public.geometry, integer) OWNER TO postgres;

--
-- TOC entry 1414 (class 1255 OID 5057963)
-- Name: askml(integer, public.geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.askml(integer, public.geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, ST_Transform($2,4326), $3, null)$_$;


ALTER FUNCTION public.askml(integer, public.geometry, integer) OWNER TO postgres;

--
-- TOC entry 1438 (class 1255 OID 5057964)
-- Name: bdmpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.bdmpolyfromtext(text, integer) RETURNS public.geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	geomtext alias for $1;
	srid alias for $2;
	mline geometry;
	geom geometry;
BEGIN
	mline := ST_MultiLineStringFromText(geomtext, srid);

	IF mline IS NULL
	THEN
		RAISE EXCEPTION 'Input is not a MultiLinestring';
	END IF;

	geom := ST_Multi(ST_BuildArea(mline));

	RETURN geom;
END;
$_$;


ALTER FUNCTION public.bdmpolyfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1560 (class 1255 OID 5057965)
-- Name: bdpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.bdpolyfromtext(text, integer) RETURNS public.geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	geomtext alias for $1;
	srid alias for $2;
	mline geometry;
	geom geometry;
BEGIN
	mline := ST_MultiLineStringFromText(geomtext, srid);

	IF mline IS NULL
	THEN
		RAISE EXCEPTION 'Input is not a MultiLinestring';
	END IF;

	geom := ST_BuildArea(mline);

	IF GeometryType(geom) != 'POLYGON'
	THEN
		RAISE EXCEPTION 'Input returns more then a single polygon, try using BdMPolyFromText instead';
	END IF;

	RETURN geom;
END;
$_$;


ALTER FUNCTION public.bdpolyfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1561 (class 1255 OID 5057966)
-- Name: buffer(public.geometry, double precision, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.buffer(public.geometry, double precision, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Buffer($1, $2, $3)$_$;


ALTER FUNCTION public.buffer(public.geometry, double precision, integer) OWNER TO postgres;

--
-- TOC entry 1562 (class 1255 OID 5057967)
-- Name: copiacampsversio(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.copiacampsversio(idversio0 character varying, idversio1 character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE sipan_mgeoreferenciacio.toponimversio SET coordenada_x_origen=(SELECT coordenada_x_origen FROM 

sipan_mgeoreferenciacio.toponimversio WHERE id=idVersio0) 		WHERE id=idVersio1;

	UPDATE sipan_mgeoreferenciacio.toponimversio SET coordenada_y_origen=(SELECT coordenada_y_origen FROM 

sipan_mgeoreferenciacio.toponimversio WHERE id=idVersio0) 		WHERE id=idVersio1;

	UPDATE sipan_mgeoreferenciacio.toponimversio SET idrecursgeoref=(SELECT idrecursgeoref FROM 

sipan_mgeoreferenciacio.toponimversio WHERE id=idVersio0) 				WHERE id=idVersio1;

	DELETE FROM sipan_mgeoreferenciacio.toponimversio WHERE id=idVersio0;
END;
$$;


ALTER FUNCTION public.copiacampsversio(idversio0 character varying, idversio1 character varying) OWNER TO postgres;

--
-- TOC entry 1563 (class 1255 OID 5057968)
-- Name: find_extent(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_extent(text, text) RETURNS public.box2d
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	tablename alias for $1;
	columnname alias for $2;
	myrec RECORD;

BEGIN
	FOR myrec IN EXECUTE 'SELECT ST_Extent("' || columnname || '") As extent FROM "' || tablename || '"' LOOP
		return myrec.extent;
	END LOOP;
END;
$_$;


ALTER FUNCTION public.find_extent(text, text) OWNER TO postgres;

--
-- TOC entry 1564 (class 1255 OID 5057969)
-- Name: find_extent(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_extent(text, text, text) RETURNS public.box2d
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	schemaname alias for $1;
	tablename alias for $2;
	columnname alias for $3;
	myrec RECORD;

BEGIN
	FOR myrec IN EXECUTE 'SELECT ST_Extent("' || columnname || '") FROM "' || schemaname || '"."' || tablename || '" As extent ' LOOP
		return myrec.extent;
	END LOOP;
END;
$_$;


ALTER FUNCTION public.find_extent(text, text, text) OWNER TO postgres;

--
-- TOC entry 1565 (class 1255 OID 5057970)
-- Name: fix_geometry_columns(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fix_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	mislinked record;
	result text;
	linked integer;
	deleted integer;
	foundschema integer;
BEGIN

	-- Since 7.3 schema support has been added.
	-- Previous postgis versions used to put the database name in
	-- the schema column. This needs to be fixed, so we try to
	-- set the correct schema for each geometry_colums record
	-- looking at table, column, type and srid.
	
	return 'This function is obsolete now that geometry_columns is a view';

END;
$$;


ALTER FUNCTION public.fix_geometry_columns() OWNER TO postgres;

--
-- TOC entry 1566 (class 1255 OID 5057971)
-- Name: geomcollfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.geomcollfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromText($1)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.geomcollfromtext(text) OWNER TO postgres;

--
-- TOC entry 1567 (class 1255 OID 5057972)
-- Name: geomcollfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.geomcollfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromText($1, $2)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.geomcollfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1568 (class 1255 OID 5057973)
-- Name: geomcollfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.geomcollfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromWKB($1)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.geomcollfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1569 (class 1255 OID 5057974)
-- Name: geomcollfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.geomcollfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromWKB($1, $2)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.geomcollfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1570 (class 1255 OID 5057975)
-- Name: geomfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.geomfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_GeomFromText($1)$_$;


ALTER FUNCTION public.geomfromtext(text) OWNER TO postgres;

--
-- TOC entry 1571 (class 1255 OID 5057976)
-- Name: geomfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.geomfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_GeomFromText($1, $2)$_$;


ALTER FUNCTION public.geomfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1572 (class 1255 OID 5057977)
-- Name: geomfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.geomfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_SetSRID(ST_GeomFromWKB($1), $2)$_$;


ALTER FUNCTION public.geomfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1573 (class 1255 OID 5057978)
-- Name: linefromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.linefromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'LINESTRING'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linefromtext(text) OWNER TO postgres;

--
-- TOC entry 1574 (class 1255 OID 5057979)
-- Name: linefromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.linefromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'LINESTRING'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linefromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1575 (class 1255 OID 5057980)
-- Name: linefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.linefromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'LINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linefromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1576 (class 1255 OID 5057981)
-- Name: linefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.linefromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'LINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linefromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1577 (class 1255 OID 5057982)
-- Name: linestringfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.linestringfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT LineFromText($1)$_$;


ALTER FUNCTION public.linestringfromtext(text) OWNER TO postgres;

--
-- TOC entry 1578 (class 1255 OID 5057983)
-- Name: linestringfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.linestringfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT LineFromText($1, $2)$_$;


ALTER FUNCTION public.linestringfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1579 (class 1255 OID 5057984)
-- Name: linestringfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.linestringfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'LINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linestringfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1580 (class 1255 OID 5057985)
-- Name: linestringfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.linestringfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'LINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linestringfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1581 (class 1255 OID 5057986)
-- Name: locate_along_measure(public.geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.locate_along_measure(public.geometry, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_locate_between_measures($1, $2, $2) $_$;


ALTER FUNCTION public.locate_along_measure(public.geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1582 (class 1255 OID 5057987)
-- Name: mlinefromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mlinefromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTILINESTRING'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mlinefromtext(text) OWNER TO postgres;

--
-- TOC entry 1583 (class 1255 OID 5057988)
-- Name: mlinefromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mlinefromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromText($1, $2)) = 'MULTILINESTRING'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mlinefromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1457 (class 1255 OID 5057989)
-- Name: mlinefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mlinefromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mlinefromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1584 (class 1255 OID 5057990)
-- Name: mlinefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mlinefromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mlinefromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1585 (class 1255 OID 5057991)
-- Name: mpointfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mpointfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTIPOINT'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpointfromtext(text) OWNER TO postgres;

--
-- TOC entry 1586 (class 1255 OID 5057992)
-- Name: mpointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mpointfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1,$2)) = 'MULTIPOINT'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpointfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1587 (class 1255 OID 5057993)
-- Name: mpointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mpointfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOINT'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpointfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1588 (class 1255 OID 5057994)
-- Name: mpointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mpointfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'MULTIPOINT'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpointfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1589 (class 1255 OID 5057995)
-- Name: mpolyfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mpolyfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTIPOLYGON'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpolyfromtext(text) OWNER TO postgres;

--
-- TOC entry 1590 (class 1255 OID 5057996)
-- Name: mpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mpolyfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'MULTIPOLYGON'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpolyfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1591 (class 1255 OID 5057997)
-- Name: mpolyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mpolyfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpolyfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1592 (class 1255 OID 5057998)
-- Name: mpolyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mpolyfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpolyfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1593 (class 1255 OID 5057999)
-- Name: multilinefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multilinefromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multilinefromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1594 (class 1255 OID 5058000)
-- Name: multilinefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multilinefromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multilinefromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1595 (class 1255 OID 5058001)
-- Name: multilinestringfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multilinestringfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_MLineFromText($1)$_$;


ALTER FUNCTION public.multilinestringfromtext(text) OWNER TO postgres;

--
-- TOC entry 1596 (class 1255 OID 5058002)
-- Name: multilinestringfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multilinestringfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MLineFromText($1, $2)$_$;


ALTER FUNCTION public.multilinestringfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1597 (class 1255 OID 5058003)
-- Name: multipointfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multipointfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPointFromText($1)$_$;


ALTER FUNCTION public.multipointfromtext(text) OWNER TO postgres;

--
-- TOC entry 1598 (class 1255 OID 5058004)
-- Name: multipointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multipointfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPointFromText($1, $2)$_$;


ALTER FUNCTION public.multipointfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1599 (class 1255 OID 5058005)
-- Name: multipointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multipointfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOINT'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multipointfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1600 (class 1255 OID 5058006)
-- Name: multipointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multipointfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'MULTIPOINT'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multipointfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1601 (class 1255 OID 5058007)
-- Name: multipolyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multipolyfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multipolyfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1602 (class 1255 OID 5058008)
-- Name: multipolyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multipolyfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multipolyfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1603 (class 1255 OID 5058009)
-- Name: multipolygonfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multipolygonfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPolyFromText($1)$_$;


ALTER FUNCTION public.multipolygonfromtext(text) OWNER TO postgres;

--
-- TOC entry 1604 (class 1255 OID 5058010)
-- Name: multipolygonfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multipolygonfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPolyFromText($1, $2)$_$;


ALTER FUNCTION public.multipolygonfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1605 (class 1255 OID 5058011)
-- Name: pointfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pointfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'POINT'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.pointfromtext(text) OWNER TO postgres;

--
-- TOC entry 1606 (class 1255 OID 5058012)
-- Name: pointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pointfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'POINT'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.pointfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1607 (class 1255 OID 5058013)
-- Name: pointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pointfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POINT'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.pointfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1608 (class 1255 OID 5058014)
-- Name: pointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pointfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'POINT'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.pointfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1609 (class 1255 OID 5058015)
-- Name: polyfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.polyfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'POLYGON'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polyfromtext(text) OWNER TO postgres;

--
-- TOC entry 1610 (class 1255 OID 5058016)
-- Name: polyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.polyfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'POLYGON'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polyfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1611 (class 1255 OID 5058017)
-- Name: polyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.polyfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polyfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1612 (class 1255 OID 5058018)
-- Name: polyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.polyfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'POLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polyfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1613 (class 1255 OID 5058019)
-- Name: polygonfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.polygonfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT PolyFromText($1)$_$;


ALTER FUNCTION public.polygonfromtext(text) OWNER TO postgres;

--
-- TOC entry 1614 (class 1255 OID 5058020)
-- Name: polygonfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.polygonfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT PolyFromText($1, $2)$_$;


ALTER FUNCTION public.polygonfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1615 (class 1255 OID 5058021)
-- Name: polygonfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.polygonfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polygonfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1616 (class 1255 OID 5058022)
-- Name: polygonfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.polygonfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'POLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polygonfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1617 (class 1255 OID 5058023)
-- Name: probe_geometry_columns(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.probe_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	inserted integer;
	oldcount integer;
	probed integer;
	stale integer;
BEGIN


	RETURN 'This function is obsolete now that geometry_columns is a view';
END

$$;


ALTER FUNCTION public.probe_geometry_columns() OWNER TO postgres;

--
-- TOC entry 1618 (class 1255 OID 5058024)
-- Name: processar(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.processar(codi character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	CASE codi WHEN '08006','08029','17032','08035','08040','08110','MARINELAND','08121','08126','08163','08172','17152','08197','08235','08264','43002','29028','08219','08118','RICA ESTAN','TANC LLACU','ENCA LLACU' THEN
		RETURN FALSE;
	ELSE
		RETURN TRUE;
	END CASE;	
END;
$$;


ALTER FUNCTION public.processar(codi character varying) OWNER TO postgres;

--
-- TOC entry 1619 (class 1255 OID 5058025)
-- Name: recorrefiles(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.recorrefiles() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	mviews RECORD;
	id0 character varying(200);
	id1 character varying(200);
BEGIN	
	FOR mviews in SELECT nom, codi, count(nom), count(codi) FROM SIPAN_MGEOREFERENCIACIO.TOPONIMVERSIO WHERE codi is not 

null GROUP BY nom,codi HAVING count(nom) >= 2 ORDER BY count(nom) DESC,nom
	LOOP
		RAISE INFO '%', mviews.nom;
		IF processar(mviews.codi) THEN
			id0:=(SELECT ID FROM SIPAN_MGEOREFERENCIACIO.TOPONIMVERSIO WHERE nom=mviews.nom AND codi=mviews.codi AND numero_versio=0);
			id1:=(SELECT ID FROM SIPAN_MGEOREFERENCIACIO.TOPONIMVERSIO WHERE nom=mviews.nom AND codi=mviews.codi AND numero_versio=1);		
			PERFORM copiaCampsVersio(id0,id1);
		END IF;
	END LOOP;
END;
$$;


ALTER FUNCTION public.recorrefiles() OWNER TO postgres;

--
-- TOC entry 1620 (class 1255 OID 5058026)
-- Name: rename_geometry_table_constraints(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rename_geometry_table_constraints() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT 'rename_geometry_table_constraint() is obsoleted'::text
$$;


ALTER FUNCTION public.rename_geometry_table_constraints() OWNER TO postgres;

--
-- TOC entry 1621 (class 1255 OID 5058027)
-- Name: rotate(public.geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rotate(public.geometry, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_rotateZ($1, $2)$_$;


ALTER FUNCTION public.rotate(public.geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1622 (class 1255 OID 5058028)
-- Name: rotatex(public.geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rotatex(public.geometry, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1, 1, 0, 0, 0, cos($2), -sin($2), 0, sin($2), cos($2), 0, 0, 0)$_$;


ALTER FUNCTION public.rotatex(public.geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1623 (class 1255 OID 5058029)
-- Name: rotatey(public.geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rotatey(public.geometry, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1,  cos($2), 0, sin($2),  0, 1, 0,  -sin($2), 0, cos($2), 0,  0, 0)$_$;


ALTER FUNCTION public.rotatey(public.geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1624 (class 1255 OID 5058030)
-- Name: rotatez(public.geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rotatez(public.geometry, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1,  cos($2), -sin($2), 0,  sin($2), cos($2), 0,  0, 0, 1,  0, 0, 0)$_$;


ALTER FUNCTION public.rotatez(public.geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1625 (class 1255 OID 5058031)
-- Name: scale(public.geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.scale(public.geometry, double precision, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_scale($1, $2, $3, 1)$_$;


ALTER FUNCTION public.scale(public.geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1626 (class 1255 OID 5058032)
-- Name: scale(public.geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.scale(public.geometry, double precision, double precision, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1,  $2, 0, 0,  0, $3, 0,  0, 0, $4,  0, 0, 0)$_$;


ALTER FUNCTION public.scale(public.geometry, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1627 (class 1255 OID 5058033)
-- Name: se_envelopesintersect(public.geometry, public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.se_envelopesintersect(public.geometry, public.geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ 
	SELECT $1 && $2
	$_$;


ALTER FUNCTION public.se_envelopesintersect(public.geometry, public.geometry) OWNER TO postgres;

--
-- TOC entry 1628 (class 1255 OID 5058034)
-- Name: se_locatealong(public.geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.se_locatealong(public.geometry, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT SE_LocateBetween($1, $2, $2) $_$;


ALTER FUNCTION public.se_locatealong(public.geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1629 (class 1255 OID 5058035)
-- Name: snaptogrid(public.geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.snaptogrid(public.geometry, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_SnapToGrid($1, 0, 0, $2, $2)$_$;


ALTER FUNCTION public.snaptogrid(public.geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1630 (class 1255 OID 5058036)
-- Name: snaptogrid(public.geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.snaptogrid(public.geometry, double precision, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_SnapToGrid($1, 0, 0, $2, $3)$_$;


ALTER FUNCTION public.snaptogrid(public.geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1631 (class 1255 OID 5058037)
-- Name: st_asbinary(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.st_asbinary(text) RETURNS bytea
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsBinary($1::geometry);$_$;


ALTER FUNCTION public.st_asbinary(text) OWNER TO postgres;

--
-- TOC entry 1632 (class 1255 OID 5058038)
-- Name: st_astext(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.st_astext(bytea) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsText($1::geometry);$_$;


ALTER FUNCTION public.st_astext(bytea) OWNER TO postgres;

--
-- TOC entry 1633 (class 1255 OID 5058039)
-- Name: translate(public.geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.translate(public.geometry, double precision, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_translate($1, $2, $3, 0)$_$;


ALTER FUNCTION public.translate(public.geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1634 (class 1255 OID 5058040)
-- Name: translate(public.geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.translate(public.geometry, double precision, double precision, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1, 1, 0, 0, 0, 1, 0, 0, 0, 1, $2, $3, $4)$_$;


ALTER FUNCTION public.translate(public.geometry, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1635 (class 1255 OID 5058041)
-- Name: transscale(public.geometry, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.transscale(public.geometry, double precision, double precision, double precision, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1,  $4, 0, 0,  0, $5, 0,
		0, 0, 1,  $2 * $4, $3 * $5, 0)$_$;


ALTER FUNCTION public.transscale(public.geometry, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1636 (class 1255 OID 5058042)
-- Name: utmzone(public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.utmzone(public.geometry) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
 DECLARE
     geomgeog geometry;
     zone int;
     pref int;

 BEGIN
     geomgeog:= ST_Transform($1,4326);

     IF (ST_Y(geomgeog))>0 THEN
        pref:=32600;
     ELSE
        pref:=32700;
     END IF;

     zone:=floor((ST_X(geomgeog)+180)/6)+1;

     RETURN zone+pref;
 END;
 $_$;


ALTER FUNCTION public.utmzone(public.geometry) OWNER TO postgres;

--
-- TOC entry 1637 (class 1255 OID 5058043)
-- Name: within(public.geometry, public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.within(public.geometry, public.geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Within($1, $2)$_$;


ALTER FUNCTION public.within(public.geometry, public.geometry) OWNER TO postgres;

--
-- TOC entry 2308 (class 1255 OID 5058044)
-- Name: accum(public.geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE public.accum(public.geometry) (
    SFUNC = public.pgis_geometry_accum_transfn,
    STYPE = public.pgis_abs,
    FINALFUNC = public.pgis_geometry_accum_finalfn
);


ALTER AGGREGATE public.accum(public.geometry) OWNER TO postgres;

--
-- TOC entry 2309 (class 1255 OID 5058045)
-- Name: extent(public.geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE public.extent(public.geometry) (
    SFUNC = public.st_combine_bbox,
    STYPE = public.box3d,
    FINALFUNC = public.box2d
);


ALTER AGGREGATE public.extent(public.geometry) OWNER TO postgres;

--
-- TOC entry 2310 (class 1255 OID 5058046)
-- Name: makeline(public.geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE public.makeline(public.geometry) (
    SFUNC = public.pgis_geometry_accum_transfn,
    STYPE = public.pgis_abs,
    FINALFUNC = public.pgis_geometry_makeline_finalfn
);


ALTER AGGREGATE public.makeline(public.geometry) OWNER TO postgres;

--
-- TOC entry 2311 (class 1255 OID 5058047)
-- Name: memcollect(public.geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE public.memcollect(public.geometry) (
    SFUNC = public.st_collect,
    STYPE = public.geometry
);


ALTER AGGREGATE public.memcollect(public.geometry) OWNER TO postgres;

--
-- TOC entry 2312 (class 1255 OID 5058048)
-- Name: st_extent3d(public.geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE public.st_extent3d(public.geometry) (
    SFUNC = public.st_combine_bbox,
    STYPE = public.box3d
);


ALTER AGGREGATE public.st_extent3d(public.geometry) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 220 (class 1259 OID 5058049)
-- Name: auth_group; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO aplicacio_georef;

--
-- TOC entry 221 (class 1259 OID 5058052)
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO aplicacio_georef;

--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 221
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- TOC entry 222 (class 1259 OID 5058054)
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO aplicacio_georef;

--
-- TOC entry 223 (class 1259 OID 5058057)
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO aplicacio_georef;

--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 223
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- TOC entry 224 (class 1259 OID 5058059)
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO aplicacio_georef;

--
-- TOC entry 225 (class 1259 OID 5058062)
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO aplicacio_georef;

--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 225
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- TOC entry 226 (class 1259 OID 5058064)
-- Name: auth_user; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO aplicacio_georef;

--
-- TOC entry 227 (class 1259 OID 5058070)
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO aplicacio_georef;

--
-- TOC entry 228 (class 1259 OID 5058073)
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO aplicacio_georef;

--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 228
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- TOC entry 229 (class 1259 OID 5058075)
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO aplicacio_georef;

--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 229
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- TOC entry 230 (class 1259 OID 5058077)
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO aplicacio_georef;

--
-- TOC entry 231 (class 1259 OID 5058080)
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO aplicacio_georef;

--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 231
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- TOC entry 232 (class 1259 OID 5058082)
-- Name: autorrecursgeoref; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.autorrecursgeoref (
    id character varying(100) NOT NULL,
    idrecursgeoref character varying(100) NOT NULL,
    idpersona character varying(100) NOT NULL
);


ALTER TABLE public.autorrecursgeoref OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 5058085)
-- Name: capawms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.capawms (
    id character varying(200) NOT NULL,
    baseurlservidor character varying(400) NOT NULL,
    name character varying(400) NOT NULL,
    label character varying(400),
    minx double precision,
    maxx double precision,
    miny double precision,
    maxy double precision,
    boundary public.geometry(Polygon,4326)
);


ALTER TABLE public.capawms OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 5058091)
-- Name: capesrecurs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.capesrecurs (
    idcapa character varying(200),
    idrecurs character varying(200),
    id character varying(200) NOT NULL
);


ALTER TABLE public.capesrecurs OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 5058097)
-- Name: comments; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    comment text,
    data date,
    attachment character varying(500),
    nom_original character varying(500),
    author character varying(500),
    idversio character varying(200)
);


ALTER TABLE public.comments OWNER TO aplicacio_georef;

--
-- TOC entry 236 (class 1259 OID 5058103)
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comments_id_seq OWNER TO aplicacio_georef;

--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 236
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- TOC entry 237 (class 1259 OID 5058105)
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO aplicacio_georef;

--
-- TOC entry 238 (class 1259 OID 5058112)
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO aplicacio_georef;

--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 238
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- TOC entry 239 (class 1259 OID 5058114)
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO aplicacio_georef;

--
-- TOC entry 240 (class 1259 OID 5058117)
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO aplicacio_georef;

--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 240
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- TOC entry 241 (class 1259 OID 5058119)
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO aplicacio_georef;

--
-- TOC entry 242 (class 1259 OID 5058125)
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO aplicacio_georef;

--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 242
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- TOC entry 243 (class 1259 OID 5058127)
-- Name: django_session; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO aplicacio_georef;

--
-- TOC entry 244 (class 1259 OID 5058133)
-- Name: filtrejson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.filtrejson (
    idfiltre character varying(100) NOT NULL,
    json text,
    modul character varying(100),
    nomfiltre character varying(200)
);


ALTER TABLE public.filtrejson OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 5058139)
-- Name: geometries_api; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.geometries_api (
    id character varying(200) NOT NULL,
    geometria public.geometry(Geometry,4326) NOT NULL
);


ALTER TABLE public.geometries_api OWNER TO aplicacio_georef;

--
-- TOC entry 246 (class 1259 OID 5058145)
-- Name: georef_addenda_autor; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.georef_addenda_autor (
    id character varying(200) NOT NULL,
    nom character varying(500) NOT NULL
);


ALTER TABLE public.georef_addenda_autor OWNER TO aplicacio_georef;

--
-- TOC entry 247 (class 1259 OID 5058151)
-- Name: georef_addenda_autor_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.georef_addenda_autor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.georef_addenda_autor_id_seq OWNER TO aplicacio_georef;

--
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 247
-- Name: georef_addenda_autor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.georef_addenda_autor_id_seq OWNED BY public.georef_addenda_autor.id;


--
-- TOC entry 248 (class 1259 OID 5058153)
-- Name: georef_addenda_geometriarecurs; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.georef_addenda_geometriarecurs (
    id integer NOT NULL,
    geometria public.geometry(Geometry,4326) NOT NULL,
    idrecurs character varying(100)
);


ALTER TABLE public.georef_addenda_geometriarecurs OWNER TO aplicacio_georef;

--
-- TOC entry 249 (class 1259 OID 5058159)
-- Name: georef_addenda_geometriarecurs_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.georef_addenda_geometriarecurs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.georef_addenda_geometriarecurs_id_seq OWNER TO aplicacio_georef;

--
-- TOC entry 5027 (class 0 OID 0)
-- Dependencies: 249
-- Name: georef_addenda_geometriarecurs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.georef_addenda_geometriarecurs_id_seq OWNED BY public.georef_addenda_geometriarecurs.id;


--
-- TOC entry 250 (class 1259 OID 5058161)
-- Name: georef_addenda_geometriatoponimversio; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.georef_addenda_geometriatoponimversio (
    id integer NOT NULL,
    geometria public.geometry(Geometry,4326) NOT NULL,
    idversio character varying(200)
);


ALTER TABLE public.georef_addenda_geometriatoponimversio OWNER TO aplicacio_georef;

--
-- TOC entry 251 (class 1259 OID 5058167)
-- Name: georef_addenda_geometriatoponimversio_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.georef_addenda_geometriatoponimversio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.georef_addenda_geometriatoponimversio_id_seq OWNER TO aplicacio_georef;

--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 251
-- Name: georef_addenda_geometriatoponimversio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.georef_addenda_geometriatoponimversio_id_seq OWNED BY public.georef_addenda_geometriatoponimversio.id;


--
-- TOC entry 252 (class 1259 OID 5058169)
-- Name: georef_addenda_helpfile; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.georef_addenda_helpfile (
    id character varying(200) NOT NULL,
    titol text NOT NULL,
    h_file character varying(100) NOT NULL,
    created_on date NOT NULL
);


ALTER TABLE public.georef_addenda_helpfile OWNER TO aplicacio_georef;

--
-- TOC entry 253 (class 1259 OID 5058175)
-- Name: georef_addenda_organization; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.georef_addenda_organization (
    id integer NOT NULL,
    name character varying(200) NOT NULL
);


ALTER TABLE public.georef_addenda_organization OWNER TO aplicacio_georef;

--
-- TOC entry 254 (class 1259 OID 5058178)
-- Name: georef_addenda_organization_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.georef_addenda_organization_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.georef_addenda_organization_id_seq OWNER TO aplicacio_georef;

--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 254
-- Name: georef_addenda_organization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.georef_addenda_organization_id_seq OWNED BY public.georef_addenda_organization.id;


--
-- TOC entry 255 (class 1259 OID 5058180)
-- Name: georef_addenda_profile; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.georef_addenda_profile (
    id integer NOT NULL,
    toponim_permission character varying(200),
    user_id integer NOT NULL,
    permission_administrative boolean NOT NULL,
    permission_filter_edition boolean NOT NULL,
    permission_tesaure_edition boolean NOT NULL,
    permission_recurs_edition boolean NOT NULL,
    permission_toponim_edition boolean NOT NULL,
    organization_id integer
);


ALTER TABLE public.georef_addenda_profile OWNER TO aplicacio_georef;

--
-- TOC entry 256 (class 1259 OID 5058183)
-- Name: georef_addenda_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.georef_addenda_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.georef_addenda_profile_id_seq OWNER TO aplicacio_georef;

--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 256
-- Name: georef_addenda_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.georef_addenda_profile_id_seq OWNED BY public.georef_addenda_profile.id;


--
-- TOC entry 257 (class 1259 OID 5058185)
-- Name: pais; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pais (
    id character varying(100) NOT NULL,
    nom character varying(200) NOT NULL
);


ALTER TABLE public.pais OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 5058188)
-- Name: paraulaclau; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paraulaclau (
    id character varying(100) NOT NULL,
    paraula character varying(500) NOT NULL
);


ALTER TABLE public.paraulaclau OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 5058194)
-- Name: paraulaclaurecursgeoref; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paraulaclaurecursgeoref (
    id character varying(100) NOT NULL,
    idrecursgeoref character varying(100) NOT NULL,
    idparaula character varying(100) NOT NULL
);


ALTER TABLE public.paraulaclaurecursgeoref OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 5058197)
-- Name: prefs_visibilitat_capes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prefs_visibilitat_capes (
    id character varying(100) NOT NULL,
    prefscapesjson text,
    iduser integer
);


ALTER TABLE public.prefs_visibilitat_capes OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 5058203)
-- Name: qualificadorversio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qualificadorversio (
    id character varying(100) NOT NULL,
    qualificador character varying(500) NOT NULL
);


ALTER TABLE public.qualificadorversio OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 5058209)
-- Name: recursgeoref; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recursgeoref (
    id character varying(100) NOT NULL,
    nom character varying(500) NOT NULL,
    idtipusrecursgeoref character varying(100),
    comentarisnoambit character varying(500),
    campidtoponim character varying(500),
    versio character varying(100),
    fitxergraficbase character varying(100),
    idsuport character varying(100),
    urlsuport character varying(250),
    ubicaciorecurs character varying(200),
    actualitzaciosuport character varying(250),
    mapa character varying(100),
    comentariinfo text,
    comentariconsulta text,
    comentariqualitat text,
    classificacio character varying(300),
    divisiopoliticoadministrativa character varying(300),
    idambit character varying(100),
    acronim character varying(100),
    idsistemareferenciamm character varying(100),
    idtipusunitatscarto character varying(100),
    base_url_wms character varying(255),
    capes_wms_json text,
    iduser integer
);


ALTER TABLE public.recursgeoref OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 5058215)
-- Name: recursosgeoreferenciacio; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.recursosgeoreferenciacio AS
 SELECT uniogeom.id,
    uniogeom.nom,
    uniogeom.acronim,
    uniogeom.idsuport,
    uniogeom.tipus_geom,
    uniogeom.paraulaclau,
    uniogeom.carto_epsg23031
   FROM ( SELECT DISTINCT t2.id,
            t2.nom,
            t2.acronim,
            t2.idsuport,
                CASE
                    WHEN (public.st_geometrytype(public.st_transform(gr.geometria, 4326)) = 'ST_Point'::text) THEN 'T'::text
                    WHEN (public.st_geometrytype(public.st_transform(gr.geometria, 4326)) = 'ST_Polygon'::text) THEN 'P'::text
                    WHEN (public.st_geometrytype(public.st_transform(gr.geometria, 4326)) = 'ST_Line'::text) THEN 'A'::text
                    ELSE NULL::text
                END AS tipus_geom,
            string_agg((pc.paraula)::text, ' '::text) AS paraulaclau,
            public.st_transform(gr.geometria, 4326) AS carto_epsg23031
           FROM (((public.recursgeoref t2
             JOIN public.georef_addenda_geometriarecurs gr ON (((gr.idrecurs)::text = (t2.id)::text)))
             LEFT JOIN public.paraulaclaurecursgeoref pcr ON (((t2.id)::text = (pcr.idrecursgeoref)::text)))
             LEFT JOIN public.paraulaclau pc ON (((pc.id)::text = (pcr.idparaula)::text)))
          GROUP BY t2.id, t2.nom, t2.acronim, t2.idsuport, (public.st_transform(gr.geometria, 4326))) uniogeom;


ALTER TABLE public.recursosgeoreferenciacio OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 5058220)
-- Name: recursosgeoreferenciacio_wms_bound; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.recursosgeoreferenciacio_wms_bound AS
 SELECT c.id,
    r.nom,
    r.acronim,
    r.idsuport,
    string_agg((pc.paraula)::text, ' '::text) AS paraulaclau,
    c.name,
    c.label,
    'P'::text AS tipus_geom,
    c.boundary AS carto_epsg23031
   FROM ((((public.recursgeoref r
     JOIN public.capesrecurs cr ON (((cr.idrecurs)::text = (r.id)::text)))
     JOIN public.capawms c ON (((c.id)::text = (cr.idcapa)::text)))
     LEFT JOIN public.paraulaclaurecursgeoref pcr ON (((r.id)::text = (pcr.idrecursgeoref)::text)))
     LEFT JOIN public.paraulaclau pc ON (((pc.id)::text = (pcr.idparaula)::text)))
  GROUP BY c.id, r.nom, r.acronim, r.idsuport, c.name, c.label, c.boundary;


ALTER TABLE public.recursosgeoreferenciacio_wms_bound OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 5058225)
-- Name: sistemareferenciamm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sistemareferenciamm (
    id character varying(100) NOT NULL,
    nom character varying(500) NOT NULL
);


ALTER TABLE public.sistemareferenciamm OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 5058231)
-- Name: sistemareferenciarecurs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sistemareferenciarecurs (
    id character varying(100) NOT NULL,
    idrecursgeoref character varying(100) NOT NULL,
    idsistemareferenciamm character varying(100),
    sistemareferencia character varying(1000),
    conversio character varying(250)
);


ALTER TABLE public.sistemareferenciarecurs OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 5058237)
-- Name: suport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suport (
    id character varying(100) NOT NULL,
    nom character varying(100) NOT NULL
);


ALTER TABLE public.suport OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 5058240)
-- Name: tipusrecursgeoref; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipusrecursgeoref (
    id character varying(100) NOT NULL,
    nom character varying(100) NOT NULL
);


ALTER TABLE public.tipusrecursgeoref OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 5058243)
-- Name: tipustoponim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipustoponim (
    id character varying(100) NOT NULL,
    nom character varying(100) NOT NULL
);


ALTER TABLE public.tipustoponim OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 5058246)
-- Name: tipusunitats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipusunitats (
    id character varying(100) NOT NULL,
    tipusunitat character varying(500) NOT NULL
);


ALTER TABLE public.tipusunitats OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 5058252)
-- Name: toponim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toponim (
    id character varying(200) NOT NULL,
    codi character varying(50),
    nom character varying(250) NOT NULL,
    aquatic character(1),
    idtipustoponim character varying(100) NOT NULL,
    idpais character varying(100),
    idpare character varying(200),
    nom_fitxer_importacio character varying(255),
    linia_fitxer_importacio text,
    denormalized_toponimtree text,
    idorganization_id integer,
    sinonims character varying(500)
);


ALTER TABLE public.toponim OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 5058258)
-- Name: toponims_api; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.toponims_api (
    id character varying(200) NOT NULL,
    nomtoponim character varying(255),
    nom character varying(500),
    aquatic boolean,
    tipus character varying(255),
    idtipus character varying(255),
    datacaptura date,
    coordenadaxcentroide double precision,
    coordenadaycentroide double precision,
    incertesa double precision
);


ALTER TABLE public.toponims_api OWNER TO aplicacio_georef;

--
-- TOC entry 273 (class 1259 OID 5058264)
-- Name: toponimversio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toponimversio (
    id character varying(200) NOT NULL,
    codi character varying(50),
    nom character varying(250) NOT NULL,
    datacaptura date,
    coordenada_x double precision,
    coordenada_y double precision,
    coordenada_z double precision,
    precisio_h double precision,
    precisio_z double precision,
    idsistemareferenciarecurs character varying(100),
    coordenada_x_origen character varying(50),
    coordenada_y_origen character varying(50),
    coordenada_z_origen character varying(50),
    precisio_h_origen character varying(50),
    precisio_z_origen character varying(50),
    idpersona character varying(100),
    observacions text,
    idlimitcartooriginal character varying(100),
    idrecursgeoref character varying(100),
    idtoponim character varying(200),
    numero_versio integer,
    idqualificador character varying(100),
    coordenada_x_centroide character varying(50),
    coordenada_y_centroide character varying(50),
    iduser integer,
    last_version boolean,
    altitud_profunditat_minima integer,
    altitud_profunditat_maxima integer
);


ALTER TABLE public.toponimversio OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 5058270)
-- Name: toponimsbasatsenrecurs; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.toponimsbasatsenrecurs AS
 SELECT DISTINCT t2.codi,
    t2.id,
    t2.nom,
    t2.numero_versio,
    r.id AS idrecurs,
    r.nom AS nomrecurs,
        CASE
            WHEN (public.st_geometrytype(gt.geometria) = 'ST_Point'::text) THEN 'T'::text
            WHEN (public.st_geometrytype(gt.geometria) = 'ST_Polygon'::text) THEN 'P'::text
            WHEN (public.st_geometrytype(gt.geometria) = 'ST_Line'::text) THEN 'A'::text
            ELSE NULL::text
        END AS tipus_geom,
    gt.geometria AS carto_epsg23031
   FROM ( SELECT tv.codi,
            tv.id,
            max(tv.numero_versio) AS numero_versio
           FROM public.toponimversio tv
          WHERE (tv.numero_versio IS NOT NULL)
          GROUP BY tv.codi, tv.id) t1,
    public.toponimversio t2,
    public.recursgeoref r,
    public.georef_addenda_geometriatoponimversio gt
  WHERE (((t1.id)::text = (t2.id)::text) AND ((t2.id)::text = (gt.idversio)::text) AND (t1.numero_versio = t2.numero_versio) AND ((t2.idrecursgeoref)::text = (r.id)::text));


ALTER TABLE public.toponimsbasatsenrecurs OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 5058275)
-- Name: toponimsdarreraversio; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.toponimsdarreraversio AS
  SELECT uniogeom.codi,
    uniogeom.idversio,
    uniogeom.idq,
    uniogeom.idtoponim,
    uniogeom.idorg,
    uniogeom.aquatic,
    uniogeom.nomtoponim,
    uniogeom.tipustoponim,
    uniogeom.idtipustoponim,
    uniogeom.nomversio,
    uniogeom.numero_versio,
    uniogeom.tipus_geom,
    uniogeom.geometria,
    st_setsrid(uniogeom.geometria, 0) AS carto_epsg23031_cql
   FROM ( SELECT DISTINCT t2.codi,
            t2.id AS idversio,
            t2.idqualificador AS idq,
            top.id AS idtoponim,
            top.idorganization_id AS idorg,
            top.aquatic,
            top.nom AS nomtoponim,
            tt.nom AS tipustoponim,
            tt.id AS idtipustoponim,
            t2.nom AS nomversio,
            t2.numero_versio,
                CASE
                    WHEN st_geometrytype(gt.geometria) = 'ST_Point'::text THEN 'T'::text
                    WHEN st_geometrytype(gt.geometria) = 'ST_Polygon'::text THEN 'P'::text
                    WHEN st_geometrytype(gt.geometria) = 'ST_Line'::text THEN 'A'::text
                    ELSE NULL::text
                END AS tipus_geom,
            gt.geometria
           FROM toponimversio t2,
            toponim top,
            tipustoponim tt,            
            georef_addenda_geometriatoponimversio gt
          WHERE t2.id::text = gt.idversio::text AND t2.idtoponim::text = top.id::text AND top.idtipustoponim::text = tt.id::text) uniogeom,
    ( SELECT toponimversio.idtoponim,
            max(toponimversio.numero_versio) AS numero_versio
           FROM toponimversio
          GROUP BY toponimversio.idtoponim
         HAVING max(toponimversio.numero_versio) IS NOT NULL) darreraversio
  WHERE uniogeom.idtoponim::text = darreraversio.idtoponim::text AND uniogeom.numero_versio = darreraversio.numero_versio;


ALTER TABLE public.toponimsdarreraversio OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 5058280)
-- Name: toponimsdarreraversio_nocalc; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.toponimsdarreraversio_nocalc AS
 SELECT uniogeom.codi,
    uniogeom.idversio,
    uniogeom.idtoponim,
    uniogeom.aquatic,
    uniogeom.nomtoponim,
    uniogeom.tipustoponim,
    uniogeom.idtipustoponim,
    uniogeom.nomversio,
    uniogeom.numero_versio,
    uniogeom.tipus_geom,
    uniogeom.coordenada_x_centroide,
    uniogeom.coordenada_y_centroide,
    uniogeom.precisio_h,
    st_transform(st_buffer(st_transform(st_setsrid(st_makepoint(uniogeom.coordenada_x_centroide::double precision, uniogeom.coordenada_y_centroide::double precision), 4326), utmzone(st_setsrid(st_makepoint(uniogeom.coordenada_x_centroide::double precision, uniogeom.coordenada_y_centroide::double precision), 4326))), uniogeom.precisio_h), 4326) AS carto_epsg23031
   FROM ( SELECT DISTINCT t2.codi,
            t2.precisio_h,
            t2.coordenada_x_centroide,
            t2.coordenada_y_centroide,
            t2.id AS idversio,
            top.id AS idtoponim,
            top.aquatic,
            top.nom AS nomtoponim,
            tt.nom AS tipustoponim,
            tt.id AS idtipustoponim,
            t2.nom AS nomversio,
            t2.numero_versio,
                CASE
                    WHEN st_geometrytype(gt.geometria) = 'ST_Point'::text THEN 'T'::text
                    WHEN st_geometrytype(gt.geometria) = 'ST_Polygon'::text THEN 'P'::text
                    WHEN st_geometrytype(gt.geometria) = 'ST_Line'::text THEN 'A'::text
                    ELSE NULL::text
                END AS tipus_geom,
            gt.geometria
           FROM toponimversio t2,
            toponim top,
            tipustoponim tt,
            georef_addenda_geometriatoponimversio gt
          WHERE t2.id::text = gt.idversio::text AND t2.idtoponim::text = top.id::text AND top.idtipustoponim::text = tt.id::text ) uniogeom,
    ( SELECT toponimversio.idtoponim,
            max(toponimversio.numero_versio) AS numero_versio
           FROM toponimversio
          GROUP BY toponimversio.idtoponim
         HAVING max(toponimversio.numero_versio) IS NOT NULL) darreraversio
  WHERE uniogeom.idtoponim::text = darreraversio.idtoponim::text AND uniogeom.numero_versio = darreraversio.numero_versio AND uniogeom.coordenada_x_centroide::text <> ''::text AND uniogeom.coordenada_y_centroide::text <> ''::text;


ALTER TABLE public.toponimsdarreraversio_nocalc OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 5058285)
-- Name: toponimsdarreraversio_radi; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.toponimsdarreraversio_radi AS
SELECT int4(row_number() OVER (ORDER BY uniogeom.idversio)) AS id,
    uniogeom.codi,
    uniogeom.idversio,
    uniogeom.idtoponim,
    uniogeom.aquatic,
    uniogeom.nomtoponim,
    uniogeom.tipustoponim,
    uniogeom.idtipustoponim,
    uniogeom.nomversio,
    uniogeom.numero_versio,
    uniogeom.precisio_h,
    uniogeom.coordenada_x_centroide,
    uniogeom.coordenada_y_centroide,
    uniogeom.tipus_geom,
    uniogeom.carto_epsg23031
   FROM ( SELECT DISTINCT t2.codi,
            t2.precisio_h,
            public.st_x(public.st_centroid(gt.geometria)) AS coordenada_x_centroide,
            public.st_y(public.st_centroid(gt.geometria)) AS coordenada_y_centroide,
            t2.id AS idversio,
            top.id AS idtoponim,
            top.aquatic,
            top.nom AS nomtoponim,
            tt.nom AS tipustoponim,
            tt.id AS idtipustoponim,
            t2.nom AS nomversio,
            t2.numero_versio,
                CASE
                    WHEN (public.st_geometrytype(gt.geometria) = 'ST_Point'::text) THEN 'T'::text
                    WHEN (public.st_geometrytype(gt.geometria) = 'ST_Polygon'::text) THEN 'P'::text
                    WHEN (public.st_geometrytype(gt.geometria) = 'ST_Line'::text) THEN 'A'::text
                    ELSE NULL::text
                END AS tipus_geom,
            public.st_transform(public.st_buffer(public.st_transform(gt.geometria, public.utmzone(public.st_centroid(gt.geometria))), t2.precisio_h), 4326) AS carto_epsg23031
           FROM public.toponimversio t2,
            public.toponim top,
            public.tipustoponim tt,    
            public.georef_addenda_geometriatoponimversio gt
          WHERE (((t2.id)::text = (gt.idversio)::text) AND ((t2.idtoponim)::text = (top.id)::text) AND ((top.idtipustoponim)::text = (tt.id)::text))) uniogeom,
    ( SELECT toponimversio.idtoponim,
            max(toponimversio.numero_versio) AS numero_versio
           FROM public.toponimversio
          GROUP BY toponimversio.idtoponim
         HAVING (max(toponimversio.numero_versio) IS NOT NULL)) darreraversio
  WHERE (((uniogeom.idtoponim)::text = (darreraversio.idtoponim)::text) AND (uniogeom.numero_versio = darreraversio.numero_versio) AND (uniogeom.precisio_h >= (0)::double precision)); 


ALTER TABLE public.toponimsdarreraversio_radi OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 5058290)
-- Name: toponimsversio_api; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.toponimsversio_api (
    id character varying(200) NOT NULL,
    nom character varying(500),
    nomtoponim character varying(255),
    tipus character varying(100),
    versio integer,
    qualificadorversio character varying(500),
    recurscaptura character varying(500),
    sistrefrecurs character varying(1000),
    datacaptura date,
    coordxoriginal character varying(100),
    coordyoriginal character varying(100),
    coordz double precision,
    incertesaz double precision,
    georeferenciatper character varying(500),
    observacions text,
    coordxcentroide double precision,
    coordycentroide double precision,
    incertesacoord double precision,
    idtoponim character varying(200)
);


ALTER TABLE public.toponimsversio_api OWNER TO aplicacio_georef;

--
-- TOC entry 4625 (class 2604 OID 5058296)
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- TOC entry 4626 (class 2604 OID 5058297)
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- TOC entry 4627 (class 2604 OID 5058298)
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- TOC entry 4628 (class 2604 OID 5058299)
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- TOC entry 4629 (class 2604 OID 5058300)
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- TOC entry 4630 (class 2604 OID 5058301)
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- TOC entry 4631 (class 2604 OID 5058302)
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- TOC entry 4632 (class 2604 OID 5058303)
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- TOC entry 4634 (class 2604 OID 5058304)
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- TOC entry 4635 (class 2604 OID 5058305)
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- TOC entry 4636 (class 2604 OID 5058306)
-- Name: georef_addenda_geometriarecurs id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_geometriarecurs ALTER COLUMN id SET DEFAULT nextval('public.georef_addenda_geometriarecurs_id_seq'::regclass);


--
-- TOC entry 4637 (class 2604 OID 5058307)
-- Name: georef_addenda_geometriatoponimversio id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_geometriatoponimversio ALTER COLUMN id SET DEFAULT nextval('public.georef_addenda_geometriatoponimversio_id_seq'::regclass);


--
-- TOC entry 4638 (class 2604 OID 5058308)
-- Name: georef_addenda_organization id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_organization ALTER COLUMN id SET DEFAULT nextval('public.georef_addenda_organization_id_seq'::regclass);


--
-- TOC entry 4639 (class 2604 OID 5058309)
-- Name: georef_addenda_profile id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_profile ALTER COLUMN id SET DEFAULT nextval('public.georef_addenda_profile_id_seq'::regclass);


--
-- TOC entry 4945 (class 0 OID 5058049)
-- Dependencies: 220
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- TOC entry 4947 (class 0 OID 5058054)
-- Dependencies: 222
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- TOC entry 4949 (class 0 OID 5058059)
-- Dependencies: 224
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can add permission	2	add_permission
5	Can change permission	2	change_permission
6	Can delete permission	2	delete_permission
7	Can add user	3	add_user
8	Can change user	3	change_user
9	Can delete user	3	delete_user
10	Can add group	4	add_group
11	Can change group	4	change_group
12	Can delete group	4	delete_group
13	Can add content type	5	add_contenttype
14	Can change content type	5	change_contenttype
15	Can delete content type	5	delete_contenttype
16	Can add session	6	add_session
17	Can change session	6	change_session
18	Can delete session	6	delete_session
19	Can add tipustoponim	7	add_tipustoponim
20	Can change tipustoponim	7	change_tipustoponim
21	Can delete tipustoponim	7	delete_tipustoponim
22	Can add pais	8	add_pais
23	Can change pais	8	change_pais
24	Can delete pais	8	delete_pais
25	Can add qualificadorversio	9	add_qualificadorversio
26	Can change qualificadorversio	9	change_qualificadorversio
27	Can delete qualificadorversio	9	delete_qualificadorversio
28	Can add sistemareferenciarecurs	10	add_sistemareferenciarecurs
29	Can change sistemareferenciarecurs	10	change_sistemareferenciarecurs
30	Can delete sistemareferenciarecurs	10	delete_sistemareferenciarecurs
31	Can add toponim	11	add_toponim
32	Can change toponim	11	change_toponim
33	Can delete toponim	11	delete_toponim
34	Can add tipusunitats	12	add_tipusunitats
35	Can change tipusunitats	12	change_tipusunitats
36	Can delete tipusunitats	12	delete_tipusunitats
37	Can add tipusrecursgeoref	13	add_tipusrecursgeoref
38	Can change tipusrecursgeoref	13	change_tipusrecursgeoref
39	Can delete tipusrecursgeoref	13	delete_tipusrecursgeoref
40	Can add suport	14	add_suport
41	Can change suport	14	change_suport
42	Can delete suport	14	delete_suport
43	Can add sistemareferenciamm	15	add_sistemareferenciamm
44	Can change sistemareferenciamm	15	change_sistemareferenciamm
45	Can delete sistemareferenciamm	15	delete_sistemareferenciamm
46	Can add prefs visibilitat capes	16	add_prefsvisibilitatcapes
47	Can change prefs visibilitat capes	16	change_prefsvisibilitatcapes
48	Can delete prefs visibilitat capes	16	delete_prefsvisibilitatcapes
49	Can add toponimversio	17	add_toponimversio
50	Can change toponimversio	17	change_toponimversio
51	Can delete toponimversio	17	delete_toponimversio
52	Can add paraulaclau	18	add_paraulaclau
53	Can change paraulaclau	18	change_paraulaclau
54	Can delete paraulaclau	18	delete_paraulaclau
55	Can add paraulaclau recurs	19	add_paraulaclaurecurs
56	Can change paraulaclau recurs	19	change_paraulaclaurecurs
57	Can delete paraulaclau recurs	19	delete_paraulaclaurecurs
58	Can add autorrecursgeoref	20	add_autorrecursgeoref
59	Can change autorrecursgeoref	20	change_autorrecursgeoref
60	Can delete autorrecursgeoref	20	delete_autorrecursgeoref
61	Can add capawms	21	add_capawms
62	Can change capawms	21	change_capawms
63	Can delete capawms	21	delete_capawms
64	Can add capesrecurs	22	add_capesrecurs
65	Can change capesrecurs	22	change_capesrecurs
66	Can delete capesrecurs	22	delete_capesrecurs
67	Can add recursgeoref	23	add_recursgeoref
68	Can change recursgeoref	23	change_recursgeoref
69	Can delete recursgeoref	23	delete_recursgeoref
70	Can add filtrejson	24	add_filtrejson
71	Can change filtrejson	24	change_filtrejson
72	Can delete filtrejson	24	delete_filtrejson
73	Can add autor	25	add_autor
74	Can change autor	25	change_autor
75	Can delete autor	25	delete_autor
76	Can add help file	26	add_helpfile
77	Can change help file	26	change_helpfile
78	Can delete help file	26	delete_helpfile
79	Can add geometria toponim versio	27	add_geometriatoponimversio
80	Can change geometria toponim versio	27	change_geometriatoponimversio
81	Can delete geometria toponim versio	27	delete_geometriatoponimversio
82	Can add profile	28	add_profile
83	Can change profile	28	change_profile
84	Can delete profile	28	delete_profile
85	Can add geometria recurs	29	add_geometriarecurs
86	Can change geometria recurs	29	change_geometriarecurs
87	Can delete geometria recurs	29	delete_geometriarecurs
88	Can add organization	30	add_organization
89	Can change organization	30	change_organization
90	Can delete organization	30	delete_organization
\.


--
-- TOC entry 4951 (class 0 OID 5058064)
-- Dependencies: 226
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
\.


--
-- TOC entry 4952 (class 0 OID 5058070)
-- Dependencies: 227
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- TOC entry 4955 (class 0 OID 5058077)
-- Dependencies: 230
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- TOC entry 4957 (class 0 OID 5058082)
-- Dependencies: 232
-- Data for Name: autorrecursgeoref; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.autorrecursgeoref (id, idrecursgeoref, idpersona) FROM stdin;
\.


--
-- TOC entry 4958 (class 0 OID 5058085)
-- Dependencies: 233
-- Data for Name: capawms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.capawms (id, baseurlservidor, name, label, minx, maxx, miny, maxy, boundary) FROM stdin;
\.


--
-- TOC entry 4959 (class 0 OID 5058091)
-- Dependencies: 234
-- Data for Name: capesrecurs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.capesrecurs (idcapa, idrecurs, id) FROM stdin;
\.


--
-- TOC entry 4960 (class 0 OID 5058097)
-- Dependencies: 235
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.comments (id, comment, data, attachment, nom_original, author, idversio) FROM stdin;
\.


--
-- TOC entry 4962 (class 0 OID 5058105)
-- Dependencies: 237
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- TOC entry 4964 (class 0 OID 5058114)
-- Dependencies: 239
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	user
4	auth	group
5	contenttypes	contenttype
6	sessions	session
7	georef	tipustoponim
8	georef	pais
9	georef	qualificadorversio
10	georef	sistemareferenciarecurs
11	georef	toponim
12	georef	tipusunitats
13	georef	tipusrecursgeoref
14	georef	suport
15	georef	sistemareferenciamm
16	georef	prefsvisibilitatcapes
17	georef	toponimversio
18	georef	paraulaclau
19	georef	paraulaclaurecurs
20	georef	autorrecursgeoref
21	georef	capawms
22	georef	capesrecurs
23	georef	recursgeoref
24	georef	filtrejson
25	georef_addenda	autor
26	georef_addenda	helpfile
27	georef_addenda	geometriatoponimversio
28	georef_addenda	profile
29	georef_addenda	geometriarecurs
30	georef_addenda	organization
\.


--
-- TOC entry 4966 (class 0 OID 5058119)
-- Dependencies: 241
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2019-02-18 08:55:25.614472+01
2	auth	0001_initial	2019-02-18 08:55:25.810177+01
3	admin	0001_initial	2019-02-18 08:55:25.888498+01
4	admin	0002_logentry_remove_auto_add	2019-02-18 08:55:25.91415+01
5	contenttypes	0002_remove_content_type_name	2019-02-18 08:55:25.95073+01
6	auth	0002_alter_permission_name_max_length	2019-02-18 08:55:25.957759+01
7	auth	0003_alter_user_email_max_length	2019-02-18 08:55:25.967436+01
8	auth	0004_alter_user_username_opts	2019-02-18 08:55:25.976948+01
9	auth	0005_alter_user_last_login_null	2019-02-18 08:55:25.987274+01
10	auth	0006_require_contenttypes_0002	2019-02-18 08:55:25.992225+01
11	auth	0007_alter_validators_add_error_messages	2019-02-18 08:55:26.01951+01
12	auth	0008_alter_user_username_max_length	2019-02-18 08:55:26.044161+01
13	georef_addenda	0001_initial	2019-02-18 08:55:26.101535+01
14	georef_addenda	0002_auto_20180214_1310	2019-02-18 08:55:26.145137+01
15	georef_addenda	0003_profile	2019-02-18 08:55:26.203611+01
16	georef_addenda	0004_auto_20180220_1440	2019-02-18 08:55:26.360377+01
17	georef_addenda	0005_auto_20180221_0927	2019-02-18 08:55:26.480389+01
18	georef_addenda	0006_auto_20180221_1454	2019-02-18 08:55:26.532719+01
19	georef_addenda	0007_auto_20180222_1459	2019-02-18 08:55:26.544069+01
20	georef_addenda	0008_geometriarecurs	2019-02-18 08:55:26.590371+01
21	georef_addenda	0009_autor	2019-02-18 08:55:26.61916+01
22	georef_addenda	0010_auto_20180315_1437	2019-02-18 08:55:26.655838+01
23	georef_addenda	0011_helpfile	2019-02-18 08:55:26.689485+01
24	georef_addenda	0012_auto_20180604_1525	2019-02-18 08:55:26.697048+01
25	georef_addenda	0013_helpfile_created_on	2019-02-18 08:55:26.749623+01
26	sessions	0001_initial	2019-02-18 08:55:26.811592+01
27	georef_addenda	0014_profile_language	2019-11-21 18:07:05.6621+01
28	georef_addenda	0015_remove_profile_language	2019-11-21 18:07:05.68055+01
29	georef_addenda	0016_auto_20191113_1524	2019-11-21 18:07:05.71542+01
30	georef_addenda	0017_auto_20201116_1111	2020-12-10 08:39:27.676822+01
\.


--
-- TOC entry 4968 (class 0 OID 5058127)
-- Dependencies: 243
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
6i6xd0cfaioroczbefzw3r5o71oynnbk	M2E3ZTZkOGEwYTM1ODJmYzg5ZTQ3M2Q1ODZkOWY5NDRlNDNkYTIxYjp7Il9hdXRoX3VzZXJfaWQiOiIzNiIsIl9hdXRoX3VzZXJfaGFzaCI6ImM1MTUzMGZhZDU5NWQ4OGNlMmUwOThmODAxOGU1ODBhMzUyM2JhNzUiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCJ9	2021-11-12 10:41:51.435287+01
3nj00cs4abru30wdxzhu3bt520z5zcld	ZjQyY2UzZmFiNDA0N2YwYTI3N2FlZTE4NGNmZjMyYmViYmU0ZGM2Yzp7Il9hdXRoX3VzZXJfaGFzaCI6ImM1MTUzMGZhZDU5NWQ4OGNlMmUwOThmODAxOGU1ODBhMzUyM2JhNzUiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIzNiJ9	2021-11-16 08:53:15.591686+01
mdmlbabk6urkl93p6n78tkqttbszm7ly	ZjQyY2UzZmFiNDA0N2YwYTI3N2FlZTE4NGNmZjMyYmViYmU0ZGM2Yzp7Il9hdXRoX3VzZXJfaGFzaCI6ImM1MTUzMGZhZDU5NWQ4OGNlMmUwOThmODAxOGU1ODBhMzUyM2JhNzUiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIzNiJ9	2021-11-16 10:32:07.137647+01
\.


--
-- TOC entry 4969 (class 0 OID 5058133)
-- Dependencies: 244
-- Data for Name: filtrejson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.filtrejson (idfiltre, json, modul, nomfiltre) FROM stdin;
\.


--
-- TOC entry 4970 (class 0 OID 5058139)
-- Dependencies: 245
-- Data for Name: geometries_api; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.geometries_api (id, geometria) FROM stdin;
\.


--
-- TOC entry 4971 (class 0 OID 5058145)
-- Dependencies: 246
-- Data for Name: georef_addenda_autor; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.georef_addenda_autor (id, nom) FROM stdin;
\.


--
-- TOC entry 4973 (class 0 OID 5058153)
-- Dependencies: 248
-- Data for Name: georef_addenda_geometriarecurs; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.georef_addenda_geometriarecurs (id, geometria, idrecurs) FROM stdin;
\.


--
-- TOC entry 4975 (class 0 OID 5058161)
-- Dependencies: 250
-- Data for Name: georef_addenda_geometriatoponimversio; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.georef_addenda_geometriatoponimversio (id, geometria, idversio) FROM stdin;
\.


--
-- TOC entry 4977 (class 0 OID 5058169)
-- Dependencies: 252
-- Data for Name: georef_addenda_helpfile; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.georef_addenda_helpfile (id, titol, h_file, created_on) FROM stdin;
\.


--
-- TOC entry 4978 (class 0 OID 5058175)
-- Dependencies: 253
-- Data for Name: georef_addenda_organization; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.georef_addenda_organization (id, name) FROM stdin;
\.


--
-- TOC entry 4980 (class 0 OID 5058180)
-- Dependencies: 255
-- Data for Name: georef_addenda_profile; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.georef_addenda_profile (id, toponim_permission, user_id, permission_administrative, permission_filter_edition, permission_tesaure_edition, permission_recurs_edition, permission_toponim_edition, organization_id) FROM stdin;
\.


--
-- TOC entry 4982 (class 0 OID 5058185)
-- Dependencies: 257
-- Data for Name: pais; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pais (id, nom) FROM stdin;
\.


--
-- TOC entry 4983 (class 0 OID 5058188)
-- Dependencies: 258
-- Data for Name: paraulaclau; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paraulaclau (id, paraula) FROM stdin;
\.


--
-- TOC entry 4984 (class 0 OID 5058194)
-- Dependencies: 259
-- Data for Name: paraulaclaurecursgeoref; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paraulaclaurecursgeoref (id, idrecursgeoref, idparaula) FROM stdin;
\.


--
-- TOC entry 4985 (class 0 OID 5058197)
-- Dependencies: 260
-- Data for Name: prefs_visibilitat_capes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prefs_visibilitat_capes (id, prefscapesjson, iduser) FROM stdin;
\.


--
-- TOC entry 4986 (class 0 OID 5058203)
-- Dependencies: 261
-- Data for Name: qualificadorversio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qualificadorversio (id, qualificador) FROM stdin;
\.


--
-- TOC entry 4987 (class 0 OID 5058209)
-- Dependencies: 262
-- Data for Name: recursgeoref; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recursgeoref (id, nom, idtipusrecursgeoref, comentarisnoambit, campidtoponim, versio, fitxergraficbase, idsuport, urlsuport, ubicaciorecurs, actualitzaciosuport, mapa, comentariinfo, comentariconsulta, comentariqualitat, classificacio, divisiopoliticoadministrativa, idambit, acronim, idsistemareferenciamm, idtipusunitatscarto, base_url_wms, capes_wms_json, iduser) FROM stdin;
\.


--
-- TOC entry 4988 (class 0 OID 5058225)
-- Dependencies: 265
-- Data for Name: sistemareferenciamm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sistemareferenciamm (id, nom) FROM stdin;
\.


--
-- TOC entry 4989 (class 0 OID 5058231)
-- Dependencies: 266
-- Data for Name: sistemareferenciarecurs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sistemareferenciarecurs (id, idrecursgeoref, idsistemareferenciamm, sistemareferencia, conversio) FROM stdin;
\.


--
-- TOC entry 4620 (class 0 OID 5056618)
-- Dependencies: 200
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- TOC entry 4990 (class 0 OID 5058237)
-- Dependencies: 267
-- Data for Name: suport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suport (id, nom) FROM stdin;
\.


--
-- TOC entry 4991 (class 0 OID 5058240)
-- Dependencies: 268
-- Data for Name: tipusrecursgeoref; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipusrecursgeoref (id, nom) FROM stdin;
\.


--
-- TOC entry 4992 (class 0 OID 5058243)
-- Dependencies: 269
-- Data for Name: tipustoponim; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipustoponim (id, nom) FROM stdin;
\.


--
-- TOC entry 4993 (class 0 OID 5058246)
-- Dependencies: 270
-- Data for Name: tipusunitats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipusunitats (id, tipusunitat) FROM stdin;
\.


--
-- TOC entry 4994 (class 0 OID 5058252)
-- Dependencies: 271
-- Data for Name: toponim; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toponim (id, codi, nom, aquatic, idtipustoponim, idpais, idpare, nom_fitxer_importacio, linia_fitxer_importacio, denormalized_toponimtree, idorganization_id, sinonims) FROM stdin;
\.


--
-- TOC entry 4995 (class 0 OID 5058258)
-- Dependencies: 272
-- Data for Name: toponims_api; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.toponims_api (id, nomtoponim, nom, aquatic, tipus, idtipus, datacaptura, coordenadaxcentroide, coordenadaycentroide, incertesa) FROM stdin;
\.


--
-- TOC entry 4997 (class 0 OID 5058290)
-- Dependencies: 278
-- Data for Name: toponimsversio_api; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.toponimsversio_api (id, nom, nomtoponim, tipus, versio, qualificadorversio, recurscaptura, sistrefrecurs, datacaptura, coordxoriginal, coordyoriginal, coordz, incertesaz, georeferenciatper, observacions, coordxcentroide, coordycentroide, incertesacoord, idtoponim) FROM stdin;
\.


--
-- TOC entry 4996 (class 0 OID 5058264)
-- Dependencies: 273
-- Data for Name: toponimversio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toponimversio (id, codi, nom, datacaptura, coordenada_x, coordenada_y, coordenada_z, precisio_h, precisio_z, idsistemareferenciarecurs, coordenada_x_origen, coordenada_y_origen, coordenada_z_origen, precisio_h_origen, precisio_z_origen, idpersona, observacions, idlimitcartooriginal, idrecursgeoref, idtoponim, numero_versio, idqualificador, coordenada_x_centroide, coordenada_y_centroide, iduser, last_version, altitud_profunditat_minima, altitud_profunditat_maxima) FROM stdin;
\.


--
-- TOC entry 4618 (class 0 OID 5057820)
-- Dependencies: 215
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- TOC entry 4619 (class 0 OID 5057833)
-- Dependencies: 216
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 221
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aplicacio_georef
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 223
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aplicacio_georef
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 225
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aplicacio_georef
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 90, true);


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 228
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aplicacio_georef
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 229
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aplicacio_georef
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 36, true);


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 231
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aplicacio_georef
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 236
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aplicacio_georef
--

SELECT pg_catalog.setval('public.comments_id_seq', 1, false);


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 238
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aplicacio_georef
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 7, true);


--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 240
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aplicacio_georef
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 30, true);


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 242
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aplicacio_georef
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 30, true);


--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 247
-- Name: georef_addenda_autor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aplicacio_georef
--

SELECT pg_catalog.setval('public.georef_addenda_autor_id_seq', 1, false);


--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 249
-- Name: georef_addenda_geometriarecurs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aplicacio_georef
--

SELECT pg_catalog.setval('public.georef_addenda_geometriarecurs_id_seq', 19, true);


--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 251
-- Name: georef_addenda_geometriatoponimversio_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aplicacio_georef
--

SELECT pg_catalog.setval('public.georef_addenda_geometriatoponimversio_id_seq', 9491, true);


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 254
-- Name: georef_addenda_organization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aplicacio_georef
--

SELECT pg_catalog.setval('public.georef_addenda_organization_id_seq', 4, true);


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 256
-- Name: georef_addenda_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aplicacio_georef
--

SELECT pg_catalog.setval('public.georef_addenda_profile_id_seq', 36, true);


--
-- TOC entry 4642 (class 2606 OID 5058995)
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- TOC entry 4647 (class 2606 OID 5058997)
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- TOC entry 4650 (class 2606 OID 5058999)
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4644 (class 2606 OID 5059001)
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- TOC entry 4653 (class 2606 OID 5059003)
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- TOC entry 4655 (class 2606 OID 5059005)
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 4663 (class 2606 OID 5059007)
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 4666 (class 2606 OID 5059009)
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- TOC entry 4657 (class 2606 OID 5059011)
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- TOC entry 4669 (class 2606 OID 5059013)
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4672 (class 2606 OID 5059015)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- TOC entry 4660 (class 2606 OID 5059017)
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- TOC entry 4674 (class 2606 OID 5059019)
-- Name: autorrecursgeoref autorrecursgeoref_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autorrecursgeoref
    ADD CONSTRAINT autorrecursgeoref_pkey PRIMARY KEY (id);


--
-- TOC entry 4679 (class 2606 OID 5059021)
-- Name: capawms capawms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capawms
    ADD CONSTRAINT capawms_pkey PRIMARY KEY (id);


--
-- TOC entry 4681 (class 2606 OID 5059023)
-- Name: capesrecurs capesrecurs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capesrecurs
    ADD CONSTRAINT capesrecurs_pkey PRIMARY KEY (id);


--
-- TOC entry 4683 (class 2606 OID 5059025)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- TOC entry 4686 (class 2606 OID 5059027)
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4689 (class 2606 OID 5059029)
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- TOC entry 4691 (class 2606 OID 5059031)
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4693 (class 2606 OID 5059033)
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4696 (class 2606 OID 5059035)
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- TOC entry 4700 (class 2606 OID 5059037)
-- Name: geometries_api geometries_api_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.geometries_api
    ADD CONSTRAINT geometries_api_pkey PRIMARY KEY (id);


--
-- TOC entry 4702 (class 2606 OID 5059039)
-- Name: georef_addenda_autor georef_addenda_autor_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_autor
    ADD CONSTRAINT georef_addenda_autor_pkey PRIMARY KEY (id);


--
-- TOC entry 4707 (class 2606 OID 5059041)
-- Name: georef_addenda_geometriarecurs georef_addenda_geometriarecurs_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_geometriarecurs
    ADD CONSTRAINT georef_addenda_geometriarecurs_pkey PRIMARY KEY (id);


--
-- TOC entry 4712 (class 2606 OID 5059043)
-- Name: georef_addenda_geometriatoponimversio georef_addenda_geometriatoponimversio_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_geometriatoponimversio
    ADD CONSTRAINT georef_addenda_geometriatoponimversio_pkey PRIMARY KEY (id);


--
-- TOC entry 4715 (class 2606 OID 5059045)
-- Name: georef_addenda_helpfile georef_addenda_helpfile_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_helpfile
    ADD CONSTRAINT georef_addenda_helpfile_pkey PRIMARY KEY (id);


--
-- TOC entry 4717 (class 2606 OID 5059047)
-- Name: georef_addenda_organization georef_addenda_organization_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_organization
    ADD CONSTRAINT georef_addenda_organization_pkey PRIMARY KEY (id);


--
-- TOC entry 4720 (class 2606 OID 5059049)
-- Name: georef_addenda_profile georef_addenda_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_profile
    ADD CONSTRAINT georef_addenda_profile_pkey PRIMARY KEY (id);


--
-- TOC entry 4723 (class 2606 OID 5059051)
-- Name: georef_addenda_profile georef_addenda_profile_user_id_key; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_profile
    ADD CONSTRAINT georef_addenda_profile_user_id_key UNIQUE (user_id);


--
-- TOC entry 4725 (class 2606 OID 5059053)
-- Name: pais pais_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pais
    ADD CONSTRAINT pais_pkey PRIMARY KEY (id);


--
-- TOC entry 4727 (class 2606 OID 5059055)
-- Name: paraulaclau paraulaclau_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paraulaclau
    ADD CONSTRAINT paraulaclau_pkey PRIMARY KEY (id);


--
-- TOC entry 4731 (class 2606 OID 5059057)
-- Name: paraulaclaurecursgeoref paraulaclaurecursgeoref_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paraulaclaurecursgeoref
    ADD CONSTRAINT paraulaclaurecursgeoref_pkey PRIMARY KEY (id);


--
-- TOC entry 4733 (class 2606 OID 5059059)
-- Name: prefs_visibilitat_capes prefs_visibilitat_capes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prefs_visibilitat_capes
    ADD CONSTRAINT prefs_visibilitat_capes_pkey PRIMARY KEY (id);


--
-- TOC entry 4735 (class 2606 OID 5059061)
-- Name: qualificadorversio qualificadorversio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qualificadorversio
    ADD CONSTRAINT qualificadorversio_pkey PRIMARY KEY (id);


--
-- TOC entry 4742 (class 2606 OID 5059063)
-- Name: recursgeoref recursgeoref_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoref
    ADD CONSTRAINT recursgeoref_pkey PRIMARY KEY (id);


--
-- TOC entry 4744 (class 2606 OID 5059065)
-- Name: sistemareferenciamm sistemareferenciamm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sistemareferenciamm
    ADD CONSTRAINT sistemareferenciamm_pkey PRIMARY KEY (id);


--
-- TOC entry 4748 (class 2606 OID 5059067)
-- Name: sistemareferenciarecurs sistemareferenciarecurs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sistemareferenciarecurs
    ADD CONSTRAINT sistemareferenciarecurs_pkey PRIMARY KEY (id);


--
-- TOC entry 4750 (class 2606 OID 5059069)
-- Name: suport suport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suport
    ADD CONSTRAINT suport_pkey PRIMARY KEY (id);


--
-- TOC entry 4752 (class 2606 OID 5059071)
-- Name: tipusrecursgeoref tipusrecursgeoref_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipusrecursgeoref
    ADD CONSTRAINT tipusrecursgeoref_pkey PRIMARY KEY (id);


--
-- TOC entry 4754 (class 2606 OID 5059073)
-- Name: tipustoponim tipustoponim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipustoponim
    ADD CONSTRAINT tipustoponim_pkey PRIMARY KEY (id);


--
-- TOC entry 4756 (class 2606 OID 5059075)
-- Name: tipusunitats tipusunitats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipusunitats
    ADD CONSTRAINT tipusunitats_pkey PRIMARY KEY (id);


--
-- TOC entry 4761 (class 2606 OID 5059077)
-- Name: toponim toponim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponim
    ADD CONSTRAINT toponim_pkey PRIMARY KEY (id);


--
-- TOC entry 4765 (class 2606 OID 5059079)
-- Name: toponims_api toponims_api_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.toponims_api
    ADD CONSTRAINT toponims_api_pkey PRIMARY KEY (id);


--
-- TOC entry 4775 (class 2606 OID 5059081)
-- Name: toponimsversio_api toponimsversio_api_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.toponimsversio_api
    ADD CONSTRAINT toponimsversio_api_pkey PRIMARY KEY (id);


--
-- TOC entry 4772 (class 2606 OID 5059083)
-- Name: toponimversio toponimversio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponimversio
    ADD CONSTRAINT toponimversio_pkey PRIMARY KEY (id);


--
-- TOC entry 4677 (class 2606 OID 5059085)
-- Name: autorrecursgeoref unautorrecursgeoref; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autorrecursgeoref
    ADD CONSTRAINT unautorrecursgeoref UNIQUE (idpersona, idrecursgeoref);


--
-- TOC entry 4640 (class 1259 OID 5059086)
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- TOC entry 4645 (class 1259 OID 5059087)
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- TOC entry 4648 (class 1259 OID 5059088)
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- TOC entry 4651 (class 1259 OID 5059089)
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- TOC entry 4661 (class 1259 OID 5059090)
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- TOC entry 4664 (class 1259 OID 5059091)
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- TOC entry 4667 (class 1259 OID 5059092)
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- TOC entry 4670 (class 1259 OID 5059093)
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- TOC entry 4658 (class 1259 OID 5059094)
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- TOC entry 4684 (class 1259 OID 5059095)
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- TOC entry 4687 (class 1259 OID 5059096)
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- TOC entry 4694 (class 1259 OID 5059097)
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- TOC entry 4697 (class 1259 OID 5059098)
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- TOC entry 4675 (class 1259 OID 5059099)
-- Name: fkautorrecursgeorefr1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkautorrecursgeorefr1 ON public.autorrecursgeoref USING btree (idrecursgeoref);


--
-- TOC entry 4736 (class 1259 OID 5059100)
-- Name: fkrecgeotv1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkrecgeotv1 ON public.recursgeoref USING btree (idambit);


--
-- TOC entry 4737 (class 1259 OID 5059101)
-- Name: fkrecursgeorefs1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkrecursgeorefs1 ON public.recursgeoref USING btree (idsuport);


--
-- TOC entry 4757 (class 1259 OID 5059102)
-- Name: fktoponimos1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fktoponimos1 ON public.toponim USING btree (id);


--
-- TOC entry 4698 (class 1259 OID 5059103)
-- Name: geometries_api_idx; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX geometries_api_idx ON public.geometries_api USING gist (geometria);


--
-- TOC entry 4703 (class 1259 OID 5059104)
-- Name: georef_addenda_geometriarecurs_geometria_id; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_geometriarecurs_geometria_id ON public.georef_addenda_geometriarecurs USING gist (geometria);


--
-- TOC entry 4704 (class 1259 OID 5059105)
-- Name: georef_addenda_geometriarecurs_idrecurs_5b7466ad; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_geometriarecurs_idrecurs_5b7466ad ON public.georef_addenda_geometriarecurs USING btree (idrecurs);


--
-- TOC entry 4705 (class 1259 OID 5059106)
-- Name: georef_addenda_geometriarecurs_idrecurs_5b7466ad_like; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_geometriarecurs_idrecurs_5b7466ad_like ON public.georef_addenda_geometriarecurs USING btree (idrecurs varchar_pattern_ops);


--
-- TOC entry 4708 (class 1259 OID 5059107)
-- Name: georef_addenda_geometriatoponimversio_geometria_id; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_geometriatoponimversio_geometria_id ON public.georef_addenda_geometriatoponimversio USING gist (geometria);


--
-- TOC entry 4709 (class 1259 OID 5059108)
-- Name: georef_addenda_geometriatoponimversio_idversio_1b15db1f; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_geometriatoponimversio_idversio_1b15db1f ON public.georef_addenda_geometriatoponimversio USING btree (idversio);


--
-- TOC entry 4710 (class 1259 OID 5059109)
-- Name: georef_addenda_geometriatoponimversio_idversio_1b15db1f_like; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_geometriatoponimversio_idversio_1b15db1f_like ON public.georef_addenda_geometriatoponimversio USING btree (idversio varchar_pattern_ops);


--
-- TOC entry 4713 (class 1259 OID 5059110)
-- Name: georef_addenda_helpfile_id_b2b27e92_like; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_helpfile_id_b2b27e92_like ON public.georef_addenda_helpfile USING btree (id varchar_pattern_ops);


--
-- TOC entry 4718 (class 1259 OID 5059111)
-- Name: georef_addenda_profile_organization_id_5cbdfe9b; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_profile_organization_id_5cbdfe9b ON public.georef_addenda_profile USING btree (organization_id);


--
-- TOC entry 4721 (class 1259 OID 5059112)
-- Name: georef_addenda_profile_toponim_permission_id_483645ea_like; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_profile_toponim_permission_id_483645ea_like ON public.georef_addenda_profile USING btree (toponim_permission varchar_pattern_ops);


--
-- TOC entry 4762 (class 1259 OID 5059113)
-- Name: idtipus_toponimapi_idx; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX idtipus_toponimapi_idx ON public.toponims_api USING btree (idtipus);


--
-- TOC entry 4773 (class 1259 OID 5059114)
-- Name: idtoponim_toponimvapi_idx; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX idtoponim_toponimvapi_idx ON public.toponimsversio_api USING btree (idtoponim);


--
-- TOC entry 4758 (class 1259 OID 5059115)
-- Name: idx_linia_fitxer_importacio; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_linia_fitxer_importacio ON public.toponim USING btree (linia_fitxer_importacio);


--
-- TOC entry 4728 (class 1259 OID 5059116)
-- Name: idxrecursgeorefparaula; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrecursgeorefparaula ON public.paraulaclaurecursgeoref USING btree (idparaula);


--
-- TOC entry 4729 (class 1259 OID 5059117)
-- Name: idxrecursgeorefrecursgeoref; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrecursgeorefrecursgeoref ON public.paraulaclaurecursgeoref USING btree (idrecursgeoref);


--
-- TOC entry 4738 (class 1259 OID 5059118)
-- Name: idxrecursgeoreftr; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrecursgeoreftr ON public.recursgeoref USING btree (idtipusrecursgeoref);


--
-- TOC entry 4739 (class 1259 OID 5059119)
-- Name: idxrecurssistemarefmm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrecurssistemarefmm ON public.recursgeoref USING btree (idsistemareferenciamm);


--
-- TOC entry 4740 (class 1259 OID 5059120)
-- Name: idxrecurstipusunitats; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrecurstipusunitats ON public.recursgeoref USING btree (idtipusunitatscarto);


--
-- TOC entry 4745 (class 1259 OID 5059121)
-- Name: idxsistemareferenciarecursrg; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxsistemareferenciarecursrg ON public.sistemareferenciarecurs USING btree (idrecursgeoref);


--
-- TOC entry 4746 (class 1259 OID 5059122)
-- Name: idxsistemareferenciarecurssrmm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxsistemareferenciarecurssrmm ON public.sistemareferenciarecurs USING btree (idsistemareferenciamm);


--
-- TOC entry 4766 (class 1259 OID 5059123)
-- Name: idxtoponimdoc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxtoponimdoc ON public.toponimversio USING btree (idlimitcartooriginal);


--
-- TOC entry 4767 (class 1259 OID 5059124)
-- Name: idxtoponimr; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxtoponimr ON public.toponimversio USING btree (idrecursgeoref);


--
-- TOC entry 4759 (class 1259 OID 5059125)
-- Name: idxtoponimtt; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxtoponimtt ON public.toponim USING btree (idtipustoponim);


--
-- TOC entry 4768 (class 1259 OID 5059126)
-- Name: idxtoponimversioqualificador; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxtoponimversioqualificador ON public.toponimversio USING btree (idqualificador);


--
-- TOC entry 4769 (class 1259 OID 5059127)
-- Name: idxtoponimvp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxtoponimvp ON public.toponimversio USING btree (idpersona);


--
-- TOC entry 4770 (class 1259 OID 5059128)
-- Name: idxtoponimvsr; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxtoponimvsr ON public.toponimversio USING btree (idsistemareferenciarecurs);


--
-- TOC entry 4763 (class 1259 OID 5059129)
-- Name: nomtoponim_toponimapi_idx; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX nomtoponim_toponimapi_idx ON public.toponims_api USING btree (nomtoponim);


--
-- TOC entry 4776 (class 2606 OID 5059130)
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4777 (class 2606 OID 5059135)
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4778 (class 2606 OID 5059140)
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4779 (class 2606 OID 5059145)
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4780 (class 2606 OID 5059150)
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4781 (class 2606 OID 5059155)
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4782 (class 2606 OID 5059160)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4788 (class 2606 OID 5059165)
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4789 (class 2606 OID 5059170)
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4783 (class 2606 OID 5059175)
-- Name: autorrecursgeoref fkautorrecursgeorefa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autorrecursgeoref
    ADD CONSTRAINT fkautorrecursgeorefa FOREIGN KEY (idpersona) REFERENCES public.georef_addenda_autor(id) MATCH FULL;


--
-- TOC entry 4784 (class 2606 OID 5059180)
-- Name: autorrecursgeoref fkautorrecursgeorefr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autorrecursgeoref
    ADD CONSTRAINT fkautorrecursgeorefr FOREIGN KEY (idrecursgeoref) REFERENCES public.recursgeoref(id) MATCH FULL ON DELETE CASCADE;


--
-- TOC entry 4785 (class 2606 OID 5059185)
-- Name: capesrecurs fkcapareccapa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capesrecurs
    ADD CONSTRAINT fkcapareccapa FOREIGN KEY (idcapa) REFERENCES public.capawms(id) MATCH FULL;


--
-- TOC entry 4786 (class 2606 OID 5059190)
-- Name: capesrecurs fkcaparecrec; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capesrecurs
    ADD CONSTRAINT fkcaparecrec FOREIGN KEY (idrecurs) REFERENCES public.recursgeoref(id) MATCH FULL;


--
-- TOC entry 4787 (class 2606 OID 5059195)
-- Name: comments fkcommentversio; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fkcommentversio FOREIGN KEY (idversio) REFERENCES public.toponimversio(id) ON DELETE CASCADE;


--
-- TOC entry 4803 (class 2606 OID 5059200)
-- Name: toponim fkorgtoponim; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponim
    ADD CONSTRAINT fkorgtoponim FOREIGN KEY (idorganization_id) REFERENCES public.georef_addenda_organization(id) MATCH FULL DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4804 (class 2606 OID 5059205)
-- Name: toponim fkpaistoponim; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponim
    ADD CONSTRAINT fkpaistoponim FOREIGN KEY (idpais) REFERENCES public.pais(id) MATCH FULL DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4805 (class 2606 OID 5059210)
-- Name: toponim fkparetoponim; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponim
    ADD CONSTRAINT fkparetoponim FOREIGN KEY (idpare) REFERENCES public.toponim(id) MATCH FULL ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4807 (class 2606 OID 5059215)
-- Name: toponimversio fkqualificadorsversioqualificadors; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponimversio
    ADD CONSTRAINT fkqualificadorsversioqualificadors FOREIGN KEY (idqualificador) REFERENCES public.qualificadorversio(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4796 (class 2606 OID 5059220)
-- Name: recursgeoref fkrecgeotv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoref
    ADD CONSTRAINT fkrecgeotv FOREIGN KEY (idambit) REFERENCES public.toponimversio(id) MATCH FULL;


--
-- TOC entry 4794 (class 2606 OID 5059225)
-- Name: paraulaclaurecursgeoref fkrecursgeorefparaula; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paraulaclaurecursgeoref
    ADD CONSTRAINT fkrecursgeorefparaula FOREIGN KEY (idparaula) REFERENCES public.paraulaclau(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4795 (class 2606 OID 5059230)
-- Name: paraulaclaurecursgeoref fkrecursgeorefrecursgeoref; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paraulaclaurecursgeoref
    ADD CONSTRAINT fkrecursgeorefrecursgeoref FOREIGN KEY (idrecursgeoref) REFERENCES public.recursgeoref(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4797 (class 2606 OID 5059235)
-- Name: recursgeoref fkrecursgeorefs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoref
    ADD CONSTRAINT fkrecursgeorefs FOREIGN KEY (idsuport) REFERENCES public.suport(id) MATCH FULL;


--
-- TOC entry 4798 (class 2606 OID 5059240)
-- Name: recursgeoref fkrecursgeoreftr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoref
    ADD CONSTRAINT fkrecursgeoreftr FOREIGN KEY (idtipusrecursgeoref) REFERENCES public.tipusrecursgeoref(id) MATCH FULL;


--
-- TOC entry 4799 (class 2606 OID 5059245)
-- Name: recursgeoref fkrecurssistemarefmm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoref
    ADD CONSTRAINT fkrecurssistemarefmm FOREIGN KEY (idsistemareferenciamm) REFERENCES public.sistemareferenciamm(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4800 (class 2606 OID 5059250)
-- Name: recursgeoref fkrecurstipusunitat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoref
    ADD CONSTRAINT fkrecurstipusunitat FOREIGN KEY (idtipusunitatscarto) REFERENCES public.tipusunitats(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4801 (class 2606 OID 5059255)
-- Name: sistemareferenciarecurs fksistemareferenciarecursrg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sistemareferenciarecurs
    ADD CONSTRAINT fksistemareferenciarecursrg FOREIGN KEY (idrecursgeoref) REFERENCES public.recursgeoref(id) MATCH FULL ON DELETE CASCADE;


--
-- TOC entry 4802 (class 2606 OID 5059260)
-- Name: sistemareferenciarecurs fksistemareferenciarecurssrmm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sistemareferenciarecurs
    ADD CONSTRAINT fksistemareferenciarecurssrmm FOREIGN KEY (idsistemareferenciamm) REFERENCES public.sistemareferenciamm(id) MATCH FULL ON DELETE CASCADE;


--
-- TOC entry 4806 (class 2606 OID 5059265)
-- Name: toponim fktoponimtt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponim
    ADD CONSTRAINT fktoponimtt FOREIGN KEY (idtipustoponim) REFERENCES public.tipustoponim(id) MATCH FULL;


--
-- TOC entry 4808 (class 2606 OID 5059270)
-- Name: toponimversio fktoponimversiotoponim; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponimversio
    ADD CONSTRAINT fktoponimversiotoponim FOREIGN KEY (idtoponim) REFERENCES public.toponim(id) MATCH FULL ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4809 (class 2606 OID 5059275)
-- Name: toponimversio fktvrecgeo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponimversio
    ADD CONSTRAINT fktvrecgeo FOREIGN KEY (idrecursgeoref) REFERENCES public.recursgeoref(id);


--
-- TOC entry 4810 (class 2606 OID 5059280)
-- Name: toponimversio fktvsistrefmm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponimversio
    ADD CONSTRAINT fktvsistrefmm FOREIGN KEY (idsistemareferenciarecurs) REFERENCES public.sistemareferenciarecurs(id);


--
-- TOC entry 4790 (class 2606 OID 5059285)
-- Name: georef_addenda_geometriarecurs georef_addenda_geome_idrecurs_5b7466ad_fk_recursgeo; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_geometriarecurs
    ADD CONSTRAINT georef_addenda_geome_idrecurs_5b7466ad_fk_recursgeo FOREIGN KEY (idrecurs) REFERENCES public.recursgeoref(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4791 (class 2606 OID 5059290)
-- Name: georef_addenda_geometriatoponimversio georef_addenda_geome_idversio_1b15db1f_fk_toponimve; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_geometriatoponimversio
    ADD CONSTRAINT georef_addenda_geome_idversio_1b15db1f_fk_toponimve FOREIGN KEY (idversio) REFERENCES public.toponimversio(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4792 (class 2606 OID 5059295)
-- Name: georef_addenda_profile georef_addenda_profi_organization_id_5cbdfe9b_fk_georef_ad; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_profile
    ADD CONSTRAINT georef_addenda_profi_organization_id_5cbdfe9b_fk_georef_ad FOREIGN KEY (organization_id) REFERENCES public.georef_addenda_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4793 (class 2606 OID 5059300)
-- Name: georef_addenda_profile georef_addenda_profile_user_id_54bb2e4f_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_profile
    ADD CONSTRAINT georef_addenda_profile_user_id_54bb2e4f_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO aplicacio_georef;


--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE autorrecursgeoref; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.autorrecursgeoref TO aplicacio_georef;


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE capawms; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.capawms TO aplicacio_georef;


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE capesrecurs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.capesrecurs TO aplicacio_georef;


--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 244
-- Name: TABLE filtrejson; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.filtrejson TO aplicacio_georef;


--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 202
-- Name: TABLE geography_columns; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.geography_columns TO aplicacio_georef;


--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE geometry_columns; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.geometry_columns TO aplicacio_georef;


--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 257
-- Name: TABLE pais; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pais TO aplicacio_georef;


--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 258
-- Name: TABLE paraulaclau; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.paraulaclau TO aplicacio_georef;


--
-- TOC entry 5033 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE paraulaclaurecursgeoref; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.paraulaclaurecursgeoref TO aplicacio_georef;


--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE prefs_visibilitat_capes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.prefs_visibilitat_capes TO aplicacio_georef;


--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE qualificadorversio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.qualificadorversio TO aplicacio_georef;


--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE raster_columns; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.raster_columns TO aplicacio_georef;


--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE raster_overviews; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.raster_overviews TO aplicacio_georef;


--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 262
-- Name: TABLE recursgeoref; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.recursgeoref TO aplicacio_georef;


--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 263
-- Name: TABLE recursosgeoreferenciacio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.recursosgeoreferenciacio TO aplicacio_georef;


--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 264
-- Name: TABLE recursosgeoreferenciacio_wms_bound; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.recursosgeoreferenciacio_wms_bound TO aplicacio_georef;


--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 265
-- Name: TABLE sistemareferenciamm; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sistemareferenciamm TO aplicacio_georef;


--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 266
-- Name: TABLE sistemareferenciarecurs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sistemareferenciarecurs TO aplicacio_georef;


--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 200
-- Name: TABLE spatial_ref_sys; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.spatial_ref_sys TO aplicacio_georef;


--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 267
-- Name: TABLE suport; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.suport TO aplicacio_georef;


--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 268
-- Name: TABLE tipusrecursgeoref; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tipusrecursgeoref TO aplicacio_georef;


--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 269
-- Name: TABLE tipustoponim; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tipustoponim TO aplicacio_georef;


--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 270
-- Name: TABLE tipusunitats; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tipusunitats TO aplicacio_georef;


--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 271
-- Name: TABLE toponim; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponim TO aplicacio_georef;


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 273
-- Name: TABLE toponimversio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponimversio TO aplicacio_georef;


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 274
-- Name: TABLE toponimsbasatsenrecurs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponimsbasatsenrecurs TO aplicacio_georef;


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 275
-- Name: TABLE toponimsdarreraversio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponimsdarreraversio TO aplicacio_georef;


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 276
-- Name: TABLE toponimsdarreraversio_nocalc; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponimsdarreraversio_nocalc TO aplicacio_georef;


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 277
-- Name: TABLE toponimsdarreraversio_radi; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponimsdarreraversio_radi TO aplicacio_georef;


-- Completed on 2021-11-02 10:52:29 CET

--
-- PostgreSQL database dump complete
--

