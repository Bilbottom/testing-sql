
WITH
    flow AS (
        -- Staring node
        SELECT *, "to" AS flow FROM flow_1 WHERE "from" IS NULL
        -- Subsequent nodes
        UNION ALL
            SELECT
                flow_1.*,
                flow.flow || '-' || flow_1."to" AS flow
            FROM flow_1
                INNER JOIN flow
                    ON flow_1."from" = flow."to"
    )

SELECT * FROM flow
;


WITH
    flow AS (
        -- Staring node
        SELECT *, "to" AS flow FROM flow_2
        -- Subsequent nodes
        UNION ALL
            SELECT
                flow_2.*,
                flow.flow || '-' || flow_2."to" AS flow
            FROM flow_2
                INNER JOIN flow
                    ON  flow_2."from" = flow."to"
--                     AND INSTR(flow.flow, flow_2."to") = 0
                    AND CASE WHEN flow_2."from" = flow_2."to"
                        THEN False
                        ELSE CASE WHEN LENGTH(flow.flow) = 1
                            THEN True
                            ELSE SUBSTRING(flow.flow, 1, 1) != SUBSTRING(flow.flow, -1, 1)
                        END
                    END
    )

SELECT * FROM flow
WHERE False
    OR "from" = "to"
    OR (TRUE
        AND LENGTH(flow) != 1
        AND SUBSTRING(flow, 1, 1) = SUBSTRING(flow, -1, 1)
    )
;

