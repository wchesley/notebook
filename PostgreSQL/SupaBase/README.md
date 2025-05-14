[back](../README.md)

FOSS Firebase alternative backed by PostgreSQL.  
Supabase is built on top of Postgres, providing you with the flexibility to use it as a simple table store or leverage its full capabilities. The platform encourages you to focus on designing a scalable database system, offering the tools to make Postgres easy to use for both beginners and veterans.

# Docs: 
[Supabase Database Encryption](https://www.restack.io/docs/supabase-knowledge-supabase-database-encryption)

## Shared Security Responsibility Model

The Shared Security Responsibility Model delineates the roles and 
responsibilities of both Supabase and its users in maintaining a secure 
database environment. Supabase aims to minimize the burden of 
infrastructure management and Postgres internals, but users retain 
certain responsibilities to ensure security and efficiency.

### User Responsibilities

- **Access Management**: Users must manage who has access to their database, particularly in production environments.
Inexperienced team members should have restricted access to prevent
dangerous operations.
- **Data Protection**: Sensitive data tables should have
appropriate access levels. Users are also responsible for the secure
storage of database secrets and API keys.
- **Workflow and Best Practices**: Users decide their
workflow using tools like the Supabase Dashboard, client libraries, and
migration tools. Adhering to best practices for database optimization
and management is crucial.
- **Compute Provisioning**: Users must provision
sufficient compute resources for their application's workload, utilizing Supabase's observability tooling for assistance.

### Supabase Responsibilities

- **Infrastructure**: Supabase manages the underlying infrastructure, providing tools to make Postgres as easy to use as possible.
- **Security Features**: Supabase offers features like Row Level Security (RLS), SSL enforcement, and network restrictions to enhance security.
- **Documentation and Support**: Official documentation and support are provided to help users understand and implement security measures effectively.

Incorporating features like supabase database encryption and 
following the guidelines from the official documentation will help 
maintain a secure and efficient database system.

## Enabling pgsodium Extension in Supabase

To enhance database security with encryption in Supabase, enabling the `pgsodium`
 extension is a crucial step. This extension integrates libsodium's 
cryptographic capabilities into PostgreSQL, offering a range of 
functionalities from key management to advanced encryption methods.

### Enabling pgsodium via Dashboard

1. Navigate to the **Database** section in your Supabase Dashboard.
2. Select **Extensions** from the sidebar.
3. Locate `pgsodium` in the list and click to enable it.

### Enabling pgsodium via SQL

Execute the following SQL command to enable `pgsodium`:

```psql
CREATE EXTENSION pgsodium;
```

To disable it, use:

```psql
DROP EXTENSION IF EXISTS pgsodium;
```

### Considerations for Using pgsodium

- Use encryption for highly sensitive data only, as it impacts performance.
- Avoid indexing encrypted columns to maintain data security.
- Be mindful of the additional time required for encrypting and decrypting data.

By following these guidelines, you can leverage `pgsodium` for effective database encryption in Supabase, ensuring your sensitive data is well-protected.

## Best Practices for Security in Supabase

Security
 is a critical aspect of any application, and when using Supabase, there
 are several best practices you should follow to ensure your data 
remains safe. Here are some key measures to implement:

### Row Level Security (RLS)

- Always enable RLS on your tables to prevent unauthorized access. Use the Supabase Dashboard to set up RLS policies effectively.
- For tables with sensitive data, consider replication and set up appropriate row security policies.

### SSL and Network Restrictions

- Enforce SSL connections to your database to ensure data is encrypted in transit.
- Apply network restrictions to limit which IP addresses can connect to your database.

### Authentication and Authorization

- Protect your GitHub account with strong passwords and two-factor
authentication (2FA) as it provides administrative rights to your
Supabase project.
- Enable email confirmations for new users and use a custom SMTP server to send authentication emails from a trusted domain.

### Security Mindset

- Regularly think from an attacker's perspective and identify potential vulnerabilities in your service.
- Familiarize yourself with common cybersecurity threats and how to prevent them.

### Code and API Security

- Use robust JWT libraries for secure token parsing and verification.
- Check the `aal` claim in JWTs to enforce multi-factor authentication (MFA) policies.

### Database Management

- Never use service keys on the client side; they should be reserved for administrative tasks.
- Create policies that define granular access control to your data, leveraging PostgreSQL's powerful RLS feature.

By following these practices and regularly reviewing the official 
Supabase documentation, you can maintain a high level of security for 
your application.

## Implementing Transparent Column Encryption

Transparent
 Column Encryption (TCE) in Supabase is a feature that allows you to 
encrypt data at the column level within your database. It's particularly
 useful for protecting highly sensitive information such as API keys, 
payment details, and personal identification data. Here's a detailed 
guide on implementing TCE in your Supabase project.

### Understanding the Performance Impact

- **Encryption Overhead**: Both encryption and decryption operations consume additional time, which means that working with
encrypted data is slower compared to plain text.
- **Non-indexable**: Encrypted columns cannot be indexed. Indexing would store encrypted values, rendering the index ineffective.
- **Query Limitations**: While you can use encrypted columns in `WHERE` clauses, it can lead to performance degradation due to the decryption process required for each query.
- **Multiple Encryptions**: Encrypting multiple columns
in the same table increases the encryption time linearly, as each column encryption is a separate process.

### Key Management

Supabase manages the root keys for encryption, keeping them secure 
and separate from your data. You can access these keys via a dedicated 
API endpoint if you need to decrypt data outside of Supabase.

### Enabling TCE

To enable TCE, you need to activate the `pgsodium` 
extension in your Supabase project. This can be done through the 
Supabase Dashboard or by executing SQL commands to create the extension.

### Security Measures

- Ensure that Row Level Security (RLS) is enabled for tables containing sensitive data.
- Avoid using service keys on the client side, as they can bypass RLS.
- Always enable RLS on public tables to maintain data security.

### Best Practices

- Use TCE only for data that requires high levels of protection.
- Regularly review your database and application security to prevent potential abuse.
- Consider the overall architecture of your application to ensure scalability and performance.

By following these guidelines and utilizing the official 
documentation, you can effectively implement TCE in your Supabase 
project, enhancing the security of sensitive data.

## Best Practices for Using Column Encryption

When
 dealing with highly sensitive data in a Supabase database, column 
encryption can be a vital security measure. However, it's important to 
use this feature judiciously due to its impact on performance and 
flexibility. Here are some best practices:

- **Understand the Performance Impact**: Encryption and
decryption operations consume additional time. Be prepared for slower
INSERT and SELECT operations on encrypted columns.
- **Avoid Indexing Encrypted Columns**: Indexes on encrypted columns store encrypted values, rendering them ineffective for search operations.
- **Careful with Queries**: Using encrypted columns in `WHERE` clauses can degrade performance, as decryption is required for each comparison.
- **Limit Encrypted Columns**: Encrypt only the necessary columns. Each encrypted column adds to the encryption overhead.
- **Use for Sensitive Data Only**: Reserve column encryption for data that would cause significant harm if exposed, such as API keys or personal information.
- **Leverage Supabase Features**: Utilize server key
management and transparent column encryption as outlined in the official documentation. Supabase projects are encrypted at rest by default,
adding another layer of security.
- **Consider Supabase Vault**: For managing secrets
outside of the database, Supabase Vault provides a secure solution,
ensuring that encryption keys are not stored alongside the data they
protect.
- **Regularly Review Security Measures**: Stay updated with the latest security practices and ensure that your implementation aligns with them.

By following these guidelines and leveraging Supabase's security 
features, you can effectively secure sensitive data while maintaining a 
performant application.
