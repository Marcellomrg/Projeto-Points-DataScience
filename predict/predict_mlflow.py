# %%
import pandas as pd
import sqlalchemy
import mlflow
import mlflow.sklearn
from sqlalchemy import exc
mlflow.set_tracking_uri("http://127.0.0.1:5000")
# %%
# Carregando minha ABT
engine = sqlalchemy.create_engine("sqlite:///../data/feature_store.db")

with open("etl.sql","r") as open_file:
    query = open_file.read()

df = pd.read_sql(query,con=engine)
df
# %%
# Carregando meu modelo do MLflow
model = mlflow.sklearn.load_model("models:/model_churn/1")

# Carregando as features do meu modelo

features = model.feature_names_in_
features

# %%
# Fazendo meu predict
predict_proba = model.predict_proba(df[features])
proba_churn = predict_proba[:,1]

# %%
df_predict = df[["dtRef","idCustomer"]].copy()
df_predict["probaChurn"] = proba_churn.copy()
df_predict = (df_predict.sort_values("probaChurn",ascending=False)
              .reset_index(drop=True))
df_predict
# %%
with engine.connect() as con:
    state = f"DELETE FROM tb_churn WHERE dtRef = '{df_predict["dtRef"].min()}'"

    try:
        state = sqlalchemy.text(state)
        con.execute(state)
        con.commit()
    except exc.OperationalError as err:
        print("Tabela nao existe,criando.....")

df_predict.to_sql("tb_churn",con=engine,if_exists='append',index=False)


# %%
