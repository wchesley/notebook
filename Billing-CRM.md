# Billing CRM

[Contacts](Billing%20CRM%202b52c3a4b4b74f068bb1cd74dbffe62e/Contacts%20a220e2a3e69c4cf490fa4103e83db0c8.csv)

## How this template works

You can delete this once you get the hang of it!

---

**We used this formula in the `Status` column of the table above.**

```jsx
if(dateBetween(now(), prop("Last Spoke"), "months") > 3, "Time to reach out!", "👍")
```

If more than 3 months have passed since the last time you contacted the person, you'll see **"Time to reach out!"** appear next to their name. 

- Edit the number 3 to change the time range for outreach.
- Change the message that appears by editing "Time to reach out!" or the "👍"

## Other cool things about this CRM

---

- Click `All Contacts` at the top left of your table to view your people different ways — like just your professional contacts, or just your college friends.
- Hover over anyone's name and click `⤢ OPEN` to open an entire page about them where you can store their address, favorite dessert 🍰, or any other relevant info!