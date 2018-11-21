CREATE TABLE users (
    id integer PRIMARY KEY,
    group_id integer NOT NULL
);

INSERT INTO users (id, group_id) VALUES
(1, 1), (2, 1), (3, 1), (4, 2), (5, 1), (6, 3);



SELECT group_id
FROM (
    SELECT *,
    LEAD(group_id, 1) OVER(ORDER BY id) next_group_id
    FROM users
)t
WHERE group_id != next_group_id OR next_group_id IS NULL;



SELECT min(id) min_id, group_id, count(id)
FROM (
     SELECT *,
     row_number() OVER (ORDER BY id) - row_number() OVER (PARTITION BY group_id ORDER BY id) parts
     FROM users
)t
GROUP BY group_id, parts
ORDER BY min(id);
