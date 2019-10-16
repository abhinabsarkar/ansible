# Ansible automation for Windows

## Overview
Ansible is an open-source product that automates provisioning (virtual machines, containers, and network and complete cloud infrastructures), configuration management, and application deployments. In addition, Ansible allows you to automate the deployment and configuration of resources in your environment. It acts like an orchestrator/maestro - one server to manage others and unify different configurations and processes.
[Link to Ansible documentation](https://docs.ansible.com/ansible/latest/index.html)

## Architecture, Definitions & Concepts

* [Ansible Architecture](https://github.com/abhinabsarkar/ansible/blob/master/architecture/ArchitectureReadme.md)

## Ansible Installation

* [Install Ansible on RHEL, Ubuntu & Windows (Dev only)](/installation/InstallationReadMe.md)

## Ansible Configuration - Connecting to a target host

* [Connecting to a Windows host](/connectivity/WinConnectReadMe.md)

## Ansible Automation - How to run your first playbook?

* [Run playbook from Visual Studio Code](/playbook/PlaybookReadMe.md)

## Ansible Plugins
* [Plugin](/plugin/PluginReadMe.md)

## AWX
AWX provides a web-based user interface, REST API, and task engine built on top of Ansible. It is an open source community project that enables users to better control their Ansible project use in IT environments. AWX is the upstream project from which the [Red Hat Ansible Tower](https://www.ansible.com/products/tower) offering is ultimately derived.

Fun with AWX API
* [Download logs for all the failed jobs for a given job template id](/src/DownloadAWXLogs.ps1)
