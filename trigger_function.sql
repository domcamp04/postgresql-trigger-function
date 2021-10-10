--CREATE TRIGGER FUNCTION
CREATE OR REPLACE FUNCTION trig_func() RETURNS TRIGGER AS
$$
BEGIN
WITH d AS(
	SELECT parts.quantity AS rowid, parts.quantity - car_service.quantity_used AS calculatedvalue
	FROM parts
	JOIN car_service
	ON car_service.part_id = parts.part_id
)
UPDATE parts
SET quantity = d.calculatedvalue
FROM d
WHERE quantity = d.rowid;
		
RETURN new;
END;
$$
LANGUAGE plpgsql;

--CREATE TRIGGER
CREATE TRIGGER update_parts_quantity
	AFTER INSERT ON car_service
	FOR EACH ROW
	EXECUTE PROCEDURE trig_func();
	
--SEEING IF IT WORKS
SELECT * FROM parts;
--It did!