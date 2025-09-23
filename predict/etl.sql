
SELECT 

        t1.dtRef,
        t1.idCustomer,
        t1.qtdPointsManha,
        t1.qtdPointsTarde,
        t1.qtdPointsNoite,
        t1.pctPointsManha,
        t1.pctPointsTarde,
        t1.pctPointsNoite,
        t1.qtdTransacoesManha,
        t1.qtdTransacoesTarde,
        t1.qtdTransacoesNoite,
        t1.pctTransacoesManha,
        t1.pctTransacoesTarde,
        t1.pctTransacoesNoite,
        
        t3.qntPresenca,
        t3.qntChatMessage,
        t3.qntCerveja,
        t3.qntBolo,
        t3.qntBatata,
        t3.qntTorta,
        t3.qntCocaCola,
        t3.qntPonei,
        t3.qntStreamElements,
        t3.qntStreak,
        t3.qntAirLover,
        t3.qntRLover,
        t3.qntChurn5pp,
        t3.qntChurn2pp,
        t3.qntChurn10pp,
        t3.PointsPresenca,
        t3.PointsChatMessage,
        t3.PointsCerveja,
        t3.PointsBolo,
        t3.PointsBatata,
        t3.PointsTorta,
        t3.PointsCocaCola,
        t3.PointsPonei,
        t3.PointsStreamElements,
        t3.PointsStreak,
        t3.PointsAirLover,
        t3.PointsRLover,
        t3.PointsChurn5pp,
        t3.PointsChurn2pp,
        t3.PointsChurn10pp,
        t3.pctPresenca,
        t3.pctChatMessage,
        t3.pctCerveja,
        t3.pctBolo,
        t3.pctBatata,
        t3.pctTorta,
        t3.pctCocaCola,
        t3.pctPonei,
        t3.pctStreamElements,
        t3.pctStreak,
        t3.pctAirLover,
        t3.pctRLover,
        t3.pctChurn5pp,
        t3.pctChurn2pp,
        t3.pctChurn10pp,
        t3.AvgChatLive,
        t3.productmax,

        
        t4.qtdDiasD21,
        t4.qtdDiasD14,
        t4.qtdDiasD7,
        t4.AVgLiveMinutes,
        t4.sumLiveMinutes,
        t4.minLiveMinutes,
        t4.maxLiveMinutes,
        t4.qtdTransacoesVida,
        t4.AvgTransacaoDia,

        t5.Recencia,
        t5.freqDias,
        t5.Valorpoints,
        t5.idadeBase,
        t5.flEmail,

        
        t6.saldoPointsD21,
        t6.saldoPointsD14,
        t6.saldoPointsD7,
        t6.pointsAcumuladosD21,
        t6.pointsAcumuladosD14,
        t6.pointsAcumuladosD7,
        t6.pointsResgatadosD21,
        t6.pointsResgatadosD14,
        t6.pointsResgatadosD7,
        t6.saldoPoints,
        t6.PointsAcumuladosVida,
        t6.PointsResgatadosVida,
        t6.pointsPorDia




FROM feature_horario as t1


LEFT JOIN feature_produtos as t3
ON t1.idCustomer = t3.idCustomer
AND t1.dtRef = t3.dtRef


LEFT JOIN feature_transacoes as t4
ON t1.idCustomer = t4.idCustomer
AND t1.dtRef = t4.dtRef

LEFT JOIN features_general as t5
ON t1.idCustomer = t5.idCustomer
AND t1.dtRef = t5.dtRef

LEFT JOIN features_points as t6
ON t1.idCustomer = t6.idCustomer
AND t1.dtRef = t6.dtRef

WHERE t1.dtRef = DATE('2024-06-06','-21 day')





