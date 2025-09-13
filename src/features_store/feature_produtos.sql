
WITH tb_transactions AS (

    SELECT t1.*,
                t2.NameProduct,
                t2.QuantityProduct

    FROM transactions as t1

    LEFT JOIN transactions_product as t2
    ON t1.idTransaction = t2.idTransaction

    WHERE dtTransaction < "{date}"
    AND dtTransaction >= DATE("{date}","-21 day")
),

tb_share AS (

    SELECT idCustomer,
            SUM(CASE WHEN NameProduct = "Lista de presença" THEN QuantityProduct ELSE 0 END) AS qntPresença,
            SUM(CASE WHEN NameProduct = "ChatMessage" THEN QuantityProduct ELSE 0 END) AS qntChatMessage,
            SUM(CASE WHEN NameProduct = "Cerveja" THEN QuantityProduct ELSE 0 END) AS qntCerveja,
            SUM(CASE WHEN NameProduct = "Bolo" THEN QuantityProduct ELSE 0 END) AS qntBolo,
            SUM(CASE WHEN NameProduct = "Batata" THEN QuantityProduct ELSE 0 END) AS qntBatata,
            SUM(CASE WHEN NameProduct = "Torta" THEN QuantityProduct ELSE 0 END) AS qntTorta,
            SUM(CASE WHEN NameProduct = "Coca Cola" THEN QuantityProduct ELSE 0 END) AS qntCocaCola,
            SUM(CASE WHEN NameProduct = "Resgatar Ponei" THEN QuantityProduct ELSE 0 END) AS qntPonei,
            SUM(CASE WHEN NameProduct = "Troca de Pontos StreamElements" THEN QuantityProduct ELSE 0 END) AS qntStreamElements,
            SUM(CASE WHEN NameProduct = "Presença Streak" THEN QuantityProduct ELSE 0 END) AS qntStreak,
            SUM(CASE WHEN NameProduct = "Airflow Lover" THEN QuantityProduct ELSE 0 END) AS qntAirLover,
            SUM(CASE WHEN NameProduct = "R Lover" THEN QuantityProduct ELSE 0 END) AS qntRLover,
            SUM(CASE WHEN NameProduct = "Churn_5pp" THEN QuantityProduct ELSE 0 END) AS qntChurn5pp,
            SUM(CASE WHEN NameProduct = "Churn_2pp" THEN QuantityProduct ELSE 0 END) AS qntChurn2pp,
            SUM(CASE WHEN NameProduct = "Churn_10pp" THEN QuantityProduct ELSE 0 END) AS qntChurn10pp,
            
            SUM(CASE WHEN NameProduct = "Lista de presença" THEN pointsTransaction ELSE 0 END) AS PointsPresença,
            SUM(CASE WHEN NameProduct = "ChatMessage" THEN pointsTransaction ELSE 0 END) AS PointsChatMessage,
            SUM(CASE WHEN NameProduct = "Cerveja" THEN pointsTransaction ELSE 0 END) AS PointsCerveja,
            SUM(CASE WHEN NameProduct = "Bolo" THEN pointsTransaction ELSE 0 END) AS PointsBolo,
            SUM(CASE WHEN NameProduct = "Batata" THEN pointsTransaction ELSE 0 END) AS PointsBatata,
            SUM(CASE WHEN NameProduct = "Torta" THEN pointsTransaction ELSE 0 END) AS PointsTorta,
            SUM(CASE WHEN NameProduct = "Coca Cola" THEN pointsTransaction ELSE 0 END) AS PointsCocaCola,
            SUM(CASE WHEN NameProduct = "Resgatar Ponei" THEN pointsTransaction ELSE 0 END) AS PointsPonei,
            SUM(CASE WHEN NameProduct = "Troca de Pontos StreamElements" THEN pointsTransaction ELSE 0 END) AS PointsStreamElements,
            SUM(CASE WHEN NameProduct = "Presença Streak" THEN pointsTransaction ELSE 0 END) AS PointsStreak,
            SUM(CASE WHEN NameProduct = "Airflow Lover" THEN pointsTransaction ELSE 0 END) AS PointsAirLover,
            SUM(CASE WHEN NameProduct = "R Lover" THEN pointsTransaction ELSE 0 END) AS PointsRLover,
            SUM(CASE WHEN NameProduct = "Churn_5pp" THEN pointsTransaction ELSE 0 END) AS PointsChurn5pp,
            SUM(CASE WHEN NameProduct = "Churn_2pp" THEN pointsTransaction ELSE 0 END) AS PointsChurn2pp,
            SUM(CASE WHEN NameProduct = "Churn_10pp" THEN pointsTransaction ELSE 0 END) AS PointsChurn10pp,

            1.0 * SUM(CASE WHEN NameProduct = "Lista de presença" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) AS pctPresença,
            1.0 * SUM(CASE WHEN NameProduct = "ChatMessage" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) AS pctChatMessage,
            1.0 * SUM(CASE WHEN NameProduct = "Cerveja" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) AS pctCerveja,
            1.0 * SUM(CASE WHEN NameProduct = "Bolo" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) AS pctBolo,
            1.0 * SUM(CASE WHEN NameProduct = "Batata" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) AS pctBatata,
            1.0 * SUM(CASE WHEN NameProduct = "Torta" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) AS pctTorta,
            1.0 * SUM(CASE WHEN NameProduct = "Coca Cola" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) AS pctCocaCola,
            1.0 * SUM(CASE WHEN NameProduct = "Resgatar Ponei" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) AS pctPonei,
            1.0 * SUM(CASE WHEN NameProduct = "Troca de Pontos StreamElements" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) AS pctStreamElements,
            1.0 * SUM(CASE WHEN NameProduct = "Presença Streak" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) AS pctStreak,
            1.0 * SUM(CASE WHEN NameProduct = "Airflow Lover" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) AS pctAirLover,
            1.0 * SUM(CASE WHEN NameProduct = "R Lover" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) AS pctRLover,
            1.0 * SUM(CASE WHEN NameProduct = "Churn_5pp" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) AS pctChurn5pp,
            1.0 * SUM(CASE WHEN NameProduct = "Churn_2pp" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) AS pctChurn2pp,
            1.0 * SUM(CASE WHEN NameProduct = "Churn_10pp" THEN QuantityProduct ELSE 0 END)/SUM(QuantityProduct) AS pctChurn10pp,

            1.0 * SUM(CASE WHEN NameProduct = "ChatMessage" THEN QuantityProduct ELSE 0 END)/COUNT(DISTINCT DATE(dtTransaction)) AS AvgChatLive

    FROM tb_transactions

    GROUP BY idCustomer
),

tb_group AS (

    SELECT idCustomer,
            NameProduct,
            sum(QuantityProduct) as qtde,
            sum(pointsTransaction) as points

    FROM tb_transactions
    GROUP BY idCustomer,NameProduct
),

tb_rn AS (

SELECT *,
        ROW_NUMBER() OVER (PARTITION BY idCustomer ORDER BY qtde DESC,points DESC) AS rnqtde


FROM tb_group
),

tb_produto_max AS (
SELECT *
FROM tb_rn
WHERE rnqtde = 1
)

SELECT  "{date}" as dtRef,
        t1.*,
        t2.NameProduct AS productmax

FROM tb_share as t1

LEFT JOIN tb_produto_max as t2
ON t1.idCustomer = t2.idCustomer