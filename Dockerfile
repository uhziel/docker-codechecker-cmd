FROM ubuntu:20.04

RUN apt-get update \
    && apt-get -y install clang clang-tidy build-essential curl gcc-multilib \
      git python3-dev python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN cd /opt \
    && git clone https://github.com/Ericsson/codechecker.git --depth 1 \
    && cd codechecker \
    && make venv \
    && source venv/bin/activate \
    && BUILD_LOGGER_64_BIT_ONLY=YES BUILD_UI_DIST=NO make package

ENV PATH="/opt/codechecker/build/CodeChecker/bin:$PATH"

ENTRYPOINT ["CodeChecker"]
CMD ["version"]
