# %%
import mlflow
import pandas as pd
import sqlalchemy
from sklearn import model_selection
from feature_engine import encoding
from sklearn import ensemble
from sklearn import pipeline
from sklearn import metrics
mlflow.set_tracking_uri("http://127.0.0.1:5000")
mlflow.set_experiment(experiment_name="churn_exp")
import datetime
from tqdm import tqdm
# %%
# CARREGANDO MEUS DADOS DA MINHA TABELA ABT

engine = sqlalchemy.create_engine("sqlite:///../../data/feature_store.db")

with open("abt.sql","r") as open_file:
    query = open_file.read()

df = pd.read_sql(query,con=engine)
df.head()
# %%
# SAMPLE
# Separando Minha base OOT da base treino e teste
df_oot = df[df["dtRef"]==df["dtRef"].max()]

df_base = df[df["dtRef"]<df["dtRef"].max()]

# %%
features = df.columns.to_list()[3:]
target = 'flChurn'
# %%
# Separando minha base entre treino e teste
x_train,x_test,y_train,y_test = model_selection.train_test_split(df_base[features]
                                                                 ,df_base[target]
                                                                 ,train_size=0.8
                                                                 ,random_state=42
                                                                 ,stratify=df_base[target])
print("Taxa da variavel Resposta",y_train.mean())
print("Taxa da variavel Resposta",y_test.mean())

# %%
# EXPLORE
# Explorando se tem dado missing
missing = x_train.isna().sum().max()

# %%
# Explorando minhas variavesi categoricas e numericas
cat_feat = x_train.columns[x_train.dtypes == 'object'].to_list()

num_feat = x_train.columns[x_train.dtypes != 'object'].to_list()

# %%

# MODEL
# Modelando meu modelo de Machine Learning

def metricas(y_true,predict_proba,base):

        y_predict = (predict_proba[:,1] > 0.5).astype(int)

        roc_auc = metrics.roc_auc_score(y_true,predict_proba[:,1])
        precision = metrics.precision_score(y_true,y_predict)
        acc = metrics.accuracy_score(y_true,y_predict)
        recall = metrics.recall_score(y_true,y_predict)

        return {f"{base} roc_auc":roc_auc
                ,f"{base} precision":precision
                ,f"{base} acc":acc
                ,f"{base} recall":recall}

with mlflow.start_run():

    mlflow.sklearn.autolog()
    
    one_hot = encoding.OneHotEncoder(variables=cat_feat,drop_last=True)
    model = ensemble.RandomForestClassifier(random_state=42)

    params = {
            "n_estimators":[100,200,300]
            ,"criterion":['gini','entropy','log_loss']
            ,"min_samples_leaf":[10,15,20,25]
            ,"max_depth":[5,10,15,20]
    }

    grid = model_selection.GridSearchCV(param_grid=params
                                        ,estimator=model
                                        ,scoring="roc_auc"
                                        ,cv=3
                                        ,n_jobs=2
                                            )

    model_pipeline = pipeline.Pipeline([("One_hot",one_hot)
                                        ,("Grid",grid)])

    model_pipeline.fit(x_train,y_train)

    predict_proba_train = model_pipeline.predict_proba(x_train)
    predict_proba_test = model_pipeline.predict_proba(x_test)
    predict_proba_oot = model_pipeline.predict_proba(df_oot[features])

    report = {}
    report.update(metricas(y_train,predict_proba_train,"train"))
    report.update(metricas(y_test,predict_proba_test,"test"))
    report.update(metricas(df_oot[target],predict_proba_oot,"oot"))

    mlflow.log_metrics(report)
  



# %%
