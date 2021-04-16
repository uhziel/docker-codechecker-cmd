FROM ubuntu:20.04

RUN apt-get update \
    && apt-get -y install clang clang-tidy build-essential curl gcc-multilib \
      git python3-dev python3-pip python3-venv \
    && pip3 install thrift \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV http_proxy="http://192.168.1.133:7890"
ENV https_proxy="http://192.168.1.133:7890"
RUN cd /opt \
    && git clone https://github.com/Ericsson/codechecker.git --depth 1 \
    && cd codechecker \
    && make venv \
    && . venv/bin/activate \
    && BUILD_LOGGER_64_BIT_ONLY=YES BUILD_UI_DIST=NO make package
RUN echo '. /opt/codechecker/venv/bin/activate' >> /root/.bashrc
ENV http_proxy=""
ENV https_proxy=""

ENV PATH="/opt/codechecker/build/CodeChecker/bin:$PATH"

ENTRYPOINT ["CodeChecker"]
CMD ["version"]
