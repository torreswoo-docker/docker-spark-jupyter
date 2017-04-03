FROM sangwonl/hadoop-base:latest

MAINTAINER Sangwon Lee <gamzabaw@gmail.com>

RUN apt-get update &&   \
    apt-get install -y  \
        python-pip

ENV SPARK_VERSION 2.1.0
ENV SPARK_URL http://d3kbcqa49mib13.cloudfront.net/spark-$SPARK_VERSION-bin-hadoop2.7.tgz
RUN set -x \
    && curl -fSL "$SPARK_URL" -o /tmp/spark.tgz \
    && tar -xvf /tmp/spark.tgz -C /opt/ \
    && rm /tmp/spark.tgz \
    && mv /opt/spark-$SPARK_VERSION-bin-hadoop2.7 /opt/spark

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV SPARK_HOME=/opt/spark

RUN pip install     \
        jupyter     \
        matplotlib  \
        plotly

ADD kernel.json /usr/local/share/jupyter/kernels/pyspark/kernel.json
ADD jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py

ENV JUPYTER_PORT=8000
ENV JUPYTER_NOTEBOOK_HOME=/opt/notebooks
RUN mkdir -p $JUPYTER_NOTEBOOK_HOME
VOLUME /opt/notebooks

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]
