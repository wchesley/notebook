# PCI - Payment Card Industry Data Security Standard (PCI-DSS)

The Payment Card Industry Data Security Standards (PCI DSS) applies to any company storing processing, or transmitting credit card data. It facilitates the comprehensive adoption of consistent data security measures. Web companies must follow the requirements of the PCI DSS, including a variety of measures, such as hosting the data with a PCI-compliant host. PCI DSS is an organization formed by the major credit card companies, such as Visa, Mastercard, Discover, and American Express.

The main goal of PCI compliance is to reduce the opportunities for attack. This involves using a secure Card Data Environment (CDE), and this applies regardless of whether you use your in-house environment or a third-party secure payment option. This is especially important for e-commerce sites, which rely exclusively on the transfer of payment card data through the internet.

## Requirements

The PCI DSS outlines 12 key requirements for businesses to be compliant. These are divided into six different categories, each focusing on a specific aspect of information security. Let’s break them down:

### 1. Use and Maintain Firewalls

Firewalls are a crucial line of defense in securing your network. They monitor and control incoming and outgoing network traffic based on security rules and establish a barrier between your secure internal network and potentially insecure external networks. Therefore, it’s essential to use and maintain firewalls properly to prevent unauthorized access to your network and protect cardholder data.

### 2. Proper Password Protections

Passwords are often the first line of defense when it comes to protecting sensitive information. Therefore, it’s important to implement strong password policies. This includes using complex passwords, regularly changing passwords, and not using vendor-supplied defaults for system passwords and other security parameters.

### 3. Protect Cardholder Data

Protecting cardholder data is at the heart of PCI compliance. This includes keeping stored cardholder data to a minimum, disposing of it securely when it’s no longer needed, and implementing robust access control measures to prevent unauthorized access.

### 4. Encryption of Transmitted Cardholder Data

Whenever cardholder data is transmitted over open networks, it becomes vulnerable to interception. Therefore, it’s important to use strong encryption methods to protect sensitive information during transmission. This ensures that even if the data is intercepted, it cannot be read without the correct decryption key.

### 5. Utilize Antivirus and Anti-malware Software

Antivirus and anti-malware software are essential tools for detecting and removing malicious software. They help protect your systems from threats that can compromise cardholder data and disrupt your operations. It’s important to keep these tools updated to ensure they can effectively combat the latest threats.

### 6. Properly Updated Software

Keeping your software updated is crucial for maintaining a secure environment. Software updates often include patches for security vulnerabilities, so outdated software can leave your systems vulnerable to attacks. Regularly updating your software helps protect against these threats and maintain the integrity of cardholder data.

### 7. Restrict Data Access

Access to cardholder data should be restricted on a need-to-know basis. This means that only individuals who need access to the data to perform their job should have it. Implementing strict access control measures can significantly reduce the risk of unauthorized access to sensitive information.

### 8. Unique IDs Assigned to Those with Access to Data

Each person who has access to cardholder data should be assigned a unique ID. This allows you to track and monitor individual access to data and helps in identifying any unauthorized access or suspicious activity.

### 9. Restrict Physical Access

Physical security is just as important as digital security when it comes to protecting cardholder data. Physical access to data and systems should be restricted and monitored to prevent unauthorized access and manipulation.

### 10. Create and Monitor Access Logs

Logging and monitoring access to network resources and cardholder data allows you to identify and respond to security incidents promptly. Regularly reviewing access logs can help you spot suspicious activity and prevent potential data breaches.

### 11. Test Security Systems on a Regular Basis

Regular testing of security systems and processes is essential to ensure they are working as intended and to identify any potential vulnerabilities. This includes testing firewalls, intrusion detection systems, and other key security measures.

### 12. Document Policies

Documenting your security policies and procedures is a crucial part of PCI compliance. This provides a clear framework for your team to follow and ensures that everyone understands their responsibilities when it comes to maintaining a secure environment.

## Defining Account Data, Cardholder Data, and Sensitive Authentication Data

Cardholder data includes: 

- Primary Account Number (PAN)
- Cardholder Name
- Expiration Date
- Service Code 

Sensitive Authentication Data Includes: 

- Full track data (magnetic-strip data or equivalent on a chip)
- Card verification code
- PINs/PIN blocks

### Storage Requirements

When storing Cardholder data, keep storage to a minimum for all cardholder data. For Sensitive Authentication Data, it cannot be stored after authorization, but must be stored until authorization is complete and must be protected with strong cryptography. This boils down to, if you don't need it, don't store it. You're just incurring extra risk if you're storing this data without a justified need. 