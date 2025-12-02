# SCCM Issues

- updates not installing for sites outside of autoinc amarillo CO. Seeing error 0x80240438, aka updates not found, network error.  
  - Have added deployment options foreach site, no change.
  - set maintenance window foreach site, no change.
  - added firewall allowance in & out for KOAMA-DC2, no change. 
  - Testing with dedicated deployment rule for WTN.
  - Add alternate ports for client requests, 8530 & 8531 (WSUS) via administration -> Site Config -> Sites -> right click site and select 'properties'.