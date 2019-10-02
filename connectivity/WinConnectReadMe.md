# Connecting to a Windows Host
Ansible connects to Windows machines and runs PowerShell scripts by using Windows Remote Management (WinRM) (as an alternative to SSH for Linux/Unix machines). WinRM is a management protocol used by Windows to remotely communicate with another server. It is a SOAP-based protocol that communicates over HTTP/HTTPS, and is included in all recent Windows operating systems.

## Pre-Requisites
1. [Target host requirements](https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html#host-requirements)
2. WinRM listener should be created and activated on the target host

## Authentication modes
When connecting to a Windows host, Kerberos is the recommended authentication option to use when running in a domain environment. Kerberos supports features like credential delegation and message encryption over HTTP and is one of the more secure options that is available through WinRM.

*The other modes for Active Directory are **NTLM** & **CredSSP** (Credential Security Support Provider). NTLM is obsolete and isn't recommended. CredSSP authentication is a newer authentication but it passes the user's full credentials to the server without any constraint. This mechanism increases the security risk of the remote operation. If the remote computer is compromised, the credentials that are passed to it can be used to control the network session.*

## Install pywinrm with kerberos authentication on Ubuntu
pywinrm is Python client for the Windows Remote Management (WinRM) service. It allows you to invoke commands on target Windows machines from any machine that can run Python.

```bash
#for Debian/Ubuntu/etc:
sudo -E apt-get install python-dev libkrb5-dev krb5-user
sudo -E pip install pywinrm[kerberos]

#If the Ansible node doesn't have certificate installed, add to trusted source  
sudo -E pip install --trusted-host pypi.python.org --trusted-host pypi.org --trusted-host files.pythonhosted.org pywinrm[kerberos]
```

## Install pywinrm with kerberos authentication on RHEL
```bash
#install pip
sudo -E yum install python-pip
#install pywinrm with kerberos authentication
sudo -E yum install gcc python-devel krb5-devel krb5-workstation python-devel
sudo -E pip install pywinrm[kerberos]

#If the above command gives error, [SSL: CERTIFICATE_VERIFY_FAILED] then run
sudo -E pip install --trusted-host pypi.python.org --trusted-host pypi.org --trusted-host files.pythonhosted.org pywinrm[kerberos]
```

## Configure Host Kerberos
Once the dependencies have been installed, Kerberos needs to be configured so that it can communicate with a domain. This configuration is done by modifying the file **/etc/krb5.conf**

The following sections need to be configured

**[realms]** - Add the full domain name and the fully qualified domain names of the primary and secondary Active Directory domain controllers. It should look something like this:
```ini
# MY.DOMAIN.COM has to be in CAPS as it is case sensitive
[realms]
    MY.DOMAIN.COM = {
        kdc = domain-controller1.my.domain.com
        kdc = domain-controller2.my.domain.com
    }
```

* If you don't have name of the Domain Controller, you can find them by running these commands - Click Start, and then click Run. In the Open box, type cmd. Type nslookup, and then press ENTER. Type set type=all, and then press ENTER. Type _ldap._tcp.dc._msdcs.Domain_Name, where Domain_Name is the name of your domain, and then press ENTER.

**[domain_realm]** - Add a line like the following for each domain that Ansible needs access for:
```ini
# Everything is case sensitive
[domain_realm]
    .my.domain.com = MY.DOMAIN.COM
```

## Verify Kerberos authentication
Run the below commands to verify the configuration. 
```bash
# login
$ kinit <userid>@MYDOMAIN.COM
# Enter Password for <userid>@MYDOMAIN.COM:

# list credentials
$ klist

# destroy credentials
$ kdestroy
```
If it is giving the error *“kinit: Cannot contact any KDC for realm while getting initial credentials”* means that you are not resolving the name. There is probably one of two problems: 
1. The configuration in /etc/krb5.conf is not correct 
2. The Ansible host is not resolving the domain controller.

## WinRM Encryption
Using WinRM with TLS is the recommended option as it works with all authentication options, but requires a certificate to be created and used on the WinRM listener. The **ConfigureRemotingForAnsible.ps1** creates a self-signed certificate and creates the listener with that certificate. If in a domain environment, ADCS can also create a certificate for the host that is issued by the domain itself.

If using HTTPS is not an option, then HTTP can be used when the authentication option is **NTLM, Kerberos or CredSSP**. These protocols will encrypt the WinRM payload with their own encryption method before sending it to the server. The message-level encryption is not used when running over HTTPS because the encryption uses the more secure TLS protocol instead. If both transport and message encryption is required, set **ansible_winrm_message_encryption=always** in the host vars.