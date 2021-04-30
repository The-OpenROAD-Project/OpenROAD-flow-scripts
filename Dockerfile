FROM centos:centos7

RUN yum update -y \
    && yum group install -y "Development Tools" \
    && yum install -y https://www.klayout.org/downloads/CentOS_7/klayout-0.26.4-0.x86_64.rpm \
    && yum install -y libXScrnSaver libXft libffi-devel python3 qt5-qtbase tcl time which

RUN yum install -y python3-pip \
    && pip3 install pandas

WORKDIR /OpenROAD-flow-scripts

COPY --from=openroad/yosys /build ./tools/build/yosys
COPY --from=openroad/centos7-builder-gcc /OpenROAD/build ./tools/build/OpenROAD
COPY --from=openroad/centos7-builder-gcc /OpenROAD/etc/DependencyInstaller.sh /etc/DependencyInstaller.sh

RUN /etc/DependencyInstaller.sh -runtime
COPY ./setup_env.sh .
COPY ./flow ./flow
RUN chmod o+rw -R /OpenROAD-flow-scripts
