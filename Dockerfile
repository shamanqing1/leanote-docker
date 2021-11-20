FROM golang:bullseye

RUN sed -i "s/deb.debian.org/mirrors.bfsu.edu.cn/g" /etc/apt/sources.list \
 && sed -i "s/security.debian.org/mirrors.bfsu.edu.cn/g" /etc/apt/sources.list


RUN apt-get update \
    && apt-get install -y \
    python \
    && rm -rf /var/lib/apt/lists/*

RUN echo "go: $(go version)"
#RUN echo "Npm: $(npm --version)"

ARG user=leanote

RUN useradd --create-home --shell /bin/bash $user
USER $user

COPY --chown=$user:$user leanote/ /home/$user/leanote

WORKDIR /home/$user/leanote

RUN go env -w GOPROXY=https://goproxy.cn,direct \
 && go env -w GO111MODULE=on

RUN go get -u github.com/revel/cmd/revel

ENV RUNNING_IN_DOCKER=1
EXPOSE ${APP_PORT}

CMD [ "revel", "run", "-a", "." ]
