-- table 1
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100)
);

-- All tables insert opearations

INSERT INTO
    rangers (name, region)
VALUES (
        'Alice Green',
        'Northern Hills'
    ),
    ('Bob White', 'River Delta'),
    (
        'Carol King',
        'Mountain Range'
    );

SELECT * FROM rangers;

-- table 2
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(100),
    discovery_date DATE,
    conservation_status VARCHAR(50)
);

INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'African Lion',
        'Panthera leo',
        '1758-01-01',
        'Vulnerable'
    ),
    (
        'Giant Panda',
        'Ailuropoda melanoleuca',
        '1869-03-11',
        'Vulnerable'
    ),
    (
        'Blue Whale',
        'Balaenoptera musculus',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Mountain Gorilla',
        'Gorilla beringei beringei',
        '1903-01-01',
        'Critically Endangered'
    ),
    (
        'Snowy Owl',
        'Bubo scandiacus',
        '1758-01-01',
        'Least Concern'
    );

SELECT * FROM species;

-- Third sightings Tables

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species (species_id),
    ranger_id INT REFERENCES rangers (ranger_id),
    sighting_time TIMESTAMP,
    location VARCHAR(100),
    notes TEXT
);

INSERT INTO
    sightings (
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        'Savannah Pass',
        '2024-06-10 07:30:00',
        'Group of lions spotted'
    ),
    (
        2,
        2,
        'Bamboo Pass Trail',
        '2024-06-11 08:45:00',
        'One panda resting'
    ),
    (
        3,
        3,
        'Ocean Pass',
        '2024-06-12 10:15:00',
        'Whale sighted from drone'
    ),
    (
        4,
        1,
        'Mountain Pass Viewpoint',
        '2024-06-13 06:50:00',
        'Family of gorillas near rocks'
    );

SELECT * FROM sightings;

-----------------  Poblems Solutions  -------------------------------------

-- Poblems No: 1

-- Insert a new data on the tables

INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal plains');

-- Poblems No: 2

SELECT COUNT(DISTINCT species_id) AS unique_species_count
from sightings;

-- Poblems No:3

SELECT * FROM sightings WHERE location ILIKE '%Pass%';

-- poblems No: 4

SELECT r.name as "name", COUNT(s.sighting_id) as "total_sightings"
from rangers as r
    LEFT JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY
    r.name;

-- Poblem No:5

SELECT common_name
FROM species
WHERE
    species_id NOT in (
        SELECT DISTINCT
            species_id
        FROM sightings
    );

-- Poblems No:6

SELECT sp.common_name, s.sighting_time, r.name
FROM
    sightings s
    JOIN species sp USING (species_id)
    JOIN rangers r USING (ranger_id)
ORDER BY s.sighting_time DESC
LIMIT 2;

-- Poblem No:7

SELECT * FROM species;

UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    discovery_date < '1825-01-01';

SELECT * FROM sightings;

-- problems No: 8
SELECT
    sighting_id,
    CASE
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) < 12 THEN 'Morning'
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) BETWEEN 12 AND 17  THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;

-- Poblem No:9
DELETE FROM rangers
WHERE
    ranger_id NOT IN (
        SELECT DISTINCT
            ranger_id
        FROM sightings
    );