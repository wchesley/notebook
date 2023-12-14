# Common Criteria 2.1 (SOSO Principle 13)

The TSC common criteria (CC2.1) relate to using relevant information and communication within an organization. It states, "The organization obtains or generates and uses relevant, quality information to support the functioning of internal control”.

This principle emphasizes the importance of accurate and prompt information to manage risks and achieve organizational objectives effectively. It also highlights the need for an efficient communication channel so that information can be conveyed and utilized by the appropriate individuals and departments within the organization. There are four objectives needed to meet this requirement:

- Identify information requirements: A process is in place to identify the information required and expected to support the functioning of the other components of internal control and the achievement of the entity’s objectives.

- Capture internal and external sources of data: Information systems capture internal and external sources of data.

- Process relevant data into information: Information systems process and transform relevant data into information.

- Maintain quality throughout processing: Information systems produce information that is timely, current, accurate, complete, accessible, protected, verifiable, and retained. Information is reviewed to assess its relevance in supporting the internal control components.

To comply with Principle 13, an entity should have processes in place to identify and gather relevant information, assess the quality of that information, and use it to support proper decision-making, such as internal control activities. It should also establish a functional communication channel to ensure timely information distribution to the appropriate individuals and departments.

## Use case: Collecting and analyzing logs across multiple endpoints

Wazuh helps meet the COSO Principle 13 (CC2.1) requirement by providing capabilities that generate quality information for the proper functioning of internal control measures. An example is log data analysis. The Wazuh logcollector module retrieves and centralizes log data from different sources, such as operating systems, applications, network devices, and security appliances. Once the log data is collected, Wazuh applies various analysis techniques to extract valuable insights and detect potential security issues. This is done by matching the received data with the Wazuh out of the box decoders and rules.