WITH fulltext AS (
  SELECT id, RANK() OVER (ORDER BY score DESC) AS rank
        -- query full-text
),
semantic AS (
  SELECT id, RANK() OVER (ORDER BY embedding <=> '[1,2,3]') AS rank
        --query semantica
),

-- Calculate RRF contribution
rrf AS (

  SELECT id, 
  1.0 / (60 + rank) AS s FROM fulltext

  UNION ALL

  SELECT id, 
  1.0 / (60 + rank) AS s FROM semantic
)

-- Sum the RRF scores, order by them, 
-- and join back the original data

SELECT m.id, sum(s), m.description
FROM rrf

JOIN mock_items AS m USING (id)
GROUP BY m.id, m.description
ORDER BY sum(s) DESC
LIMIT 5;
