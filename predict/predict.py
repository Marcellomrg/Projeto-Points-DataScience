# %%
import pandas as pd
import sqlalchemy
from sqlalchemy import exc
# %%
# Carregando meu modelo
model = pd.read_pickle("../models/Modelo_marcello.pkl")
model
# %%
# Carregando meus dados oot
with open("etl.sql","r") as open_file:
    query = open_file.read()

engine = sqlalchemy.create_engine("sqlite:///../data/feature_store.db") 
# %%
df = pd.read_sql(query,con=engine)
df
# %%
predict = model['Model'].predict_proba(df[model['features']])
proba_churn = predict[:,1]
proba_churn
# %%
df_predict = df[["dtRef","idCustomer"]].copy()
df_predict['probaChurn'] = proba_churn.copy()
df_predict = (df_predict.sort_values("probaChurn",ascending=False)
              .reset_index(drop=True))
df_predict
# %%
with engine.connect() as con:
    state = f"DELETE FROM tb_churn WHERE dtRef = '{df_predict["dtRef"].min()}'  "

    try:
        state = sqlalchemy.text(state)
        con.execute(state)
        con.commit()
    except exc.OperationalError as err:
        print("Tabela nao existe,criando.....")


df_predict.to_sql("tb_churn",engine,if_exists='append',index=False)

# %%
