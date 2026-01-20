<sub>[back](../README.md)</sub>

# Security

Specifically, Cybersecurity. 

See: [OWASP testing framework](https://github.com/OWASP/wstg/tree/f33d49364c72f4e5ad082cca0eea1de64ffe1ceb/document)  
[Mitre ATT&CK](https://attack.mitre.org/resources/)  
[CentralOps.net](https://centralops.net/co/)  
[Malware Archaeology - Cheat Sheets](https://www.malwarearchaeology.com/cheat-sheets/)  

## Links

Links to other security related notes: 

- [DMZ](./DMZ.md)
- [Linux Forensics Cheatsheet](./Linux_Forensics_CheatSheet.md)
- [Risk](./Risk.md)
- [SSL Certificates](./SSL_Certs.md)
- [SSL Certificate Creation](./SSL_Cert_Creation.md)
- [Standard Levels](./Standard_levels.md)
- [ThreatLocker](./Threatlocker.md)
- [Phishing](./Phishing.md)

## Threat Modeling

Threat modeling has become a popular technique to help system designers think about the security threats that their systems and applications might face. Therefore, threat modeling can be seen as risk assessment for applications. It enables the designer to develop mitigation strategies for potential vulnerabilities and helps them focus their inevitably limited resources and attention on the parts of the system that most require it. It is recommended that all applications have a threat model developed and documented. Threat models should be created as early as possible in the SDLC, and should be revisited as the application evolves and development progresses.

To develop a threat model, we recommend taking a simple approach that follows the [NIST 800-30](https://csrc.nist.gov/publications/detail/sp/800-30/rev-1/final) standard for risk assessment. This approach involves:

- Decomposing the application – use a process of manual inspection to understand how the application works, its assets, functionality, and connectivity.
- Defining and classifying the assets – classify the assets into tangible and intangible assets and rank them according to business importance.
- Exploring potential vulnerabilities - whether technical, operational, or managerial.
- Exploring potential threats – develop a realistic view of potential attack vectors from an attacker’s perspective by using threat scenarios or attack trees.
- Creating mitigation strategies – develop mitigating controls for each of the threats deemed to be realistic.

The output from a threat model itself can vary but is typically a collection of lists and diagrams. Various Open Source projects and commercial products support application threat modeling methodologies that can be used as a reference for testing applications for potential security flaws in the design of the application. It may be worth considering using one of the OWASP threat modeling tool projects, Pythonic Threat Modeling (pytm) and Threat Dragon, which provide differing but equally valid ways of creating threat models.

**There is no right or wrong way to develop threat models** and perform information risk assessments on applications; be flexible and select the tools and processes that will fit with how a particular organization or development team works.