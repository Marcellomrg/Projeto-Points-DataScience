# %%
import pandas as pd
import sqlalchemy
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn import tree
from sklearn import preprocessing
from sklearn import cluster
# %%
# Carregando meus dados 
engine = sqlalchemy.create_engine("sqlite:///../data/feature_store.db")

query = "SELECT * FROM features_general WHERE dtRef = (SELECT max(dtRef) FROM features_general)"

df = pd.read_sql(query,con=engine)
df

# %%
plt.figure(dpi=400)
sns.set_theme(style="darkgrid")
sns.scatterplot(data=df,x="Valorpoints",y="freqDias")
plt.title("Freq vs ValorPoints")
plt.show()
# %%
# Transformando na mesma escala
minmax = preprocessing.MinMaxScaler()

X_trans = minmax.fit_transform(df[["freqDias","Valorpoints"]])

cluster_method = cluster.AgglomerativeClustering(linkage="ward",n_clusters=5)

cluster_method.fit(X_trans)

df["cluster"] = cluster_method.labels_
df
# %%
plt.figure(dpi=400)

for i in df['cluster'].unique():
    data = df[df["cluster"]==i]
    sns.scatterplot(data=data,x="Valorpoints",y='freqDias')

plt.hlines(7.5,xmin=0,xmax=7000)
plt.hlines(3.5,xmin=0,xmax=7000)
plt.hlines(10.5,xmin=0,xmax=7000)
plt.vlines(500,ymin=0,ymax=18)
plt.vlines(1500,ymin=0,ymax=18)

plt.show()
# %%
df.groupby("cluster")["idCustomer"].count()
# %%
def rf_cluster(row):

    if (row['Valorpoints'] < 500):
        if (row['freqDias'] < 3.5):
            return "01-BB"
    
        elif (row['freqDias'] < 7.5):
            return "02-MB"
        
        elif (row['freqDias'] < 10.5):
            return "03-AB"
        
        else:
            return "04-SB"

    elif (row['Valorpoints'] < 1600):
        if (row['freqDias'] < 3.5):
            return "05-BM"
    
        elif (row['freqDias'] < 7.5):
            return "06-MM"
        
        elif (row['freqDias'] < 10.5):
            return "07-AM"
        
        else:
            return "08-SM"
        
    else:
        if (row['freqDias'] < 3.5):
            return "09-BA"
    
        elif (row['freqDias'] < 7.5):
            return "10-MA"
        
        elif (row['freqDias'] < 10.5):
            return "11-AA"
        
        else:
            return "12-SA"

df['cluster_rf'] = df.apply(rf_cluster, axis=1)
df

# %%
plt.figure(dpi=400)

for i in df['cluster_rf'].unique():
    data = df[df["cluster_rf"]==i]
    sns.scatterplot(data=data,x="Valorpoints",y="freqDias")

plt.title("Cluster Frequencia vs Valor")
plt.legend(df['cluster_rf'].unique())
# %%
clf = tree.DecisionTreeClassifier(random_state=42,min_samples_leaf=1,max_depth=None)

clf.fit(df[["freqDias","Valorpoints"]],df["cluster_rf"])
# %%
model_freq_valor = pd.Series({"model":clf,"features":["freqDias","Valorpoints"]})
# %%
model_freq_valor.to_pickle("../models/cluster_fv.pkl")
# %%
