FROM sangwonl/hadoop-spark:2.1.0

MAINTAINER Sangwon Lee <gamzabaw@gmail.com>

RUN apt-get update &&   \
    apt-get install -y  \
        python3-pip     \
        locales

# locales
RUN locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# python packages
RUN pip3 install --upgrade pip
RUN pip3 install     \
         notebook    \
         matplotlib  \
         plotly      \
         pandas      \
         numpy       \
         pymysql     \
         sqlalchemy  \
         boto

ADD kernel.json /usr/local/share/jupyter/kernels/pyspark/kernel.json
ADD jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py

RUN mkdir -p /opt/notebooks
VOLUME /opt/notebooks

EXPOSE 8000

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8000", "--notebook-dir=/opt/notebooks", "--allow-root"]

