# Threat Instrumentation And Machine Automation Tool

## Table of contents

1. [Document information](https://github.com/abemelvin/tiamat#1-document-information-)   
1.1 [Version](https://github.com/abemelvin/tiamat#11-version-)   
1.2 [Contributors](https://github.com/abemelvin/tiamat#12-contributors-)   
1.3 [References](https://github.com/abemelvin/tiamat#13-references-)
2. [Purpose and scope](https://github.com/abemelvin/tiamat#2-purpose-and-scope-)   
2.1 [Justification](https://github.com/abemelvin/tiamat#21-justification-)   
2.2 [Deliverables](https://github.com/abemelvin/tiamat#22-deliverables-)   
2.3 [Exclusions](https://github.com/abemelvin/tiamat#23-exclusions-)   
2.4 [Assumptions](https://github.com/abemelvin/tiamat#24-assumptions-)   
3. [Stakeholders](https://github.com/abemelvin/tiamat#3-stakeholders-)   
3.1 [Researchers](https://github.com/abemelvin/tiamat#31-researchers-)   
3.2 [Maintainers](https://github.com/abemelvin/tiamat#32-maintainers-)   
3.3 [Developers](https://github.com/abemelvin/tiamat#33-developers-)
4. [Project](https://github.com/abemelvin/tiamat#4-project-)   
4.1 [Problem description](https://github.com/abemelvin/tiamat#41-problem-description-)   
4.2 [Solution overview](https://github.com/abemelvin/tiamat#42-solution-overview-)   
4.3 [Functional requirements](https://github.com/abemelvin/tiamat#43-functional-requirements-)   
4.4 [Quality attributes](https://github.com/abemelvin/tiamat#44-quality-attributes-)   
4.5 [Constraints](https://github.com/abemelvin/tiamat#45-constraints-)   
4.6 [Mock network](https://github.com/abemelvin/tiamat#46-mock-network-)   
4.7 [Instrumentation and data](https://github.com/abemelvin/tiamat#47-instrumentation-and-data-)   
4.8 [Dependencies](https://github.com/abemelvin/tiamat#48-dependencies-)
5. [Key views](https://github.com/abemelvin/tiamat#5-key-views-)   

---

## 1 Document information [↑](https://github.com/abemelvin/tiamat)

---

### 1.1 Version [↑](https://github.com/abemelvin/tiamat)

---

### 1.2 Contributors [↑](https://github.com/abemelvin/tiamat)

---

### 1.3 References [↑](https://github.com/abemelvin/tiamat)

---

## 2 Purpose and scope [↑](https://github.com/abemelvin/tiamat)

---

### 2.1 Justification [↑](https://github.com/abemelvin/tiamat)

---

### 2.2 Deliverables [↑](https://github.com/abemelvin/tiamat)

* Mock network
* Range infrastructure
* Scenario injects
* Architecture documentation
* Researcher instructions
* Maintainer instructions

---

### 2.3 Exclusions [↑](https://github.com/abemelvin/tiamat)

---

### 2.4 Assumptions [↑](https://github.com/abemelvin/tiamat)

---

## 3 Stakeholders [↑](https://github.com/abemelvin/tiamat)

---

### 3.1 Researcher [↑](https://github.com/abemelvin/tiamat)

---

### 3.2 Maintainer [↑](https://github.com/abemelvin/tiamat)

---

### 3.3 Developer [↑](https://github.com/abemelvin/tiamat)

---

## 4 Project [↑](https://github.com/abemelvin/tiamat)

---

### 4.1 Problem description [↑](https://github.com/abemelvin/tiamat)

---

### 4.2 Solution overview [↑](https://github.com/abemelvin/tiamat)

---

### 4.3 Functional requirements [↑](https://github.com/abemelvin/tiamat)

---

### 4.4 Quality attributes [↑](https://github.com/abemelvin/tiamat)

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

### 4.5 Constraints [↑](https://github.com/abemelvin/tiamat)

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

### 4.6 Mock network [↑](https://github.com/abemelvin/tiamat)

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

### 4.7 Instrumentation and data [↑](https://github.com/abemelvin/tiamat)

#### Centralized Logging

* SQL logs
* System logs
* Packet captures

#### Active Monitoring

---

### 4.8 Dependencies [↑](https://github.com/abemelvin/tiamat)

---

## 5 Key views [↑](https://github.com/abemelvin/tiamat)

### 5.1 Mock network diagram

![mock network](https://github.com/abemelvin/tiamat/blob/master/mock_network.png "mock network")