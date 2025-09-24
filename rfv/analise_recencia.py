# %%
import pandas as pd
import sqlalchemy
import matplotlib.pyplot as plt
from sklearn import tree
# %%
# Carregando meus dados da tabela feature_general

engine = sqlalchemy.create_engine("sqlite:///../data/feature_store.db")

query = "SELECT * FROM features_general Where dtRef = (SELECT max(dtREF) FROM features_general)"

df = pd.read_sql(query,con=engine)
df

# %%
df_recencia = df[["Recencia","idadeBase"]].sort_values(by="Recencia")
df_recencia["unit"] = 1
df_recencia["Acum"] = df_recencia["unit"].cumsum()
df_recencia["Pct"] = df_recencia["Acum"]/df_recencia["Acum"].max()
df_recencia
# %%
# Plotando histograma da minha Recencia
plt.figure(dpi=400)
plt.hist(df_recencia["Recencia"])
plt.xlabel("Recencia")
plt.ylabel("Freq")
plt.title("Analise Recencia")

# %%
plt.figure(dpi=400)
plt.grid(True)
plt.plot(df_recencia["Recencia"],df_recencia["Pct"])
# %%
def ciclo_vida(row):
    if row["idadeBase"] <= 7:
        return "01-Nova"
    elif row["Recencia"] <= 2:
        return "02-Super"
    elif row["Recencia"] <=6:
        return "03-Ativa Comum"
    elif row["Recencia"] <= 12:
        return "04-Ativa Fria"
    elif row["Recencia"] <= 18:
        return "05-Desiludido"
    else:
        return "06-Pre churn"


df_recencia["CicloVida"] = df_recencia.apply(ciclo_vida,axis=1)

df_recencia
# %%
df_recencia.groupby(by=['CicloVida']).agg({"Recencia":["mean","count"],
                                           "idadeBase":["mean"]})
# %%
clf = tree.DecisionTreeClassifier(random_state=42,min_samples_leaf=1,max_depth=None)

clf.fit(df_recencia[["Recencia","idadeBase"]],df_recencia["CicloVida"])
# %%
model = pd.Series({"model":clf,"features":["Recencia","idadeBase"]})

model.to_pickle("../models/cluster_recencia.pkl")
# %%
