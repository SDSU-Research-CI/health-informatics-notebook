FROM gitlab-registry.nrp-nautilus.io/prp/jupyter-stack/scipy:v1.3

# Install packages via conda
RUN conda install -y -c conda-forge -n base biopython pytest 

USER root

# Install desktop OS dependencies
RUN apt-get -y update \ 
 && apt-get -y install \
    icedtea-netx \
    net-tools \
    dbus-x11 \
    firefox \
    xfce4 \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xorg \
    xubuntu-icon-theme \
 && apt-get remove -y -q light-locker

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

USER $NB_USER

# Install Jupyter Desktop
RUN /opt/conda/bin/conda install -c manics websockify
RUN pip install jupyter-remote-desktop-proxy
