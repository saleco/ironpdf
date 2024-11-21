
FROM public.ecr.aws/lambda/python:3.8.2024.02.07.18

ARG EFS_DIR="/mnt/sftp-decoder"
ENV EFS_DIR=${EFS_DIR}
ENV LAMBDA_TASK_ROOT="/var/task"
# Copy in the build image dependencies
COPY sample.pdf test.py requirements.txt  ${LAMBDA_TASK_ROOT}/

# Update nss-sysinit, nss, and nss-tools
RUN yum update -y nss-sysinit nss nss-tools

# Update pip to specific version 23.3
RUN pip install --upgrade pip==23.3

# Update setuptools to specific version 65.5.1
RUN pip install --upgrade setuptools==65.5.1 

RUN pip install \
        --target ${LAMBDA_TASK_ROOT} \
	    -r ${LAMBDA_TASK_ROOT}/requirements.txt && \
	    mkdir -p ${EFS_DIR} 

RUN yum install -y wget tar gzip vi
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
RUN chmod +x ./dotnet-install.sh
RUN ./dotnet-install.sh --channel 6.0 --install-dir ${LAMBDA_TASK_ROOT}/.dotnet

RUN chmod 775 -R /root
RUN chmod 775 -R ${LAMBDA_TASK_ROOT}
ENV DOTNET_ROOT=${LAMBDA_TASK_ROOT}/.dotnet
ENV PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

CMD [ "app.handler" ]
