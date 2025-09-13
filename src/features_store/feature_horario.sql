
WITH tb_transactions_hour AS (
    SELECT idCustomer,
                pointsTransaction,
                CAST(STRFTIME('%H',DATETIME(dtTransaction,'-3 hour')) AS INTEGER) AS  hour

    FROM transactions

    WHERE dtTransaction < "{date}"
    AND dtTransaction >= DATE("{date}","-21 day")

    GROUP BY idCustomer
),

tb_share AS (

SELECT idCustomer,
        SUM(CASE WHEN hour>= 8 AND hour < 12 THEN abs(pointsTransaction) ELSE 0 END) as qtdPointsManha,
        SUM(CASE WHEN hour>= 12 AND hour < 18 THEN abs(pointsTransaction) ELSE 0 END) as qtdPointsTarde,
        SUM(CASE WHEN hour>= 18 AND hour < 23 THEN abs(pointsTransaction) ELSE 0 END) as qtdPointsNoite,

       1.0 * SUM(CASE WHEN hour>= 8 AND hour < 12 THEN abs(pointsTransaction) ELSE 0 END)  / sum(abs(pointsTransaction))as pctPointsManha,
       1.0 * SUM(CASE WHEN hour>= 12 AND hour < 18 THEN abs(pointsTransaction) ELSE 0 END) / sum(abs(pointsTransaction)) as pctPointsTarde,
       1.0 * SUM(CASE WHEN hour>= 18 AND hour < 23 THEN abs(pointsTransaction) ELSE 0 END) / sum(abs(pointsTransaction)) as pctPointsNoite,

       SUM(CASE WHEN hour>= 8 AND hour < 12 THEN 1 ELSE 0 END) as qtdTransacoesManha,
        SUM(CASE WHEN hour>= 12 AND hour < 18 THEN 1 ELSE 0 END) as qtdTransacoesTarde,
        SUM(CASE WHEN hour>= 18 AND hour < 23 THEN 1 ELSE 0 END) as qtdTransacoesNoite,

       1.0 * SUM(CASE WHEN hour>= 8 AND hour < 12 THEN 1 ELSE 0 END)  / sum(1)as pctTransacoesManha,
       1.0 * SUM(CASE WHEN hour>= 12 AND hour < 18 THEN 1 ELSE 0 END) / sum(1) as pctTransacoesTarde,
       1.0 * SUM(CASE WHEN hour>= 18 AND hour < 23 THEN 1 ELSE 0 END) / sum(1) as pctTransacoesNoite


FROM tb_transactions_hour

GROUP BY idCustomer
)

SELECT 
"{date}" AS dtRef,
                    *

FROM tb_share