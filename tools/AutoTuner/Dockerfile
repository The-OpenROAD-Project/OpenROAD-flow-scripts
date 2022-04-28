FROM rayproject/ray:1.11.0

RUN pip install -U ax-platform hyperopt nevergrad optuna pandas

RUN sudo apt-get update -y \
    && sudo apt-get install -y vim htop gcc time libffi-dev \
    && wget https://www.klayout.org/downloads/Ubuntu-20/klayout_0.27.1-1_amd64.deb \
    && sudo apt-get install -y --fix-broken ./klayout_0.27.1-1_amd64.deb \
    && rm ./klayout_0.27.1-1_amd64.deb

RUN wget https://raw.githubusercontent.com/The-OpenROAD-Project/OpenROAD/master/etc/DependencyInstaller.sh \
    && sudo bash ./DependencyInstaller.sh -dev \
    && rm DependencyInstaller.sh
