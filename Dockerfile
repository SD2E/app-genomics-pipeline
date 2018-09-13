FROM sd2e/python2:ubuntu16


RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install zip -y \
    && apt-get install unzip -y \
    && apt-get install default-jre -y 


### Install FastQC 0.11.7
RUN curl -LO https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.7.zip \
    && unzip fastqc_v0.11.7.zip \
    && rm fastqc_v0.11.7.zip \
    && mv FastQC /opt/ \
    && chmod +x /opt/FastQC/fastqc 


### Install Trimmomatic 0.36
RUN curl -LO http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.36.zip \
    && unzip Trimmomatic-0.36.zip \
    && rm -f Trimmomatic-0.36.zip \ 
    && mkdir -p /usr/share/licenses/Trimmomatic-0.36 \
    && cp Trimmomatic-0.36/LICENSE /usr/share/licenses/Trimmomatic-0.36/ \
    && mv Trimmomatic-0.36  /opt/


### Install SPAdes 3.11.1
RUN curl -LO http://cab.spbu.ru/files/release3.11.1/SPAdes-3.11.1-Linux.tar.gz \
    && tar -xf SPAdes-3.11.1-Linux.tar.gz \
    && rm SPAdes-3.11.1-Linux.tar.gz \
    && mv SPAdes-3.11.1-Linux /opt


### Install quast 4.6.3
RUN curl -LO https://github.com/ablab/quast/releases/download/quast_4.6.3/quast-4.6.3.tar.gz \
    && tar -xzf quast-4.6.3.tar.gz \
    && rm quast-4.6.3.tar.gz \
    && cd quast-4.6.3 \
    && ./setup.py install \
    && cd / \
    && mv quast-4.6.3 /opt


### Install Augustus and BUSCO
#RUN curl -LO https://gitlab.com/ezlab/busco/-/archive/3.0.2/busco-3.0.2.tar.gz \
#    && tar -xzvf BUSCO_v1.0.tar.gz \
#    && rm BUSCO_v1.0.tar.gz \
#    && sed -i 's/^#!\/bin\/python/#!\/usr\/bin\/env python/' BUSCO_v1.0.py \
#    && chmod +x BUSCO_v1.0.py \
#    && ln -s BUSCO_v1.0.py busco




ADD ./scripts /scripts

ENV PATH="/opt/FastQC:$PATH"
ENV PATH="/opt/Trimmomatic-0.36:$PATH"
ENV PATH="/opt/SPAdes-3.11.1-Linux/bin:$PATH"
ENV PATH="/opt/quast-4.6.3:$PATH"

ENV TRIMMOMATIC=/opt/Trimmomatic-0.36/trimmomatic-0.36.jar
ENV ADAPTERPATH=/opt/Trimmomatic-0.36/adapters



