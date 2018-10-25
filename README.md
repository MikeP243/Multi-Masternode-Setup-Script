---------
Masternode Scripts
---------

DingoDollars - version 0.1

---------
DingoDollars Masternode Setup
---------
Controller-Cold-Setup
This is the best method to setup your Masternodes. The wallet containing the coins does not have to be exposed and can run on your local computer. It does not have to run all the time.

---------
Desktop Wallet Setup
---------
In the first steps the desktop wallet will be setup. This is the wallet you can run on your local PC. When the masternodes are connected this wallet can be closed and the PC does not have to run in order for the masternodes to generate rewards.

We will create an address, private key and transaction for each masternode (MN in the following) and show the necessary steps for configuration.

1.	Open Console: Tools - Debug Console

2.	Type “getaccountaddress MN1” and press Enter. Repeat for MN2, MN3, etc

3.	Send exactly 2500 coins to each MN address

4.	Setup MNs in config:  Tools - Open Masternode.conf

Now add a Line for each MN with the following Format:
> [Alias] [VPS IP]:[Port] [Genkey] [Txhash] [Outputindex]

a.	Begin by entering and alias IP:port

	i.	[Alias] the name of the MN receiving address (we named them MN1, MN2, …)

	ii.	[IP] The static IP of your server

	iii.	[port] A port the MN will connect to. The port is not fixed and multiple nodes can run on one server but need different ports.

b.	Next we get the “masternodeprivkey “

	i.	[Genkey] Open debug console again, type “masternode genkey” and press enter

	ii.	Repeat the line for each MN you want to setup

	iii.	Copy the output keys to the config

c.	Next we will add txhash  and outputindex

	i.	[Txhash] Go to the debug console again, type “masternode outputs” and press enter

	ii.	[outputindex] If you send the coins in one transaction the “txhash” will be the same. If you add a masternode later, another tuple will be added. So every masternode has a unique pair of txhash and outputindex

	iii.	Copy the information to the config file (Make sure you don’t forget the index!)

5.	Save the file and restart the wallet.



---------
Getting a VPS
---------
For the cold wallets you first need a linux VPS. You can get very cheap ones for 5$ here: https://www.vultr.com/. These can run a few DINGO  masternode instances though it might be a good idea to split your MNs across some different Servers.  The more isolation you have the less likely you are hit big by a server outage?.

After registration you get to the Dashboard. You have to do the first payment with something else then Bitcoin. After the first payment you can pay the servers in BTC.


6.	Deploy the server: Hit the plus top right to add new instances

7.	Choose a region near you. It does not really matter.

	a.	As “Server Type” choose Ubuntu and click 14.04

	b.	As Server Size choose the 5$ instance with 1GB Ram. If available you can choose the 2.50$ one if you only want to run one or two nodes on it.

	c.	Scroll down and give the node a name.

	d.	After that click “Deploy now” in the overview you should see this:

8.	Connect to the Server.

9.	Download and execute script on VPS: (each MN must have unique ports)

		wget https://raw.githubusercontent.com/MikeP243/Multi-Masternode-Setup-Script/master/DINGO-setup.sh

		chmod 755 DINGO-setup.sh

		./DINGO-setup.sh

If you make an error when typing the interactive stuff: ctrl+c and restart the script

10.	Controlling the masternode

a.	The script from the last step already started all wallets on VPS

b.	Type the following into the VPS.

		source .bashrc

c.	Each MN has now its own control script under ~/bin (named with alias you typed before)

d.	To see if the blocks are syncing “watch DingoDollarsd_mn1.sh getinfo”

e.	If sync is finished go to your desktop wallet and start MNs in the masternode tab (unlock wallet before).

f.	You can close your Desktop wallet after a while.


---------
Adding more nodes to existing VPS
---------

To add more DINGO MNs to a existing server setup with the setup.sh script before just restart the script and type “n” when asked if you want to install the dependencies at the beginning. After that just follow the steps from before in the interactive script.
