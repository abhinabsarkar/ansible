# Plugin concepts

Ansible supports a feature called callback plugins that can perform custom actions in response to Ansible events such as a play starting or a task completing on a host

For it to see in action on windows, set the environment variable for the ansible.cfg in the local folder to take effect.
**This is required only when working on windows wsl. In linux it takes the precedence of local folder by default**
```bash
export ANSIBLE_CONFIG=/mnt/c/Ansible/src/sample/ansible.cfg
```

Ansible supports following kinds of callback plugins:
* Stdout -  plugins affect the output displayed to the terminal. 
* Other plugins - for notification asnd aggregation

## Callback plugins 
* Stdout - Only a single stdout plugin can be active at a time. To see it in action, update ansible.cfg & the output will be in json format
```ini
[defaults]
stdout_callback = json
```
Enable the other plugins you want in ansible.cfg by setting callback_whitelist to a comma-separated list;
```ini
[defaults]
callback_whitelist = mail, timer
```
**log-plays** - logs the results to log files in /var/log/ansible/hosts, one log file per host. The path is not configurable.
    > Instead of using the log_plays plugin, you can set the log_path configuration option in ansible.cfg. This approach generates a single logfile for all hosts, whereas the plugin generates a separate logfile for each host. For example:
```ini
[defaults]
log_path = /home/ansible/src/sample/ansible-ab.log
```

**Mail** - Sends failure events via email
It requires whitelisting in configuration (ansible.cfg).
> Email notification fails in windows 10 wsl
```ini
[defaults]
callback_whitelist = mail
SMTPHOST = smtp.domain.com
[callback_mail]
smtpport = 25
to = abhinab@email.com
```

## Custom Callback Plugin

To invoke your own custom callback plugin, set the ansible.cfg file in your local directory.
```ini
# comma separate callback plugins to whitelist:
callback_whitelist = ab_callback
``` 

The plugin is nothing but a python class which is placed inside **callback_plugins** folder. The python class will have the following structure.
```py
from ansible.plugins.callback import CallbackBase

class CallbackModule(CallbackBase):
  CALLBACK_VERSION = 2.0
  CALLBACK_TYPE = 'aggregate'
  CALLBACK_NAME = 'ab_callback'
``` 
> Note the CALLBACK_TYPE. It can be either of aggregate or notification.

This class in itself is not doing anything. You can wire it with any callback method and write your own python code to achieve any functionality. Let's say for example, we want to capture unreachable hosts, see the below code

```py
from ansible.plugins.callback import CallbackBase

class CallbackModule(CallbackBase):
  CALLBACK_VERSION = 2.0
  CALLBACK_TYPE = 'aggregate'
  CALLBACK_NAME = 'ab_callback'

def print_host(self, result, ab_msg):
    print(ab_msg)
    print('host name: ' + result._host.get_name())
    print('Error Message: ' + result._result.get('msg'))

def v2_runner_on_unreachable(self, result): 
    self.print_host(result, 'Unreachable host')
``` 

