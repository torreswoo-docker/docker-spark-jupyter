FROM sangwonl/hadoop-spark:latest

MAINTAINER Sangwon Lee <gamzabaw@gmail.com>

RUN apt-get update &&  \
    apt-get install -y \
        python3-pip    \
        locales

# locales
RUN locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# python packages
RUN pip3 install --upgrade \
    pip                    \
    notebook               \
    hide_code              \
    matplotlib             \
    plotly                 \
    pandas                 \
    numpy                  \
    pymysql                \
    sqlalchemy             \
    boto                   \
    tensorflow             \
    scipy                  \
    scikit-learn           \
    statsmodels            \
    sympy

# jupyter configuration
ADD jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py

# notebook extensions
RUN jupyter nbextension install --py hide_code && \
    jupyter nbextension enable --py hide_code && \
    jupyter serverextension enable --py hide_code

# spark configuration
ADD spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf

# toree scala kernel
RUN pip install https://dist.apache.org/repos/dist/dev/incubator/toree/0.2.0/snapshots/dev1/toree-pip/toree-0.2.0.dev1.tar.gz
RUN jupyter toree install         \
    --spark_home=$SPARK_HOME      \
    --spark_opts='--master=yarn'  \
    --kernel_name=scala           \
    --interpreters=Scala
RUN mv /usr/local/share/jupyter/kernels/scala_scala /usr/local/share/jupyter/kernels/scala

# add kernel configurations
ADD kernels/python3/kernel.json /usr/local/share/jupyter/kernels/python3/kernel.json
ADD kernels/pyspark/kernel.json /usr/local/share/jupyter/kernels/pyspark/kernel.json
ADD kernels/scala/kernel.json /usr/local/share/jupyter/kernels/scala/kernel.json

RUN mkdir -p /opt/notebooks

VOLUME /opt/notebooks

EXPOSE 8000

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8000", "--notebook-dir=/opt/notebooks", "--allow-root"]

