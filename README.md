# Threat Instrumentation And Machine Automation Tool

## Table of contents

1. Document information   
1.1 Version   
1.2 Contributors   
1.3 References
[2. Purpose and scope](https://github.com/abemelvin/tiamat#2-purpose-and-scope)   
2.1 Justification   
2.2 Deliverables   
2.3 Exclusions   
2.4 Assumptions   
3. Stakeholders   
3.1 Researchers   
3.2 Maintainers   
3.3 Developers
4. Project   
4.1 Problem description   
4.2 Solution overview   
4.3 Functional requirements   
4.4 Quality attributes   
4.5 Constraints   
4.6 Mock network   
4.7 Instrumentation and data   
4.8 Dependencies
5. Key views   

---

## 2 Purpose and scope

---

### 2.1 Justification

---

### 2.2 Deliverables

* Mock network
* Range infrastructure
* Scenario injects
* Architecture documentation
* Researcher instructions
* Maintainer instructions

---

### 2.3 Exclusions

---

### 2.4 Assumptions

---

## 3 Stakeholders

---

### 3.1 Researcher

---

### 3.2 Maintainer

---

### 3.3 Developer

---

## 4 Project

---

### 4.1 Problem description

---

### 4.2 Solution overview

---

### 4.3 Functional requirements

---

### 4.4 Quality attributes

#### Modifiability

* **Source:** Researcher
* **Stimulus:** Deploy additional hosts to the mock network
* **Environment:** Pre-deployment or experiment run-time
* **Artifact:** Infrastructure configuration files
* **Response:** Deployed infrastructure continues uninterrupted, and newly
defined hosts are deployed in real time
* **Response measure:** Less than 30 minutes needed for each new host to
deploy, no downtime experienced for infrastructure already deployed beforehand

#### Portability

* **Source:** Researcher
* **Stimulus:** Transfer system from one machine to another
* **Environment:** Pre-deployment
* **Artifact:** System repository
* **Response:** System configurations are preserved, and system continues to
operate normally without needed to install excessive dependencies
* **Response measure:** Less than 30 minutes needd to transfer the system
between machines and be reader for deployment

---

### 4.5 Constraints

#### Business

* System will only utilize open-source or free software without licensing
restrictions
* Team is limited to a $150 USD budget for development and testing on AWS
public cloud infrastructure

#### Technical

* System is limited to virtualization under a local hypervisor as the only
means of deploying the mock network
* Deploying on public cloud infrastructure presents risks in terms of both
security and legality
* Hardware resources are not available to avoid virtualization

---

### 4.6 Mock network

#### Intranet

1. Web server

* Hosts a web application through which the contractor notionally files work 
orders. The web application requires the user to log in with a username and 
password, and connects to a database service. The database service is running
locally with system privileges and is vulnerable to an injection attack.

2. Authentication server

* Runs a lightweight directory access protocol (LDAP) service that
authenticates users and groups on the network. The LDAP service also
provides a central point for configuring user and group privileges.

3. Payment server

* Runs a database service locally that notionally stores redacted transaction
information from purchases made at retail locations. A script generates
messages with unredacted transaction information that are sent to the database.
Under normal operating conditions, the database receives the message and only
stores a redacted record of the transaction. When successfully exploited, the
database stores unredacted transaction records that include sensitive
payment information.

#### Extranet

1. Gateway

* Receives all IP packets entering or leaving the intranet. Applies a
pre-configured routing table to all received IPpackets to determine which host
to deliver to. IPv4 forwarding is enabled.

2. Firewall

* Receives all IP packets entering or leaving the intranet. Applies a
stateless pre-configured firewall ruleset to all IP packets to provide
basic intranet network isolation.

3. Intrusion detection/prevention system

* Sniffs and captures all IP packets entering or leaving the intranet.
Forwards packet captures to the centralized logging stack for post-processing
by the researcher while also providing real time alerts for any malicious
activity detected.

#### Internet

1. Contractor

* Runs a mail transfer agent (MTA) locally that is able to send and receive
mail from the notional black hat.

2. Black hat

* Provides the researcher a manual injection point.

3. File transfer server

* Runs a local file transfer protocol (FTP) service that the black hat is
able to utilize as a repository for exfiltrating sensitve data from the
intranet payment server.

---

### 4.7 Instrumentation and data

#### Centralized Logging

* SQL logs
* System logs
* Packet captures

#### Active Monitoring

---

### 4.8 Dependencies

---

## 5 Key views