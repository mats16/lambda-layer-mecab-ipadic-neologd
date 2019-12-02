FROM lambci/lambda:build-python3.6

RUN yum install -y gcc gcc-c++ git patch && \
    rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm && \
    yum -y install perl-App-cpanminus && \
    cpanm autodie

RUN curl -L "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE" | tar zxv -C ./ && \
    cd ./mecab-0.996 && \
    ./configure --prefix=/opt/mecab --enable-utf8-only && \
    make && \
    make install

ENV PATH=/opt/mecab/bin:$PATH \
    LD_LIBRARY_PATH=/opt/mecab/lib:$LD_LIBRARY_PATH

RUN curl -L "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM" | tar zxv -C ./ && \
    cd ./mecab-ipadic-2.7.0-20070801 && \
    ./configure --prefix=/opt/mecab --enable-utf8-only --with-charset=utf8 && \
    make && \
    make install

ADD src/ ./

RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git ./mecab-ipadic-neologd && \
    python3 ./seed_normalize.py ./mecab-ipadic-neologd/seed/ && \
    ./mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd -y -p $LAMBDA_TASK_ROOT/neologd -n --eliminate-redundant-entry && \
    zip -r /opt/neologd.zip ./neologd

RUN pip install -t /opt/python -r ./requirements.txt

CMD ["/opt/mecab/bin/mecab", "-d", "./neologd"]
#CMD cp -fr /opt/. /mnt/