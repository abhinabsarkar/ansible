# Ansible installation on a RHEL machine
```bash
#install ansible
sudo -E yum install ansible

#Verify installation
ansible --version
```

# Ansible installation for Windows (Only for Development)

Windows Subsystem for Linux, basically installs an Ubuntu LTS release inside of Windows 10. This allows to use Ansible on a Windows workstation.

## Pre-requisites 
Windows 10 version 16215 or later along with 64 bit architecture.

## Install steps
1.	**Install the Windows Subsystem for Linux** - Open PowerShell as Administrator and run. Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux. Restart when prompted.

* This can also be done by going to Control Panel --> Programs --> Turn Windows features on or off --> Check “Windows Subsystem for Linux” --> Ok. Restart the computer.

2.	**Install Linux Distribution** - Download the application distribution file for Ubuntu https://aka.ms/wsl-ubuntu-1604. Unzip the file. Make sure the target directory is on the system drive. Eg: C:\Ubuntu. Open command prompt in administrator mode, set the C:\Ubuntu as the directory and run the command Ubuntu.exe.

3.	**Add a UNIX user** - The first time you install the Windows Subsystem for Linux, you will be prompted to create a UNIX username and password. This UNIX username and password can be different from, and has no relationship to, your Windows username and password.

4.	**Install Ansible** - Once Windows Subsystem for Linux (WSL) is installed, you can open the Bash terminal by typing bash and install Ansible. First set up the proxy.

## Add proxy (If you are running on-premise)

```bash
#set
export http_proxy=http://<AD_ID>:<Password>@<proxy-address:port>/
export https_proxy=http://<AD_ID>:<Password>@<proxy-address:port>/
#view
echo $http_proxy
#remove
unset http_proxy
unset https_proxy
```

## Update the Ubuntu distribution and install Ansible
```bash
# sudo -E is required for using the proxy information for sudo user
sudo -E apt-get update
sudo -E apt-get install python-pip git libffi-dev libssl-dev -y
sudo -E apt-get install ansible

#To uninstall the latest version & install a specific version
sudo apt-get remove --purge ansible  
```

## Verify installation
```bash
ansible --version
```