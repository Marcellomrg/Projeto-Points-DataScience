
WITH tb_transactions AS (

    SELECT *
    FROM transactions
    WHERE dtTransaction < "{date}"
    AND dtTransaction >= DATE("{date}","-21 day")

),

tb_freq AS (

SELECT  idCustomer,
        COUNT(DISTINCT DATE(dtTransaction)) AS qtdDiasD21,
        COUNT(DISTINCT CASE WHEN dtTransaction > DATE("{date}","-14 day") THEN date(dtTransaction) END) AS qtdDiasD14,
        COUNT(DISTINCT CASE WHEN dtTransaction > DATE("{date}","-7 day") THEN date(dtTransaction) END) AS qtdDiasD7

FROM tb_transactions

GROUP BY idCustomer
),

tb_live_minutes AS (
SELECT idCustomer,
        datetime(dtTransaction,"-3 hour") AS dtTransaction,
        min(datetime(dtTransaction,"-3 hour")) AS dtInicio,
        max(datetime(dtTransaction,"-3 hour")) AS dtFim,
        (julianday(max(datetime(dtTransaction,"-3 hour"))) -
        julianday(min(datetime(dtTransaction,"-3 hour"))) * 24 * 60) AS LiveMinutes  


FROM tb_transactions

GROUP BY 1,2

),
tb_hours AS (
SELECT idCustomer,
        AVG(LiveMinutes) AS AVgLiveMinutes,
        SUM(LiveMinutes) AS sumLiveMinutes,
        MIN(LiveMinutes) AS minLiveMinutes,
        MAX(LiveMinutes) AS maxLiveMinutes

FROM tb_live_minutes

GROUP BY idCustomer
),

tb_vida AS (
    SELECT idCustomer,
            count(DISTINCT idTransaction) AS qtdTransacoesVida,
            count(DISTINCT idTransaction)/max(julianday("{date}") - julianday(dtTransaction)) AS AvgTransacaoDia
    FROM transactions
    WHERE dtTransaction < "{date}"

    GROUP BY idCustomer
),

tb_join AS (
SELECT t1.*,
        t2.AVgLiveMinutes,
         t2.sumLiveMinutes,
         t2.minLiveMinutes,
         t2.maxLiveMinutes,
         t3.qtdTransacoesVida,
         t3.AvgTransacaoDia


FROM tb_freq AS t1

LEFT JOIN tb_hours as t2
ON t1.idCustomer = t2.idCustomer

LEFT JOIN tb_vida AS t3
ON t3.idCustomer = t1.idCustomer
)

SELECT 
        "{date}" as dtRef,
        *


FROM tb_join