## Pre-requisite

There should be a bridge network named as `hadoop` where hadoop cluster runs on.

```
$ docker network create -d bridge hadoop
```

## Run spark integrated jupyter container in hadoop network

```
$ docker run -it --network hadoop --env-file hadoop.env -p 8000:8000 sangwonl/hadoop-spark-jupyter
```

## Distribute archive of spark jars to HDFS
Bundle jar files into one jar and put it to HDFS.
```
$ jar cv0f spark-libs.jar -C $SPARK_HOME/jars/ .
$ hdfs dfs -put spark-libs.jar /libs/
```

And set `spark.yarn.archive` in `$SPARK_HOME/conf/spark-defaults.conf` to the hdfs path you put.
```
spark.yarn.archive hdfs://namenode:8020/libs/spark-libs.jar
```

## Jupyter Token

Jupyter `token` is described in jupyter_notebook_config.py with the key named as `c.NotebookApp.token`. You can change it when building docker image.
