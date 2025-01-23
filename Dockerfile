ARG BASE_IMAGE=quay.io/jupyter/scipy-notebook:2024-07-29

FROM ${BASE_IMAGE}

# Install packages via conda (issues w/ deepvariant & pyseer)
RUN mamba install -y -c conda-forge -n base biopython pytest \
 && mamba install -y -c bioconda -n base \
    fastp \
    samtools \
    bwa \
    varscan \
    bcftools \
    mummer \
    ensembl-vep \
    goalign \
    gotree \
    modeltest-ng \
    raxml-ng \
    spades \
    mafft \
    trimmomatic \
    bowtie2 \
    pyseer \
 && mamba install -y -c manics -n base websockify

USER root

# Install desktop OS dependencies
RUN apt-get -y update \
 && apt-get -y install \
    dbus-x11 \
    xfce4 \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xorg \
    xubuntu-icon-theme \
    tigervnc-standalone-server \
    tigervnc-xorg-extension \
 && apt clean \
 && rm -rf /var/lib/apt/lists/* \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

# Download and install latest VS Code
RUN wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" \
    -O /opt/vscode-latest.deb \
 && apt-get install -y /opt/vscode-latest.deb \
 && rm /opt/vscode-latest.deb \
 && echo -e "[Desktop Entry]\nName=Visual Studio Code\nComment=Code Editing. Redefined.\nGenericName=Text Editor\nExec=/usr/share/code/code --disable-dev-shm-usage --unity-launch %F\nIcon=vscode\nType=Application\nStartupNotify=false\nStartupWMClass=Code\nCategories=TextEditor;Development;IDE;\nMimeType=text/plain;inode/directory;application/x-code-workspace;\nActions=new-empty-window;\nKeywords=vscode;\n[Desktop Action new-empty-window]\nName=New Empty Window\nExec=/usr/share/code/code --disable-dev-shm-usage --new-window %F\nIcon=vscode"\
    > /usr/share/applications/code.desktop

# Download and install PyCharm
RUN wget "https://download.jetbrains.com/python/pycharm-community-2023.2.1.tar.gz" \
    -O /opt/pycharm-latest.tar.gz \
 && tar xzf /opt/pycharm-latest.tar.gz -C /opt/ \
 && rm /opt/pycharm-latest.tar.gz \
 && touch /usr/share/applications/pycharm.desktop \
 && echo -e "[Desktop Entry]\nVersion = 2023.2.1\nType = Application\nTerminal = false\nName = PyCharm\nExec = /opt/pycharm-community-2023.2.1/bin/pycharm.sh\nIcon = /opt/pycharm-community-2023.2.1/bin/pycharm.png\nCategories = TextEditor;Development;IDE;" > /usr/share/applications/pycharm.desktop \
 && chmod +x /usr/share/applications/pycharm.desktop

USER ${NB_USER}
WORKDIR /home/${NB_USER}

# Install Jupyter Desktop
RUN pip install jupyter-remote-desktop-proxy
