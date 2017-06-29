# Threat Instrumentation And Machine Automation Tool

## Table of contents

1. [Installation](https://github.com/abemelvin/tiamat#1-installation-)   
2. [Getting started](https://github.com/abemelvin/tiamat#2-getting-started-)   
3. [Deploying the testbed](https://github.com/abemelvin/tiamat#3-deploying-the-
testbed-)   
4. [Provisioning the testbed](https://github.com/abemelvin/tiamat#4-
provisioning-the-testbed-)   
5. [Destroying the testbed](https://github.com/abemelvin/tiamat#5-destroying-
the-testbed-)   

---

## 1. Installation [↑](https://github.com/abemelvin/tiamat)

Tiamat does not require compilation which makes installation extremely simple.
Just clone the Tiamat repository to your local machine by running
`git clone https://github.com/abemelvin/tiamat.git` in your shell.

## 2. Getting started [↑](https://github.com/abemelvin/tiamat)

To start using Tiamat, execute the `tiamat.py` script located in the
`tiamat/` directory by running `python tiamat.py`.

Tiamat utilizes Terraform (https://www.terraform.io) to instantiate the
infrastructure needed to host your testbed. Terraform accesses various
AWS APIs which require you to have a validated AWS account and to also
specify your AWS access keys in your environment. Tiamat will check that
your environment is correctly configured before allowing you to proceed
to deployment. Tiamat will also check that your PATH variable contains a 
valid Terraform executable, and will assist you in downloading an
executable if one is not found.

## 3. Deploying the testbed [↑](https://github.com/abemelvin/tiamat)

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
`tiamat/terraform/configuration.tf` file is damaged. If you are confident
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

## 4. Provisioning the testbed [↑](https://github.com/abemelvin/tiamat)

Once deployment is complete, you will need to provision the instantiated
servers with the appropriate software packages. Automated provisioning
scripts are provided for each available server, which can be executed using
Ansible. To connect to Ansible, run `ansible` in the Tiamat shell:

~~~
(Tiamat) ansible
~~~

Once you have a secure shell to Ansible, you can execute the provisioning
scripts that correspond to the servers you deployed. For example, if you
only chose to deploy the payments server, you would provision that server
like so:

~~~
ubuntu@ip-10-0-0-10:~$ ansible-playbook install/payment_server.yml
~~~

Once you have provisioned the testbed, you can interact with the environment
as you see fit.

## 5. Destroying the testbed [↑](https://github.com/abemelvin/tiamat)

Since your testbed is deployed on AWS, you will be charged based on the
volume and length of your usage. Therefore, it is key to destroy the testbed
once you are done with your experiments. To do this, run `destroy`:

~~~
(Tiamat) destroy
~~~

Terraform will confirm your intent to destroy one final time before the process
is initiated. Try not to interrupt the destruction process once it has started,
as it could prevent Terraform from halting gracefully and damage your state
file in the process.