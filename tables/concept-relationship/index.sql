/* 28) How many distinct relationships exist in concept relationship table? */ 

SELECT COUNT(DISTINCT relationship_id)
FROM concept_relationship

/* 29) How many relationships does Aspirin have? Count the total amount & divided by relationship. */ 

SELECT COUNT(*) AS relationship_amount
FROM concept_relationship cr
JOIN concept c ON cr.concept_id_1 = c.concept_id
OR cr.concept_id_2 = c.concept_id
WHERE c.concept_name = 'Aspirin'; 

/* 30) Using concept & concept relationship tables write a query that shows both relationships and names for Aspirin and related  entities. */ 

SELECT cr.relationship_id AS relationship,
       c1.concept_name AS concept_1_name
       c2.concept_name AS concept_2_name
FROM concept_relationship AS cr
JOIN concept c1 ON cr.concept_id_1 = c1.concept_id
JOIN concept c2 ON cr.concept_id_2 = c2.concept_id
WHERE c1.concept_name = 'Aspirin'
OR c2.concept_name = 'Aspirin' 

/* 31) Write out the differences between concept_relationship and concept_ancestor tables. Compare both general idea of these tables and structures */

/* === 

First, let's start with the general features of these tables. Both tables are designed to identify connections between concepts. Both tables have relational fields for two concepts that belong to the concept table.

However, these tables have the following differences:

1. At the moment when concept_relationship identifies various types of relations, namely hierarchical, associative, and other semantic ones, then concept_ancestor defines hierarchical relations between two concepts, including direct and indirect relations
2. In the concept_ancestor table, in addition to the ID of 2 concepts, there are also fields such as max_levels_of_separation and min_levels_of_separation, which mean the maximum and minimum number of levels that are in the hierarchy between 2 concepts, respectively
3. Instead of similar columns, the concept_relationship table has a relationship_id column, which indicates what kind of relationship the concepts have (shown as the relationship type ID) and refers to the relationship table
4. In addition, the concept_relationship table has fields to indicate the beginning and end of the validity of the relationship (valid_start_date, valid_end_date), as well as a column that indicates the reason for the end of the validity of the relationship (invalid_reason). 

=== */