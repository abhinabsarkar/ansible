# Ansible Architecture

The Ansible automation engine is agentless. Other automation engines like Chef or Puppet install an agent on the hosts they manage, that pull changes from the master host. Ansible works by pushing changes through SSH WinRM to the managed nodes. The only thing you need on your machine in order to run Ansible is python installed ( > 2.4). 

![Alt text](/images/ansible-architecture.jpg)

# Ansible Concepts

Ansible connects to the managed nodes using SSH protocol in Linux & WinRM in Windows. These servers are defined in the **Inventory** file, which is an INI file that puts all of the machines to be managed in groups of your own choosing. It can also fetch inventory from other sources like EC2, OpenStack, etc.

```ini
#Sample inventory file
---
[webservers]
www1.example.com
www2.example.com

[dbservers]
db0.example.com
db1.example.com
```

The automation jobs on Ansible are created using YAML, called as **Playbooks**. Once connected to the nodes, it executes built-in programs called **Modules**, to configure & manage servers. To invoke a module, it has to be enclosed in a **Task**. The modules defined in a task are run sequentially.

```yaml
#Sample Task calling 2 Modules in a Playbook
---
tasks:
- name: Create directory structure      #Name of the task
  win_file:                             #Module - Creates, removes files or directories. 
    path: C:\Temp\folder\subfolder      #Path to the file being managed
    state: directory                    #All immediate subdirectories will be created if they do not exist
- name: Install IIS (Web-Server only)   #Name of the task
  win_feature:                          #Module - Installs and uninstalls Windows Features on Windows Server
    name: Web-Server                    #Names of roles or features to install
    state: present                      #State of the features or roles on the system     
```

**Play** is a collection of task(s) which you can execute on one or more target nodes. Each Playbook contains one or more **Plays**.

```yaml
#Sample Playbook having 1 Play
- hosts: webservers                     #Target nodes to run the task
  tasks:
      - name: Touch a file              #Task to create a file if not present. Update modified date if present
        win_file:
            path: C:\Temp\foo.conf
            state: touch
```

Below visual shows the relation between the various concepts discussed above.

![Alt text](/images/playbook-concepts.jpg)