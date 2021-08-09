# C3T

Created: January 13, 2021 10:43 AM
WTAMU, oTree, Python: Python, WTAMU, Work

- Meetings are every Wednesday at 7pm

## TODO:

- [ ]  Ask Babb about email settings, to get running locally. Pending this for New user validation as well as User - Lost Credentials. C3T-20 & C3T-21 respectively.
    - asked about this, we have SMTP settings; I need access to this, should be getting credentials?
- [ ]  Disposition & Knowledge Element lookups, tie into wizard? Basic feature is there already, might need some tweaking to get it to not redirect to another page.
- [x]  Create additional models - Is there anything else that needs to be created? or are we leaving this open until we decide we don't need anymore?
    - Nothing more to create.
- [ ]  What flow are we looking for on approving CCS classifications? I'd assume it'd be up to an admin to approve tags on an Knowledge Element.
    - [ ]  Do we want to restrict display of non-approved tags when viewing Knowledge Elements?

Bug when I tried to edit a Knowledge Element from the search? 

wizard is now priority 

### Wizard Notes:

~~Still need logic to save the newly created competency;~~ 

~~How to tie a disposition into this? The only way, in terms of the model, is through Disposition Applied, which has extra fields. Should I just adjust the form to be Disposition Applied rather than a Disposition?~~ 

For Knowledge Elements...we will probably want the option to add a new KE when creating the competency

Need to tie in search feature WITHOUT leaving that page... Migrate to table list? Could just have an inline filter? 

Hierarchy of ccs tags similar to the ACM site list. Might need a custom model to manage tags this way. In addition to this, Babb wants the tags to be viewable and organized similar to how they appear on the ACM Site.