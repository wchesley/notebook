---
title: How to Destroy Data
author: Walker Chesley
colorlinks: true
geometry: "left=3cm,right=3cm,top=2cm,bottom=2cm"
output: pdf_document
---

## Overview

This guide explains how to properly wipe a data drive.

## Before you start

Before you begin data destruction, ensure:

- You have a spare machine with the drive to be wiped plugged into it
- ShredOS live USB plugged into the machine. [Download here](https://github.com/PartialVolume/shredos.x86_64/releases/tag/v2021.08.2_23_x86-64_0.34)
- A vast amount of time (varies depending on size of drive)

## Data Destruction Run-Guide

When old data comes into Westgate's possession and is destined for the recycle pile, we are required to wipe the data before allowing it to go out of the store. This guide covers how to wipe the data using ShredOS, a light weight linux distro that only deletes data. 

1. Boot your machine into ShredOS live USB. There is no option to install ShredOS. 
   1.1. When booted, you should be looking at a blue screen with a list of detected hard drives.

   1.2 At the bottom of this screen is a list of commands we can use in ShredOS

2. Press the `m` key on the keyboard to bring up the available wiping methods

    2.1. Select `DoD 5220.22-m` for the wiping method and use ESC to get back to main menu

3. Press `space` to select the hard drives you want to wipe. 

    3.1 Use caution when selecting drives to wipe. It is possible for the live USB to show up in this list. There is no going back once the disk is wiped. 

4. Press `Shift` + `S` to start the wipe. Process will take a long time, and the time varries based on size and speed of drive being wiped. 

5. Once drives are finsihed being wiped. Fill out the `Data Destruction Certificate` located in Westgate's OneDrive -> Documents -> Documentation -> Data Destruction Certificates. 

6. Once the form is completed and digitally signed. Pass the drive to another tech for them to confirm data destruction and get the second signature on the form. Place the completed form in the Data Destruction Certificates directory in OneDrive. 

---
[back](./README.md)

