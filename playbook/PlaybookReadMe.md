# Playbook

A playbook requires a **hosts** field which refers to the target hosts where the playbook will run. These target hosts are defined in the **inventory** file. The **vars** field contains the varibles required to connect to the target host. The **tasks** contains the modules which will run on the target host. Below is the sample playbook & invemtory file.

```yaml
---
# Sample Playbook 
 - name: first playbook 
   hosts: win                                #Host variable containing the list of target host servers
   vars:
    #may also be passed on the command-line via --user
    ansible_user: <AD_ID>@domain.com         #Domain user with kerberos authentication
    #supplied at runtime with --ask-pass
    #ansible_password:                       #Domain password
    ansible_port: 5986                       #WinRM port for https, for http it is 5985
    ansible_connection: winrm                #Protocol used. If not mentioned, SSH protocol is used
    # The following is necessary for Python 2.7.9+ when using default WinRM self-signed certificates:
    ansible_winrm_server_cert_validation: ignore
    ansible_winrm_transport: kerberos        #Authentication protocol
   tasks: 
     - name: Ping windows server             #Task1 - pings windows target host server
       win_ping:                             #Module - pining windows server
```

```ini
---
# put target servers here
[win]
<hostname>
```

To run this playbook from visual studio code, create a folder say 'demo' and place these two files in it. Install the Ansible extension from visual studio code. Select the playbook in the explorer tab in visual studio code, right click on Run Ansible Playbook Remotely via ssh. In the top bar Visual Studio Code will now ask you for the Host Name of your Ansible Control node, Username and Password. After that Visual Studio Code will ask if we want to copy our Workspace to the Ansible control node, which we always want to do, so select Always. Now it will try to run the playbook on the Ansible control node through Visual Studio Code but it will error out. 

To run the playbook, check if the present working directory is 'demo' or not. If not, switch to the demo directory. Run the following command from visual studio code terminal & it now you should be able to execute the playbook.

```bash
ansible-playbook -i inventory.ini firstplaybook.yml --ask-pass
```
In the above command it is important to undertand that the Ansible works against multiple systems in your infrastructure at the same time. It does this by selecting portions of systems listed in Ansible’s inventory, which defaults to being saved in the location /etc/ansible/hosts. We are specifying a different inventory file using the -i <path> option on the command line.
