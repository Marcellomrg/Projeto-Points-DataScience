
WITH t1 as (
    SELECT idCustomer,

         CAST(max(julianday("{date}") - julianday(dtTransaction)) + 1 AS INTEGER ) AS idadeVida,
            SUM(pointsTransaction) as SaldoD21,
            SUM(CASE WHEN 
            dtTransaction>=DATE("{date}","-14 day") 
            THEN pointsTransaction 
            ELSE 0 END) AS SaldoD14,
            SUM(CASE WHEN 
            dtTransaction>=DATE("{date}","-7 day") 
            THEN pointsTransaction 
            ELSE 0 END) AS SaldoD7,
            SUM(CASE WHEN
            pointsTransaction>0
            THEN pointsTransaction
            ELSE 0 END) AS pointsAcumuladosD21,
            SUM(CASE WHEN
            pointsTransaction>0
            AND dtTransaction >= DATE("{date}","-14 day")
            THEN pointsTransaction
            ELSE 0 END) AS pointsAcumuladosD14,
            SUM(CASE WHEN
            pointsTransaction>0
            AND dtTransaction >= DATE("{date}","-7 day")
            THEN pointsTransaction
            ELSE 0 END) AS pointsAcumuladosD7,  
            SUM(CASE WHEN
            pointsTransaction < 0
            THEN pointsTransaction
            ELSE 0 END) AS pointsResgatadosD21,   
            SUM(CASE WHEN
            pointsTransaction < 0
            AND dtTransaction >= DATE("{date}","-14 day")
            THEN pointsTransaction
            ELSE 0 END) AS pointsResgatadosD14,
            SUM(CASE WHEN
            pointsTransaction < 0
            AND dtTransaction >= DATE("{date}","-7 day")
            THEN pointsTransaction
            ELSE 0 END) AS pointsResgatadosD7   


    FROM transactions

    WHERE dtTransaction < "{date}"
    AND dtTransaction >= DATE("{date}","-21 day")

    GROUP BY idCustomer
),
tb_vida AS (
SELECT t1.*,
        sum(t2.pointsTransaction) as saldoVida,
        sum(CASE WHEN t2.pointsTransaction > 0 THEN t2.pointsTransaction ELSE 0 END) AS PointsAcumuladosVida,
        sum(CASE WHEN t2.pointsTransaction < 0 THEN t2.pointsTransaction ELSE 0 END) AS PointsResgatadosVida,
        1.0 * sum(CASE WHEN t2.pointsTransaction > 0 THEN t2.pointsTransaction ELSE 0 END)/idadeVida AS PointsDiaVida

FROM t1

LEFT JOIN transactions as t2 ON t1.idCustomer = t2.idCustomer

WHERE t2.dtTransaction < "{date}"

GROUP BY t1.idCustomer
),

tb_joins AS (
        SELECT t1.*,
                t2.saldoVida,
                t2.PointsAcumuladosVida,
                t2.PointsResgatadosVida,
                t2.PointsDiaVida
        


        FROM t1

        LEFT JOIN tb_vida as t2
        on t1.idCustomer = t2.idCustomer

)

SELECT * FROM tb_joins

