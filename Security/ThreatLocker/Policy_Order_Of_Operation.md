[back](./README.md)

# Policy Hierarchy

## Overview

This article covers the order of policies as they apply to your computers. The first policy that a file matches is the one that is processed, and no further policies will be applied to that file.  


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