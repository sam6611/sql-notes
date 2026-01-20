-- LeetCode 178 - Rank Scores
-- Concept: Window Function (DENSE_RANK)

SELECT
    score,
    DENSE_RANK() OVER (ORDER BY score DESC) AS `rank`
FROM Scores;

/*
Test Case:

Input:
Scores
| score |
| 3.50  |
| 3.65  |
| 4.00  |
| 3.85  |
| 4.00  |

Output:
| score | rank |
| 4.00  | 1 |
| 4.00  | 1 |
| 3.85  | 2 |
| 3.65  | 3 |
| 3.50  | 4 |
*/
