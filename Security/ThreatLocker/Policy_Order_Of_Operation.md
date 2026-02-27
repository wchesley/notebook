[back](./README.md)

# Policy Hierarchy

## Overview

This article covers the order of policies as they apply to your computers. The first policy that a file matches is the one that is processed, and no further policies will be applied to that file.  

## Policy Order Changes 10/16/2025

> [!CAUTION]> Important Note: Policy order changes cannot be rolled back once they are implemented.

Beginning in ThreatLocker Portal Version `3.3.1`, and Windows Agent `10.5.3`,  ThreatLocker offers the opportunity to move from a hierarchical structure of policy ordering to a flat processing structure. This change is optional; however, it is needed to accommodate future changes, including the ability to view all policies for each module, and the ability to not prioritize built-in applications over custom applications.

By reordering policies, you can choose to manage a lower number of policies by creating entire organization or global policies, and setting exceptions to those catch-all policies at a lower order by number.

Once an organization meets the criteria of having all their Windows groups set to `10.5.3` or above, a new button will be available in the Application Control > Policies hamburger menu titled `Upgrade to Flat Policy Structure`.

> [!NOTE] Please note: Parent organizations must upgrade before the option will be presented to child organizations. This is a per organization setting, so every organization will have the ability to choose to upgrade.

You will be presented with a confirmation dialog that outlines the benefits of upgrading to a flat policy structure.

Select the checkbox at the bottom to acknowledge that you understand the policy order could be impacted.

Next, select the 'Save' button.

The reordering process should not interfere with the existing order of an Organization's policies. Instead, it will assign order numbers as follows:

- Built-in applications - Start at 101
- Custom apps - Start at +100,001 
- Default policy - Will be 1,000,000

Policies will be processed from the lowest number to the highest number, regardless of their Applies To level.

> [!NOTE] Please Note: Some discrepencies could occur for policies that have the same order by number assigned,

Once the order numbers have been changed, policies at any level can be renumbered to any number to provide granular control over the policy processing order. This includes the ability to set a group or single computer policy to process before a global policy.

> [!NOTE] Please Note: Policies cannot be reordered to a negative number

It is important to note that by default, the Windows Agent automatically prioritizes built-in applications over custom applications. This means that a policy for a custom application for Office will always be processed after a policy for the built-in Office application, regardless of hierarchy or policy order number. The reorder will reflect the processing order as built-in applications will be given a lower order by number.

To allow the agent to stop prioritizing built-in applications, the Agent Setting "Prioritize Built-In Applications" will need to be set with the checkbox unchecked.

## Application Control

1. **Global** - (Designed for customers with multiple sub organizations) policies under the Global computer group will apply first to the parent organizations and all child organizations. Policies placed at this level will apply FIRST.
2. **Global Group {GroupName}** - (Designed for customers with multiple sub organizations) policies under these groups will apply to any computers for the parent and child organizations that are part of a computer group that matches the name after the "-" (e.g., policies under Global-Workstations will apply to all parent and child organizations in the Workstations groups). Policies placed at this level will apply SECOND.
3. **Entire Organization** - policies at this level will apply to all computers within the single organization being managed. Policies placed at this level will apply THIRD.
4. **Computers {Hostname}** - Located under the Computers section in the "Applies to" dropdown list under the Policies page, policies located here will apply to the single computer selected. Computer-level policies will apply FOURTH.
5. **Computer Group {GroupName}** - Located under the Groups section in the "Applies to" dropdown list under the Policies page, policies located here will apply to any computers under the selected group (e.g., policies under Workstations will apply to all computers in this organization installed under the Workstations group). Computer Group level policies will apply LAST.

 

> Note: Built-In applications will always take precedence over custom applications.
> For example: A group policy for the "Command Prompt (Built-In)" application will be matched before a Global policy for a Command Prompt custom application.

 

At the bottom of each group (excluding Global and Template groups) is the "Default - {GroupName}" policy; this is the catchall policy responsible for denying unknown applications. The default policy is set to Request by default.
Elevation Control

Beginning in ThreatLocker Windows Agent 9.7 and Mac Agent 3.1, Elevation will be processed outside of the policy hierarchy, negating the need to place Elevation policies above permit policies.  When an Elevate action type is seen, the ThreatLocker Service will check for an Elevation policy first. As long as an Elevation policy for that application exists for the endpoint attempting the Elevation, Elevation will be permitted.

> Please Note: Windows Agent versions before 9.7, and Mac Agent versions before 3.1 will require that Elevation policies be placed higher in the hierarchy than a permit policy for the same application in order for the Elevation to be permitted.

> Note: Built-In applications will always take precedence over custom applications.

## Storage Control

The order is similar to Application Control; however, Storage Control does not support Global policies.

## Network Control

The order is similar to Application Control; however, Network Control does not support Global policies.

## Configuration Manager

Configuration manager policies follow a top-down hierarchy, regardless of where they are applied. This is useful for creating exceptions to Configuration Manager policies.

## ThreatLocker Detect

ThreatLocker Detect does not follow any specific policy hierarchy. If the condition(s) for the Detect policy is/are matched, then the actions specified in the Detect policy will be performed.