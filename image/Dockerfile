FROM registry.clickyab.ae/clickyab/baseimage-go
MAINTAINER fzerorubigd <fzero@rubi.gd>

ADD . /bd_build

RUN /bd_build/helium.sh && \
	/bd_build/cleanup.sh

CMD ["/sbin/my_init"]
