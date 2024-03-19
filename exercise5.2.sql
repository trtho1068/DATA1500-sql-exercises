--a)
SELECT *
FROM freelancer;

--b)
SELECT pers_id
FROM freelancer;

--c)
SELECT DISTINCT avisnavn
FROM freelancer_i_avis;

--d)
SELECT fornavn, etternavn
FROM freelancer INNER JOIN freelancer_i_avis as avis
    ON freelancer.pers_id = avis.pers_id
WHERE avis.avisnavn = 'VG';

--e)
SELECT fornavn, etternavn
FROM freelancer
WHERE pers_id NOT IN (
    SELECT ifr.pers_id
    FROM freelancer as ifr INNER JOIN freelancer_i_avis as avis
        ON ifr.pers_id = avis.pers_id
    WHERE avis.avisnavn = 'VG'
);

--f)
SELECT *
FROM freelancer
WHERE etternavn is NULL;

--g)
SELECT *
FROM freelancer
WHERE etternavn LIKE '%Olsen';

--h)
SELECT *
FROM freelancer
WHERE etternavn = 'Olsen';

--i)
SELECT *
FROM freelancer
WHERE fornavn LIKE 'An%';

--j)
SELECT *
FROM freelancer
WHERE etternavn LIKE '%ls%';

--k)
SELECT *
FROM freelancer
WHERE fornavn LIKE 'An%'
    AND etternavn LIKE '%sen';

--l)
SELECT avisnavn
FROM freelancer_i_avis
WHERE avisnavn NOT IN (
    SELECT DISTINCT fa.avisnavn
    FROM freelancer_i_avis as fa INNER JOIN freelancer_spesialitet as fs
        ON fa.pers_id = fs.pers_id
    WHERE fs.spesialitet = 'Sport'
);

--m)
SELECT f.pers_id, f.fornavn, f.etternavn,
    JSON_ARRAYAGG(DISTINCT fa.avisnavn) as jsonArrayAviser,
    JSON_ARRAYAGG(DISTINCT fs.spesialitet) as jsonArraySpesialiteter
FROM freelancer as f
    INNER JOIN freelancer_i_avis as fa on f.pers_id = fa.pers_id
    INNER JOIN freelancer_spesialitet as fs on f.pers_id = fs.pers_id
GROUP BY f.pers_id;

