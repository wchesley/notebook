# WAND (Westgate, Autotask, Nessus, Datto)

Automation tool I wrote to integrate Nessus, Datto and Autotask for the purpose of parsing Nessus reports, creating remediation tickets in Autotask for the scanned company, and track device vulnerability history. 

## Notes: 

Autotask api, get all companies: 

> You just need to specify all IDs greater than or equal to 0. Here is a GET query to retrieve all companies. Of course this does not illustrate pagination if you need over 500 entities, that would use the pageDetails.NextPageUrl included with the response.

```
GET

/Companies/query?search={"Filter":\[{"field":"Id","op":"gte","value":0}\]}
```
###### [source](https://www.reddit.com/r/Autotask/comments/hvur0t/rest_api_get_all/)

---