CREATE DATABASE suppliers;
\c suppliers
CREATE TABLE vendors (
            vendor_id SERIAL PRIMARY KEY,
            vendor_name VARCHAR(255) NOT NULL
);
CREATE TABLE parts (
                part_id SERIAL PRIMARY KEY,
                part_name VARCHAR(255) NOT NULL
);
CREATE TABLE part_drawings (
                part_id INTEGER PRIMARY KEY,
                file_extension VARCHAR(5) NOT NULL,
                drawing_data BYTEA NOT NULL,
                FOREIGN KEY (part_id)
                REFERENCES parts (part_id)
                ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE vendor_parts (
                vendor_id INTEGER NOT NULL,
                part_id INTEGER NOT NULL,
                PRIMARY KEY (vendor_id , part_id),
                FOREIGN KEY (vendor_id)
                    REFERENCES vendors (vendor_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
                FOREIGN KEY (part_id)
                    REFERENCES parts (part_id)
                    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION get_parts_by_vendor(id integer)
  RETURNS TABLE(part_id INTEGER, part_name VARCHAR) AS
$$
BEGIN
 RETURN QUERY

 SELECT parts.part_id, parts.part_name
 FROM parts
 INNER JOIN vendor_parts on vendor_parts.part_id = parts.part_id
 WHERE vendor_id = id;

END; $$

LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_vendors()
  RETURNS TABLE(part_id INTEGER, part_name VARCHAR) AS
$$
BEGIN
 RETURN QUERY

 SELECT vendors.vendor_id,vendors.vendor_name
 FROM vendors;

END; $$

LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_vendor(id integer)
  RETURNS TABLE(vendor_id INTEGER, vendor_name VARCHAR) AS
$$
BEGIN
 RETURN QUERY
 SELECT vendors.vendor_id,vendors.vendor_name
 FROM vendors WHERE vendors.vendor_id = id;

END; $$

LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_vendor(id integer,name VARCHAR)
  RETURNS VOID AS
$$
UPDATE vendors SET vendor_name=name WHERE vendor_id = id;
$$
LANGUAGE SQL;

CREATE OR REPLACE FUNCTION create_vendor(name VARCHAR)
  RETURNS VOID AS
$$
    INSERT INTO vendors(vendor_name) VALUES(name);
$$
LANGUAGE SQL;

CREATE OR REPLACE FUNCTION delete_vendor(id integer)
  RETURNS VOID AS
$$
    DELETE FROM vendors WHERE vendors.vendor_id=id;
$$
LANGUAGE SQL;

CREATE OR REPLACE FUNCTION read_vendor()
  RETURNS TABLE(vendor_id INTEGER, vendor_name VARCHAR) AS
$$
BEGIN
 RETURN QUERY
 SELECT vendors.vendor_id,vendors.vendor_name
 FROM vendors;

END; $$

LANGUAGE plpgsql;
