/* 1) How many rows does the concept table have ? */

SELECT COUNT(*) AS rows_amount
FROM concept;

/* 2) What are the minimum and maximum values of the concept_id field ? */

SELECT MIN(concept_id) AS min_concept_id,
       MAX(concept_id) AS max_concept_id
FROM concept;


/* 3) What fields in the concept table are nullable ? */

SELECT *
FROM concept
WHERE NULL IN (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_code, valid_end_date, invalid_reason);

/* 4) What is the datatype of the concept_id field? How can we get to know it using Workbench ? */

 /* === The datatype for concept_id is integer. It means that this is a number. We can find answer on this question by using "Table Inspector" in Database where there are datatypes for each column. We can also make a query to find all information about column in response including datatype === */

/* Variant 1 */

SHOW COLUMNS 
FROM concept 
LIKE 'concept_id';

/* Variant 2 */

SELECT Datatype
FROM information_schema.columns
WHERE table_schema = 'database_name'
AND table_name = 'concept'
AND column_name = 'concept_id';


/* 5) What is the difference between a general number of concept_ids and a distinct number of concept_ids in the concept table ? */

/* === 

Distinct number of concept_ids finds only different values while general number finds all values even if they repeat 

=== */

SELECT DISTINCT concept_id
FROM concept;

/* 6) Show the list of distinct vocabularies together with types of all possible domains and their numbers per each vocabulary ? */

SELECT vocabulary_id,
       domain_id,
       COUNT(DISTINCT domain_id) AS domains_amount
FROM concept
GROUP BY vocabulary_id, domain_id;

/* 7) How many Standard Ingredients do we have in the concept_table ? */

SELECT COUNT(*)
FROM concept
WHERE concept_class_id = 'Ingredient' 
AND standard_concept = 'S';

/* 8) How many Updated LOINC codes do we have in the concept_table ? */

SELECT COUNT(concept_code)
FROM concept
WHERE vocabulary_id = 'LOINC' 
AND invalid_reason = 'U';

/* 9) How many valid but Non-standard Conditions of all possible ICD-related vocabularies are in the concept table ? */

SELECT COUNT(*)
FROM concept
WHERE standard_concept = 'C' 
AND valid_end_date = '31-Dec-2099' 
AND concept_class_id = 'Conditions' 
AND vocabulary_id LIKE 'ICD%';

/* 10) Show the list of all possible vaccines that were added during the 2020 and 2021 years in the concept table ? */

SELECT *
FROM concept
WHERE concept_class_id = 'Vaccines'
AND YEAR(valid_start_date) BETWEEN 2020 AND 2021;

/* 11) Show the list of Ingredients that are used as antineoplastic therapy ? */

SELECT concept_name
FROM concept
WHERE concept_class_id = 'Ingredient'
AND concept_name LIKE '%antineoplastic therapy%';

/* 12) In which year did the vocabulary team deprecate the highest number of concepts ? */

SELECT YEAR(valid_end_date) AS deprecation_year, 
COUNT(*) AS deprecated_concepts_amount
FROM concept
WHERE invalid_reason = 'D'
GROUP BY YEAR(valid_end_date)
ORDER BY deprecated_concepts_amount DESC
LIMIT 1;
