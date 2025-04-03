[back](../README.md)  
# Datto EDR & AV

Antivirus and Entity Detection and Response suite provided by Datto (Kasaya).

## Links

- [Rules - Writing detection and response actions](./Rules.md)

## Notes

### Automated "Responses" 

In a round about way, I've found out how to run extensions with Datto EDR. Essentially define you're LUA script, add it to Datto EDR under Username -> Admin -> Extensions -> Create New Extension. 

The most important factor for EDR extensions is that the Extension be defined as a `collection` and not a `response`. Super intuitive! 

Name and describe the script according to it's functions. Save it when completed; then navigate to Policies -> Select your active EDR policy for any given organization and Edit it; At the bottom of the EDR policy page there is a section for Extension Options, select your recently created Extension from Available Extensions on the left and add it to Selected Extensions with the blue Add button.  

#### Default Response Policy

Not 100% sure how this one works yet, but should be similar to the above section about my backwards way of an automated response. 

For this, first enable the `Default Response Policy` and (optionally) assign it to an organization. To get custom response actions, it's easiest to take an existing `Detection` policy and copy it into a new one, modifying the script to your needs. 

These `Detection` policies are defined in `yaml`, and only do detection. The automated responses here are quite limited, to 3 options or any combo of the 3: `Isolate Host`, `Kill Process`, `Quarantine File`. 

Viewing and copying existing `Detection` policies used to be easier, when Datto had a `Copy` button on the policy page...now the only way I've been able to view the rule is to find an alert that tripped the rule and expanding it's `Rule Body` field, which contains the full `Detection` script. 