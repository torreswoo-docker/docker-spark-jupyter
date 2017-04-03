## Pre-requisite

There should be a bridge network named as `hadoop` where hadoop cluster runs on.

```
$ docker network create -d bridge hadoop
```

## Run spark integrated jupyter container in hadoop network

```
$ docker run -it --network hadoop --env-file hadoop.env -p 8000:8000 sangwonl/hadoop-spark-jupyter
```

## Jupyter Token

Jupyter `token` is described in jupyter_notebook_config.py with the key named as `c.NotebookApp.token`. You can change it when building docker image.
