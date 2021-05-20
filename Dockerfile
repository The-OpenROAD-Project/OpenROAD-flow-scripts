FROM centos:centos7

RUN yum update -y \
    && yum group install -y "Development Tools" \
    && yum install -y https://www.klayout.org/downloads/CentOS_7/klayout-0.27-0.x86_64.rpm \
    && yum install -y libXScrnSaver libXft libffi-devel python3 python3-pip qt5-qtbase tcl time which \
    && pip3 install pandas

WORKDIR /OpenROAD-flow-scripts

COPY --from=openroad/yosys /build ./tools/build/yosys
COPY --from=openroad/centos7-builder-gcc /OpenROAD/build ./tools/build/OpenROAD
COPY --from=openroad/centos7-builder-gcc /OpenROAD/etc/DependencyInstaller.sh /etc/DependencyInstaller.sh
RUN /etc/DependencyInstaller.sh -runtime

COPY ./setup_env.sh .
COPY ./flow ./flow
RUN chmod o+rw -R /OpenROAD-flow-scripts
