-- Templates

-- get all templates
PROCEDURE getAll(
    IN start INT,
    IN limit INT,
    IN site_id INT,
    OUT fetch_all,
    OUT fetch_one
)
BEGIN
    -- template
    SELECT *, template_id as array_key
        FROM template
    WHERE site_id = :site_id

    -- limit
    @IF isset(:limit)
    THEN
        @SQL_LIMIT(:start, :limit)
    END @IF;

    SELECT count(*) FROM (
        @SQL_COUNT(template.template_id, template)
    ) as count;
END

-- get template
PROCEDURE get(
    IN template_id INT,
    IN site_id INT,
    OUT fetch_row
)
BEGIN
    -- template
    SELECT *
        FROM template as _
    WHERE template_id = :template_id AND site_id = :site_id;
END

-- add template
PROCEDURE add(
    IN template ARRAY,
    IN site_id INT,
    OUT insert_id
)
BEGIN
    -- allow only table fields and set defaults for missing values
    :template_data = @FILTER(:template, template)
    
    INSERT INTO template 
        ( @KEYS(:template_data), site_id )
    VALUES ( :template_data, :site_id );
END

-- edit template
PROCEDURE edit(
    IN template ARRAY,
    IN template_id INT,
    IN site_id INT,
    OUT affected_rows
)
BEGIN
    -- allow only table fields and set defaults for missing values
    :template_data = @FILTER(:template, template)

    UPDATE template
        SET @LIST(:template_data)
    WHERE template_id = :template_id AND site_id = :site_id;
END

-- delete template
PROCEDURE delete(
    IN template_id ARRAY,
    IN site_id INT,
    OUT affected_rows
)
BEGIN
    DELETE FROM template WHERE template_id IN (:template_id) AND site_id = :site_id;
END

-- duplicate template
PROCEDURE duplicate(
    IN template_id INT,
    IN site_id INT,
    OUT insert_id
)
BEGIN
    INSERT INTO template 
        (name, content, type, category, thumb, status, site_id)
    SELECT 
        CONCAT(name, ' (copy)'), content, type, category, thumb, status, site_id
    FROM template 
    WHERE template_id = :template_id AND site_id = :site_id;
END

-- get templates by category
PROCEDURE getByCategory(
    IN category VARCHAR(191),
    IN site_id INT,
    IN start INT,
    IN limit INT,
    OUT fetch_all,
    OUT fetch_one
)
BEGIN
    -- template
    SELECT *, template_id as array_key
        FROM template
    WHERE site_id = :site_id
    AND category = :category

    -- limit
    @IF isset(:limit)
    THEN
        @SQL_LIMIT(:start, :limit)
    END @IF;

    SELECT count(*) FROM (
        @SQL_COUNT(template.template_id, template)
        WHERE site_id = :site_id AND category = :category
    ) as count;
END
