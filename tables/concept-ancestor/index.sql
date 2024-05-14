/* 22) Prepare lookup with any 10 ATC codes and their names which have min_levels_of_separation and max_levels_of_separation equal to 0. Explain what it means. */ 

   /* === 
   
   This two columns show how many levels of hierarchy between ancestor and descendant concepts. If min_levels_of_separation and max_levels_of_separation are equal to 0 it means that two terms are located on the same level of hierarchy 
   
   === */

SELECT c.concept_name, c.concept_code
FROM concept AS c
JOIN concept_ancestor AS ca ON c.concept_id = ca.descendant_concept_id 
WHERE ca.min_levels_of_separation = 0
AND ca.max_levels_of_separation = 0
AND c.vocabulary_id = 'ATC'
LIMIT 10;

/* 23) How many Branded Drugs сontain aspirin as Ingredient? */

/* === Firstly, let`s identify ingredient_concept_id for aspirin === */

SELECT concept_id
FROM concept
WHERE c.concept_class_id = 'Ingredient'
AND concept_name = 'aspirin'; 

/* === Result: 1112807 === */ 

/* === Secondly, we can make a query with this ingredient_concept_id === */

SELECT COUNT(*)
FROM drug_strength AS ds
JOIN concept AS c ON c.concept_id = ds.drug_concept_id
WHERE ds.ingredient_concept_id = '1112807'
AND c.concept_class_id = 'Branded Drug';

/* 24) How many multicomponent Clinical Drugs contain paracetamol as Ingredients? */ 

/* === Firstly, let`s identify ingredient_concept_id for aspirin === */

SELECT concept_id
FROM concept
WHERE c.concept_class_id = 'Ingredient'
AND concept_name = 'paracetamol'
OR concept_name = 'acetaminophen';

/* === Result: 1125315 === */ 

/* === Secondly, we can make a query with this ingredient_concept_id === */

SELECT COUNT(*)
FROM drug_strength AS ds
JOIN concept AS c ON c.concept_id = ds.drug_concept_id
WHERE ds.ingredient_concept_id = '1125315'
AND ds.amount_value > 1
AND c.concept_class_id = 'Clinical Drug';

/* 25) Show the list of all antineoplastic drugs using ATC. */ 

SELECT concept_name, concept_code
FROM concept
WHERE vocabulary_id = 'ATC'
AND concept_class_id = 'Drug'
AND concept_code LIKE 'LO1%';

/* 26) Show the closest and farthest semantic parent for the SNOMED code of Anxiety */ 

   /* === Closest parent === */

SELECT c.concept_name
FROM concept AS c
JOIN concept_ancestor AS ca ON c.concept_id = ca.ancestor_concept_id
WHERE c.vocabulary_id = 'SNOMED'
AND c.concept_name = 'Anxiety'
ORDER BY ca.min_levels_of_separation ASC
LIMIT 1;

   /* === Farthest parent === */

SELECT c.concept_name
FROM concept AS c
JOIN concept_ancestor AS ca ON c.concept_id = ca.ancestor_concept_id
WHERE c.vocabulary_id = 'SNOMED'
AND c.concept_name = 'Anxiety'
ORDER BY ca.max_levels_of_separation DESC
LIMIT 1;

/* 27) Which SNOMED code in the hierarchical branch of Bleeding has the highest number of synonyms? */ 


/* === Firstly, let`s find concept_id for Bleeding from concept table === */

SELECT concept_id
FROM concept
WHERE concept_name = 'Bleeding'
AND vocabulary_id = 'SNOMED';

/* === 

In case of no restrictions I chose from Athena valid and standard concept; 

Result: 437312;

=== */ 

/* === Now we can find SNOMED code that has the highest number of synonyms === */

SELECT ca.descendant_concept_id AS snomed_code
       COUNT(cs.concept_synonym_name) AS synonym_amount
FROM concept_ancestor AS ca
JOIN concept AS c ON c.concept_id = ca.descendant_concept_id
JOIN concept_synonym AS cs ON cs.concept_id = c.concept_id
WHERE ca.ancestor_concept_id = 437312
GROUP BY ca.descendant_concept_id
ORDER BY synonym_amount DESC
LIMIT 1;