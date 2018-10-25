#/bin/bash

cd ~
echo "****************************************************************************"
echo "* Ubuntu 14.04 is the recommended opearting system for this install.       *"
echo "*                                                                          *"
echo "* This script will install and configure your DingoDollars masternodes.  *"
echo "****************************************************************************"
echo && echo && echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!                                                 !"
echo "! Make sure you double check before hitting enter !"
echo "!                                                 !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo && echo && echo

echo "Do you want to install all needed dependencies (no if you did it before)? [y/n]"
read DOSETUP

if [[ $DOSETUP =~ "y" ]] ; then
  sudo apt-get update

  sudo apt-get upgrade

  sudo apt-get install automake libdb++-dev build-essential libtool autotools-dev autoconf pkg-config libssl-dev libboost-all-dev libminiupnpc-dev git software-properties-common python-software-properties g++ bsdmainutils libevent-dev -y

  sudo add-apt-repository -y ppa:bitcoin/bitcoin

  sudo apt-get update

  sudo apt-get install libdb4.8-dev libdb4.8++-dev -y

  sudo apt-get install libgmp3-dev -y


  git clone https://github.com/MikeP243/DingoDollars

cd DingoDollars/

sudo dd if=/dev/zero of=/swapfile bs=1M count=2000
sudo mkswap /swapfile
sudo chown root:root /swapfile
sudo chmod 0600 /swapfile
sudo swapon /swapfile

#make swap permanent
sudo echo "/swapfile none swap sw 0 0" >> /etc/fstab

cd src

make -f makefile.unix

mv DingoDollarsd /usr/local/bin/

cd


  # dd if=/dev/zero of=/var/swap.img bs=1024k count=1000
  # mkswap /var/swap.img
  # swapon /var/swap.img

  # sudo mv  DingoDollars/bin/* /usr/bitcoin

  cd

  sudo apt-get install -y ufw
  sudo ufw allow ssh/tcp
  sudo ufw limit ssh/tcp
  sudo ufw logging on
  echo "y" | sudo ufw enable
  sudo ufw status

  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc
fi

## Setup conf
mkdir -p ~/bin
echo ""
echo "Configure your masternodes now!"
echo "Type the IP of this server, followed by [ENTER]:"
read IP

MNCOUNT=""
re='^[0-9]+$'
while ! [[ $MNCOUNT =~ $re ]] ; do
   echo ""
   echo "How many nodes do you want to create on this server?, followed by [ENTER]:"
   read MNCOUNT
done

for i in `seq 1 1 $MNCOUNT`; do
  echo ""
  echo "Enter alias for new node"
  read ALIAS

  echo ""
  echo "Enter port for node $ALIAS(i.E. 7748)"
  read PORT

  echo ""
  echo "Enter masternode private key for node $ALIAS"
  read PRIVKEY

  echo ""
  echo "Enter RPC Port (Any valid free port: i.E. 27261)"
  read RPCPORT

  ALIAS=${ALIAS,,}
  CONF_DIR=~/.DingoDollars_$ALIAS

  # Create scripts
  echo '#!/bin/bash' > ~/bin/DingoDollarsd_$ALIAS.sh
  echo "DingoDollarsd -daemon -conf=$CONF_DIR/DingoDollars.conf -datadir=$CONF_DIR "'$*' >> ~/bin/DingoDollarsd_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/DingoDollars-cli_$ALIAS.sh
  echo "DingoDollars-cli -conf=$CONF_DIR/DingoDollars.conf -datadir=$CONF_DIR "'$*' >> ~/bin/DingoDollars-cli_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/DingoDollars-tx_$ALIAS.sh
  echo "DingoDollars-tx -conf=$CONF_DIR/DingoDollars.conf -datadir=$CONF_DIR "'$*' >> ~/bin/DingoDollars-tx_$ALIAS.sh
  chmod 755 ~/bin/DingoDollars*.sh

  mkdir -p $CONF_DIR
  echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> DingoDollars.conf_TEMP
  echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> DingoDollars.conf_TEMP
  echo "rpcallowip=127.0.0.1" >> DingoDollars.conf_TEMP
  echo "rpcport=$RPCPORT" >> DingoDollars.conf_TEMP
  echo "listen=1" >> DingoDollars.conf_TEMP
  echo "server=1" >> DingoDollars.conf_TEMP
  echo "daemon=1" >> DingoDollars.conf_TEMP
  echo "logtimestamps=1" >> DingoDollars.conf_TEMP
  echo "maxconnections=256" >> DingoDollars.conf_TEMP
  echo "masternode=1" >> DingoDollars.conf_TEMP
  echo "" >> DingoDollars.conf_TEMP

  #echo "addnode=addnode=54.37.16.231" >> DingoDollars.conf_TEMP
  #echo "addnode=addnode=173.249.44.68" >> DingoDollars.conf_TEMP
  #echo "addnode=addnode=173.212.217.165" >> DingoDollars.conf_TEMP
  #echo "addnode=addnode=95.31.104.209" >> DingoDollars.conf_TEMP
  #echo "addnode=addnode=150.129.80.244" >> DingoDollars.conf_TEMP
  #echo "addnode=addnode=193.37.152.36" >> DingoDollars.conf_TEMP
  #echo "addnode=addnode=80.211.142.222" >> DingoDollars.conf_TEMP

  echo "" >> DingoDollars.conf_TEMP
  echo "port=$PORT" >> DingoDollars.conf_TEMP
  echo "masternodeaddress=$IP:$PORT" >> DingoDollars.conf_TEMP
  echo "masternodeprivkey=$PRIVKEY" >> DingoDollars.conf_TEMP
  sudo ufw allow $PORT/tcp

  mv DingoDollars.conf_TEMP $CONF_DIR/DingoDollars.conf

  sh ~/bin/DingoDollarsd_$ALIAS.sh
done
