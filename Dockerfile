FROM broadinstitute/cromwell:57
RUN apt-get update -y && \
	apt-get install -y curl git wget
WORKDIR /recipes
ENV GIT_SSL_NO_VERIFY=true
RUN git clone https://github.com/stjudecloud/workflows.git
WORKDIR /opt
ENV PROGRAMS /opt
ENV SAMTOOLS_VERSION=1.3.1

## Install SAMTOOLS
RUN apt-get install -y autoconf automake make gcc perl zlib1g-dev libbz2-dev liblzma-dev libcurl4-gnutls-dev libssl-dev libncurses5-dev && \
	cd ${PROGRAMS}  && \ 
	wget --no-check-certificate https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 -O samtools.tar.bz2 && \
	tar -xjvf samtools.tar.bz2 && \
	cd samtools-${SAMTOOLS_VERSION} && \
	make
ENV PATH $PATH:${PROGRAMS}/samtools-${SAMTOOLS_VERSION} 
## Install BCFTOOLS
RUN cd ${PROGRAMS} && \
	wget --no-check-certificate https://github.com/samtools/bcftools/releases/download/${SAMTOOLS_VERSION}/bcftools-${SAMTOOLS_VERSION}.tar.bz2 -O bcftools.tar.bz2 && \
	tar -xjvf bcftools.tar.bz2 && \
	cd bcftools-${SAMTOOLS_VERSION} && \
	make
ENV PATH $PATH:${PROGRAMS}/bcftools-${SAMTOOLS_VERSION} 
## Install HTSLIB
RUN cd ${PROGRAMS} && \
	wget --no-check-certificate https://github.com/samtools/htslib/releases/download/${SAMTOOLS_VERSION}/htslib-${SAMTOOLS_VERSION}.tar.bz2 -O htslib.tar.bz2 && \
	tar -xjvf htslib.tar.bz2 && \
	cd htslib-${SAMTOOLS_VERSION} && \
	make && \
	make install
ENV PATH $PATH:${PROGRAMS}/htslib-${SAMTOOLS_VERSION} 

## get picard
RUN cd ${PROGRAMS} && \
	wget --no-check-certificate https://github.com/broadinstitute/picard/releases/download/2.25.0/picard.jar
ENV PATH $PATH:${PROGRAMS}

## Install fq
ENV RUSTUP_HOME=/opt/rustup
ENV CARGO_HOME=/opt/cargo
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH $PATH:${RUSTUP_HOME}:${CARGO_HOME}/bin
RUN apt-get install -y tar
RUN cd ${PROGRAMS} && \
	wget --no-check-certificate https://github.com/stjude/fqlib/releases/download/v0.6.0/fqlib-0.6.0-x86_64-unknown-linux-gnu.tar.gz && \
	tar -xvf fqlib-0.6.0-x86_64-unknown-linux-gnu.tar.gz
ENV PATH $PATH:${PROGRAMS}/fqlib-0.6.0-x86_64-unknown-linux-gnu

### copy wrapper script
RUN apt-get install -y python3-dev
COPY *py /opt

### copy modified WDL workflows
WORKDIR /modified_workflows
COPY *wdl /modified_workflows/
COPY *json /modified_workflows/
ENV PATH $PATH:/modified_workflows
ENTRYPOINT [""]
