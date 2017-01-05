CREATE OR REPLACE FUNCTION
    courses_update_column(
        course_id bigint,
        column_name text,
        value text,
        authn_user_id bigint
    ) returns void
AS $$
DECLARE
    old_row courses%ROWTYPE;
    new_row courses%ROWTYPE;
BEGIN
    SELECT c.* INTO old_row
    FROM
        courses AS c
    WHERE
        c.id = course_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'no such course, id: %', course_id;
    END IF;

    CASE column_name
        WHEN 'short_name' THEN
            UPDATE courses AS c SET short_name = value
            WHERE c.id = course_id
            RETURNING c.* INTO new_row;
        WHEN 'title' THEN
            UPDATE courses AS c SET title = value
            WHERE c.id = course_id
            RETURNING c.* INTO new_row;
        WHEN 'path' THEN
            UPDATE courses AS c SET path = value
            WHERE c.id = course_id
            RETURNING c.* INTO new_row;
        WHEN 'repository' THEN
            UPDATE courses AS c SET repository = value
            WHERE c.id = course_id
            RETURNING c.* INTO new_row;
        ELSE
            RAISE EXCEPTION 'unknown column_name: %', column_name;
    END CASE;

    INSERT INTO audit_logs
        (authn_user_id, course_id,
        table_name, column_name, row_id,
        action,  parameters,
        old_state, new_state)
    VALUES
        (authn_user_id, course_id,
        'courses',  column_name, course_id,
        'update', jsonb_build_object(column_name, value),
        to_jsonb(old_row), to_jsonb(new_row));
END;
$$ LANGUAGE plpgsql VOLATILE;
