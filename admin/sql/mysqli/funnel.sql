-- Funnels

-- get all funnels
PROCEDURE getAll(
    IN start INT,
    IN limit INT,
    IN site_id INT,
    OUT fetch_all,
    OUT fetch_one
)
BEGIN
    -- funnel
    SELECT *, funnel_id as array_key
        FROM funnel
    WHERE site_id = :site_id

    -- limit
    @IF isset(:limit)
    THEN
        @SQL_LIMIT(:start, :limit)
    END @IF;

    SELECT count(*) FROM (
        @SQL_COUNT(funnel.funnel_id, funnel)
    ) as count;
END

-- get funnel
PROCEDURE get(
    IN funnel_id INT,
    IN site_id INT,
    OUT fetch_row,
    OUT fetch_all
)
BEGIN
    -- funnel
    SELECT *
        FROM funnel as _ 
    WHERE funnel_id = :funnel_id AND site_id = :site_id;

    -- funnel steps
    SELECT *
        FROM funnel_step
    WHERE funnel_id = :funnel_id
    ORDER BY sort_order;
END

-- add funnel
PROCEDURE add(
    IN funnel ARRAY,
    IN site_id INT,
    OUT insert_id
)
BEGIN
    -- allow only table fields and set defaults for missing values
    :funnel_data = @FILTER(:funnel, funnel)
    
    INSERT INTO funnel 
        ( @KEYS(:funnel_data), site_id )
    VALUES ( :funnel_data, :site_id );
END

-- edit funnel
PROCEDURE edit(
    IN funnel ARRAY,
    IN funnel_id INT,
    IN site_id INT,
    OUT affected_rows
)
BEGIN
    -- allow only table fields and set defaults for missing values
    :funnel_data = @FILTER(:funnel, funnel)

    UPDATE funnel
        SET @LIST(:funnel_data)
    WHERE funnel_id = :funnel_id AND site_id = :site_id;
END

-- delete funnel
PROCEDURE delete(
    IN funnel_id ARRAY,
    IN site_id INT,
    OUT affected_rows,
    OUT affected_rows
)
BEGIN
    DELETE FROM funnel_step WHERE funnel_id IN (:funnel_id);
    DELETE FROM funnel WHERE funnel_id IN (:funnel_id) AND site_id = :site_id;
END

-- add funnel step
PROCEDURE addStep(
    IN funnel_step ARRAY,
    IN funnel_id INT,
    OUT insert_id
)
BEGIN
    -- allow only table fields and set defaults for missing values
    :step_data = @FILTER(:funnel_step, funnel_step)
    
    INSERT INTO funnel_step 
        ( @KEYS(:step_data), funnel_id )
    VALUES ( :step_data, :funnel_id );
END

-- edit funnel step
PROCEDURE editStep(
    IN funnel_step ARRAY,
    IN step_id INT,
    OUT affected_rows
)
BEGIN
    -- allow only table fields and set defaults for missing values
    :step_data = @FILTER(:funnel_step, funnel_step)

    UPDATE funnel_step
        SET @LIST(:step_data)
    WHERE step_id = :step_id;
END

-- delete funnel step
PROCEDURE deleteStep(
    IN step_id ARRAY,
    OUT affected_rows
)
BEGIN
    DELETE FROM funnel_step WHERE step_id IN (:step_id);
END
