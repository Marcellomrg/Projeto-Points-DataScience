WITH tb_rfv AS (

    SELECT idCustomer,

            CAST(min(julianday("{date}") - julianday(dtTransaction)) + 1 AS INTEGER ) AS Recencia,
            COUNT(DISTINCT DATE(dtTransaction)) as freqDias,
            SUM(CASE WHEN pointsTransaction>0 THEN pointsTransaction END) AS Valorpoints




    FROM transactions

    WHERE DATE(dtTransaction) < "{date}"
    AND DATE(dtTransaction)>= DATE("{date}","-21 days")

    GROUP BY idCustomer
    ),


tb_idade AS (

    SELECT t1.*,
            CAST(max(julianday("{date}") - julianday(dtTransaction)) + 1 AS INTEGER ) AS idadeBase


    FROM tb_rfv AS t1

    LEFT JOIN transactions as t2 ON t1.idCustomer = t2.idCustomer

    GROUP BY t1.idCustomer
)

SELECT 
            '{date}' AS dtref,
            t1.*,
            t2.idadeBase,
            t3.flEmail


FROM tb_rfv as t1

LEFT JOIN tb_idade as t2 ON t1.idCustomer = t2.idCustomer

LEFT JOIN customers as t3 ON t3.idCustomer = t2.idCustomer


