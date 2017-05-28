# Threat Instrumentation And Machine Automation Tool

## Table of contents

1. Document information   
1.1 Version   
1.2 Contributors   
1.3 References
2. Purpose and scope   
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
* **Response:** Deployed infrastructure continues uninterrupted, and newly defined hosts are deployed in real time
* **Response measure:** Less than 30 minutes needed for each new host to deploy, no downtime experienced for infrastructure already deployed beforehand

#### Portability

* **Source:** Researcher
* **Stimulus:** Transfer system from one machine to another
* **Environment:** Pre-deployment
* **Artifact:** System repository
* **Response:** System configurations are preserved, and system continues to operate normally without needed to install excessive dependencies
* **Response measure:** Less than 30 minutes needd to transfer the system between machines and be reader for deployment

---

### 4.5 Constraints

#### Business

* System will only utilize open-source or free software without licensing restrictions
* Team is limited to a $150 USD budget for development and testing on AWS public cloud infrastructure

#### Technical

* System is limited to virtualization under a local hypervisor as the only means of deploying the mock network
* Deploying on public cloud infrastructure presents risks in terms of both security and legality
* Hardware resources are not available to avoid virtualization

---

### 4.6 Mock network

---

### 4.7 Instrumentation and data

---

### 4.8 Dependencies

---

## 5 Key views