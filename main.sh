#!/bin/bash

install_python() {
    echo "Installing Python 3.11.0..."
    wget https://www.python.org/ftp/python/3.11.0/Python-3.11.0.tgz
    tar -xzf Python-3.11.0.tgz
    cd Python-3.11.0 || exit
    ./configure --prefix=$HOME/python3.11
    make
    make install
    $HOME/python3.11/bin/python3.11 -m venv ~/venv/python3.11_env
    source ~/venv/python3.11_env/bin/activate
    echo "Python version:"
    python --version
    cd ..
}

install_conda() {
    echo "Installing Conda..."
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3
    source $HOME/miniconda3/bin/activate
    conda init
    echo "Conda installation complete."
}

install_neofetch() {
    echo "Installing Neofetch..."
    git clone https://github.com/dylanaraps/neofetch.git
    cd neofetch || exit
    make install PREFIX=$HOME/.local
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
    echo "Neofetch installation complete."
    cd ..
}

install_openjdk() {
    echo "Installing OpenJDK 22..."
    wget https://download.java.net/java/GA/jdk22.0.1/c7ec1332f7bb44aeba2eb341ae18aca4/8/GPL/openjdk-22.0.1_linux-x64_bin.tar.gz
    tar -xzvf openjdk-22.0.1_linux-x64_bin.tar.gz
    echo "Setting environment variables for OpenJDK 22..."
    echo "export JAVA_HOME=$(pwd)/jdk-22.0.1" >> ~/.bashrc
    echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
    echo "OpenJDK 22 installation complete."
    
    read -p "Do you want to install Minecraft server.jar? (yes/no): " install_minecraft
    if [ "$install_minecraft" == "yes" ]; then
        read -p "Enter the link to the server.jar (type 'none' or leave blank for default 1.20.2): " server_jar_link
        if [ -z "$server_jar_link" ] || [ "$server_jar_link" == "none" ]; then
            server_jar_link="https://piston-data.mojang.com/v1/objects/5b868151bd02b41319f54c8d4061b8cae84e665c/server.jar"
        fi
        wget "$server_jar_link" -O server.jar
        read -p "Do you accept the Minecraft EULA? (type 'yes' to accept): " accept_eula
        if [ "$accept_eula" != "yes" ]; then
            echo "You must accept the EULA to run the Minecraft server. Exiting."
            exit 1
        fi
        echo "eula=true" > eula.txt
        echo "online-mode=false" >> server.properties
        echo "Launching server..."
        java -jar server.jar
    fi
}

install_vim() {
    echo "Installing Vim..."
    sudo apt-get update
    sudo apt-get install -y vim
    echo "Vim installation complete."
}

install_git() {
    echo "Installing Git..."
    sudo apt-get update
    sudo apt-get install -y git
    echo "Git installation complete."
}

install_cmake() {
    echo "Installing CMake..."
    sudo apt-get update
    sudo apt-get install -y cmake
    echo "CMake installation complete."
}

install_docker() {
    echo "Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "Docker installation complete."
}

install_ollama() {
    echo "Installing Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
    echo "Ollama installation complete."
}

echo "Select the package to install:"
echo "1) Python"
echo "2) Conda"
echo "3) Neofetch"
echo "4) OpenJDK 22"
echo "5) Vim"
echo "6) Git"
echo "7) CMake"
echo "8) Docker"
echo "9) Ollama"

read -rp "Enter your choice [1-9]: " choice

case $choice in
    1)
        install_python
        ;;
    2)
        install_conda
        ;;
    3)
        install_neofetch
        ;;
    4)
        install_openjdk
        ;;
    5)
        install_vim
        ;;
    6)
        install_git
        ;;
    7)
        install_cmake
        ;;
    8)
        install_docker
        ;;
    9)
        install_ollama
        ;;
    *)
        echo "Invalid choice!"
        ;;
esac

source ~/.bashrc
echo "Restarting console: source ~/.bashrc"
