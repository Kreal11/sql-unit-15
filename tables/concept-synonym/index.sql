   /* 13) What is the primary key for the concept_synonym table? */

   /* ===  
   
   Primary key is a unique key that stands for own property for one term. In example, myocardial infarction has it own concept_id and it is unique (stands for only for myocardial infarction). Primary key is absent for all columns in concept_synonym table because there are no unique terms that belong only to concept_synonym table. All concept synonyms belong to another word in some relation. By the way, that`s why it is a table for synonyms. Synonym just repeats the primary term in another way but does not stand for unique term. Therefore, they can not have the primary key. Their key is a key of original term. 
   
   === */

   /* 14) How many synonyms do we have for the SNOMED code of Epistaxis in the concept_synonym table? */

SELECT COUNT(*)
FROM concept_synonym AS cs
JOIN concept AS c ON cs.concept_id = c.concept_id
WHERE c.vocabulary_id = 'SNOMED'
AND c.concept_name = 'Epistaxis';

   /* 15) What languages are used in the concept_synonym_table? */

SELECT DISTINCT COUNT(language_concept_id)
FROM concept_synonym;

/* === There is no column language_name (e.g.) on concept table === */

   /* 16) How many English synonyms does Aspirin have? (as an Ingredient) */

                     /* ================== === CONCEPT RELATIONSHIP TABLE === ==================== */

/* A) Firstly we are searching for English language ID */

SELECT concept_id
FROM concept
WHERE domain_id = 'Language'
AND concept_name = 'English language';

/* Result: 4180186 */

/* B) Now with concept_id for English we can find amount of synonyms */

SELECT COUNT(DISTINCT cs.concept_synonym_name)
FROM concept_synonym AS cs
JOIN concept AS c ON cs.concept_id = c.concept_id
WHERE c.concept_name = 'Aspirin'
AND c.concept_class_id = 'Ingredient'
AND cs.language_concept_id = '4180186';

   /* 17) How many alive 'Maps to' relationships does ICD10CM vocabulary have? */

SELECT COUNT(*)
FROM concept_relationship AS cr
JOIN concept c1 ON cr.concept_id_1 = c1.concept_id
JOIN concept c2 ON cr.concept_id_2 = c2.concept_id
WHERE c1.vocabulary_id = 'ICD10CM'
AND c2.vocabulary_id = 'ICD10CM'
AND relationship_id = 'Maps to'
AND invalid_reason IS NULL;

   /* 18) Show the list of Updated in 2021st SNOMED codes together with their replacement mappings */

SELECT DISTINCT c1.concept_code AS old_code
                c2.concept_code AS new_code
FROM concept_relationship AS cr
JOIN concept c1 ON cr.concept_id_1 = c1.concept_id
JOIN concept c2 ON cr.concept_id_2 = c2.concept_id
WHERE cr.relationship_id = 'Maps to'
AND c1.vocabulary_id = 'SNOMED'
AND c2.vocabulary_id = 'SNOMED'
AND YEAR(c1.valid_end_date) = 2021
AND invalid_reason = 'U';

   /* 19) What domains and concept classes are hierarchically connected between LOINC and SNOMED? */

    /* Variant 1 (If SNOMED - parent and LOINC - child) */

    SELECT DISTINCT ancestor.domain_id, ancestor.concept_class_id
    FROM concept_ancestor AS ca 
    JOIN concept AS ancestor ON ca.ancestor_concept_id = ancestor.concept_id
    JOIN concept AS descendant ON ca.descendant_concept_id = descendant.concept_id
    WHERE ancestor.domain_id = 'SNOMED'
    AND descendant.domain_id = 'LOINC';

    /* Variant 2 (If LOINC - parent and SNOMED - child) */

    SELECT DISTINCT ancestor.domain_id, ancestor.concept_class_id
    FROM concept_ancestor AS ca 
    JOIN concept AS ancestor ON ca.ancestor_concept_id = ancestor.concept_id
    JOIN concept AS descendant ON ca.descendant_concept_id = descendant.concept_id
    WHERE ancestor.domain_id = 'LOINC'
    AND descendant.domain_id = 'SNOMED';

   /* 20) Show the mapping list of ICD10 codes which have 'Maps to' + 'Maps to value' relationships. */

    SELECT c.concept_code
    FROM relationship AS r
    JOIN concept AS c ON r.relationship_concept_id = c.concept_id
    WHERE (r.relationship_id = 'Maps to'
    OR r.relationship_id = 'Maps to value')
    AND c.vocabulary_id = 'ICD10';

   /* 21) Show attributive mappings (to SNOMED attributes) for SNOMED code of Hematemesis */

   SELECT *
   FROM concept
   WHERE vocabulary_id = 'SNOMED'
   AND concept_class_id = 'Attribute'
   AND concept_name = 'Hematemesis';