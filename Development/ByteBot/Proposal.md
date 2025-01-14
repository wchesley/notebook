[back](./README.md)

# Proposal

Created: April 7, 2021 9:32 AM
Created By: Walker Chesley
Last Edited By: Walker Chesley
Last Edited Time: April 7, 2021 10:05 AM
Status: Proposed
Type: Product Spec

Create a new page and select `Product Spec` ****from the list of template options to automatically generate the format below.

# Overview

## Problem Statement

A brief description of the problem we're trying to solve. Why is this valuable to work on? 

Bytebot has outgrown nodejs, node doesn't handle async/await very well ergo I'm migrating to a platform with more support for it, python.  

## Proposed Work

A high-level overview of what we're building and why it will solve the problem.

Rewrite application to in python rather than nodejs. Barebones code is in place thanks to AlexFlipnote ([https://github.com/AlexFlipnote/discord_bot.py](https://github.com/AlexFlipnote/discord_bot.py))  

# Success Criteria

What criteria must be met in order to consider this project a success?

- Users will be able to manage the valheim server via ByteBot
- Management of discord server via ByteBot

# User Stories

How should the product behave from a user's perspective?

## Android and iOS users

- On new user signup: user will go through a new four-step onboarding flow.

# Scope

## Requirements

What requirements should this project fulfill? 

- control over valheim server process (start/stop/restart)
- Relay server statistical information through discord

## Future Work

List requirements that we know we want to do, but will do later.

- Steam integration
- Announce Player deaths in valheim
- CI/CD

## Non-Requirements

Include anything related to this project that is out of scope. 

- Updates to templates we initialize on new workspace creation.

# Designs

Include designs as necessary. These can also be included in the user stories or requirements sections.

[]()

# Privacy Review

Include any relevant data privacy documentation or note why none is required. 

No privacy review is necessary — we're not asking for any user data nor will Bytebot store any personal information.

# Alternatives Considered

List any alternatives you considered to this solution and why you recommend this solution over the others.

- Node JS Child process
    - Cannot seem to get it to return proper results

# Related Documents

Include any links to relevant external documents.

- Discord_py readthedocs: [https://discordpy.readthedocs.io/en/latest/index.html](https://discordpy.readthedocs.io/en/latest/index.html)

# Follow Up Tasks

What needs to be done next for this proposal? 

- [x]  Fork and build discord_bot.py
- [x]  Connect Python bot to discord server
- [x]  Git repo setup
- [ ]  Kanban board