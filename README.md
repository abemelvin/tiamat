# Threat Instrumentation And Machine Automation Tool

## Table of contents

1. [Installation](https://github.com/abemelvin/tiamat#1-installation-)   
2. [Getting started](https://github.com/abemelvin/tiamat#2-getting-started-)
3. [Building machine images](https://github.com/abemelvin/tiamat#3-building-machine-images-)      
4. [Deploying the testbed](https://github.com/abemelvin/tiamat#4-deploying-the-testbed-)   
5. [Provisioning the testbed](https://github.com/abemelvin/tiamat#5-provisioning-the-testbed-)   
6. [Destroying the testbed](https://github.com/abemelvin/tiamat#6-destroying-the-testbed-)   
7. [Data collection and analysis](https://github.com/abemelvin/tiamat#7-data-collection-and-analysis-)   
8. [Running the examplar attack scenario](https://github.com/abemelvin/tiamat#8-running-the-examplar-attack-scenario-) 
9. [System Infrastructure](https://github.com/abemelvin/tiamat#9-system-infrastructure-)

---

## 1. Installation [↑](https://github.com/abemelvin/tiamat)

Tiamat does not require compilation which makes installation extremely simple. Just clone the Tiamat repository to your local machine by running `git clone https://github.com/abemelvin/tiamat.git` in your shell.

## 2. Getting started [↑](https://github.com/abemelvin/tiamat)

To start using Tiamat, execute the `tiamat.py` script located in the `tiamat/` directory by running `python tiamat.py`.

Tiamat utilizes Terraform (https://www.terraform.io) to instantiate the infrastructure needed to host your testbed. Terraform accesses various AWS APIs which require you to have a validated AWS account and to also specify your AWS access keys in your environment. Tiamat will check that your environment is correctly configured before allowing you to proceed to deployment. 

Tiamat will also check that your PATH variable contains valid executables of Terraform and Packer (for image building),  and will assist you in downloading them if they are not found. 

## 3. Building machine images [↑](https://github.com/abemelvin/tiamat)

To build machine images before deployment, use the `build` command in the Tiamat shell. All machine images will be provisioned by the Ansible provisioning scripts. 

## 4. Deploying the testbed [↑](https://github.com/abemelvin/tiamat)

Tiamat maintains a list of servers that are currently flagged to be deployed.
You can view this list by running `show deployment list` in the Tiamat shell:

~~~
(Tiamat) show deployment list
- elk
- contractor
- blackhat
- mail
- ftp
~~~

To view a list of all the servers that you can add to the deployment list,
run `show available` in the Tiamat shell:

~~~
(Tiamat) show available
- blackhat
- contractor
- elk
- ftp
- mail
- payments
- wazuh
- web
~~~

To add servers to the deployment list, run `add server [name]` in the
Tiamat shell, replacing `[name]` with the specific server identifier:

~~~
(Tiamat) add server payments
~~~

To remove servers from the deployment list, run `remove server [name]` in the
Tiamat shell, replacing `[name]` with the specific server identifer:

~~~
(Tiamat) remove server payments
~~~

Once you are satisfied with your server list, you can proceed with deployment
by running `deploy` in the Tiamat shell:

~~~
(Tiamat) deploy
~~~

After initiating deployment, Tiamat will first check your deployment
template for errors. If an error is detected, this may indicate that the
`tiamat/configuration.tf` file is damaged. If you are confident
that this is not the case, you can proceed with deployment by following
the prompts.

Once deployment is complete, you will be presented with the public IP addresses
of your servers. If you wish to SSH directly into your servers or to access
a web service running on your servers, you will need this information:

~~~
Outputs:

ansible ip = 54.242.186.67
payments ip = 34.207.64.90
~~~

At anytime, you can run `show active servers`  to view the the list of currently deployed servers and their public IP addresses:

```
(Tiamat) show active servers
- ansible: 54.242.186.67
- payments: 34.207.64.90
```

The global states including deployment status, active server list and their public IP addresses are saved in JSON format in global_state.json under the Tiamat directory. Please keep this file uncorrupted. In case of  unexpected errors regarding the global states, you may need to delete global_state.json manually.

## 5. Provisioning the testbed (Optional) [↑](https://github.com/abemelvin/tiamat)

(In step 3 "Building machine images", all servers have been provisioned during image building, so it's not necessay to provision again here. However, if you are going to modify the configuration or provision some new scripts, you may follow this instruction to provision a specific server.)

Once deployment is complete, you will need to provision the instantiated servers with the appropriate software packages. Automated provisioning scripts are provided for each available server, which can be executed using Ansible. To connect to Ansible, run `ansible` in the Tiamat shell:

~~~
(Tiamat) ansible
~~~

Once you have a secure shell to Ansible, you can execute the provisioning scripts that correspond to the servers you deployed. For example, if you only chose to deploy the payments server, you would provision that server like so:

~~~
ubuntu@ip-10-0-0-10:~$ ansible-playbook install/payment_server.yml
~~~

Once you have provisioned the testbed, you can interact with the environment as you see fit.

## 6. Destroying the testbed [↑](https://github.com/abemelvin/tiamat)

Since your testbed is deployed on AWS, you will be charged based on the volume and length of your usage. Therefore, it is key to destroy the testbed once you are done with your experiments. To do this, run `destroy`:

~~~
(Tiamat) destroy
~~~

Terraform will confirm your intent to destroy one final time before the process is initiated. Try not to interrupt the destruction process once it has started, as it could prevent Terraform from halting gracefully and damage your state file in the process.

## 7. Data collection and analysis [↑](https://github.com/abemelvin/tiamat)

Tiamat utilizes the Elastic Stack (Elasticsearch, Logstash, Kibana) to perform log data integration, search, and visualization. It also incorporates Wazuh, a host-based intrusion detection system built on Elastic Stack to perform log analysis, integrity checking, rootkit detection, time-based alerting, and active response.

When provisioning the system, you can paste the public IP address of elk/wazuh into a web browser to open the Kibana/Wazuh dashboard. The `elk` command also does the same work.

To download the log files from ELK server to local folder, type in the following command:

```
(Tiamat) save logs
```

To download the .pcap file from each server, type in the following command:

```
(Tiamat) save pcaps
```

![Data-collection](https://github.com/abemelvin/tiamat/blob/master/doc/img/Data%20Collection.png?raw=true)

## 8. Running the examplar attack scenario [↑](https://github.com/abemelvin/tiamat)

In this section, we run through an examplar attack scenario provided by Tiamat to demonstrate

the use of the testbed. The system-under-test (SUT) consists of the following host machines:

```
(Tiamat) show deployment list
- contractor
- blackhat
- mail
- web
- payments
- sales
- ftp
- elk
- wazuh
```

The attack pipeline is as follows:

![Scenario](https://github.com/abemelvin/tiamat/blob/master/doc/img/Scenario.png?raw=true)



After deployment, we connect to Ansible and first execute the phishing playbook:

```
ubuntu@ip-10-0-0-10:~$ ansible-playbook inject/phishing.yml
```

Then we execute the password cracking playbook:

```
ubuntu@ip-10-0-0-10:~$ ansible-playbook inject/cracking.yml
```

![Shell-injection](https://github.com/abemelvin/tiamat/blob/master/doc/img/Phishing%20and%20Shell%20injection.png?raw=true)

What takes place next is the injection of malicious POS firmware:

```
ubuntu@ip-10-0-0-10:~$ ansible-playbook inject/firmware.yml
```

Finally, we let blackhat exfiltrate the unredacted transaction logs to the FTP server:

```
ubuntu@ip-10-0-0-10:~$ ansible-playbook inject/transactions.yml
```

![Data-Exfiltration](https://github.com/abemelvin/tiamat/blob/master/doc/img/Transaction%20Data%20Exfiltration.png?raw=true)

## 9. System Infrastructure [↑](https://github.com/abemelvin/tiamat)

Here is the general picture of the system infrastructure. It may help you understand how TIAMAT works.

![Infrastructure](https://github.com/abemelvin/tiamat/blob/master/doc/img/Infrastructure.png?raw=true)



