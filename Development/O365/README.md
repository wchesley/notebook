[back](../README.md)

# Microsoft Office 365

General notes regarding developing or working with O365 API programmatically. 


## Teams - Webhook

> This assumes you have an incoming webhook already setup for your Teams channel. If not, see [here](https://learn.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook?tabs=newteams%2Cdotnet)

## Send Adaptive Cards using an Incoming Webhook

To send Adaptive Cards with text or a Base64 encoded image through an Incoming Webhook, follow these steps:

1. [Set up a custom webhook](https://learn.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook) in Teams.
2. Create Adaptive Card JSON file using the following code:
- [Text](https://learn.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/connectors-using?tabs=cURL%2Ctext1#tabpanel_2_text1)
- [Base64 encoded image](https://learn.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/connectors-using?tabs=cURL%2Ctext1#tabpanel_2_image1)

JSON

```
    {
       "type":"message",
       "attachments":[
          {
             "contentType":"application/vnd.microsoft.card.adaptive",
             "contentUrl":null,
             "content":{
                "$schema":"http://adaptivecards.io/schemas/adaptive-card.json",
                "type":"AdaptiveCard",
                "version":"1.2",
                "body":[
                    {
                    "type": "TextBlock",
                    "text": "For Samples and Templates, see https://adaptivecards.io/samples"
                    }
                ]
             }
          }
       ]
    }

```

The properties for Adaptive Card JSON file are as follows:

- The `"type"` field must be `"message"`.
- The `"attachments"` array contains a set of card objects.
- The `"contentType"` field must be set to Adaptive Card type.
- The `"content"` object is the card formatted in JSON.

### Taken from [Stackoverflow](https://stackoverflow.com/questions/50753072/microsoft-teams-webhook-generating-400-for-adaptive-card)

I'm using [axios](https://www.npmjs.com/package/axios) to send an Adaptive Card to a Teams Connector and I was getting this 
same error. In my case, I was able to resolve the issue by wrapping the 
card as an "attachment" to the message protocol shown in this link 
(syntax copied here for reference).

https://learn.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/connectors-using?tabs=cURL#send-adaptive-cards-using-an-incoming-webhook

```json
{
   "type":"message",
   "attachments":[
      {
         "contentType":"application/vnd.microsoft.card.adaptive",
         "contentUrl":null,
         "content":{
            "$schema":"http://adaptivecards.io/schemas/adaptive-card.json",
            "type":"AdaptiveCard",
            "version":"1.4",
            "body":[
                {
                "type": "TextBlock",
                "text": "For Samples and Templates, see https://adaptivecards.io/samples"
                }
            ]
         }
      }
   ]
}

```

By sending the above JSON as the request body (`data` argument for axios), I successfully got the Adaptive Card to show up in my Teams Channel.

As you can see, the value of `"content"` is the Adaptive Card structure. The Adaptive Card follows the documented syntax, found here:

https://learn.microsoft.com/en-us/adaptive-cards/authoring-cards/getting-started

https://learn.microsoft.com/en-us/answers/questions/400502/adaptive-cards-with-incoming-webhooks-in-microsoft.html

But ultimately, I found it easier to work with this "Designer" https://www.adaptivecards.io/designer/
which provides a WYSIWYG interface.

I am sending the request to a Connector that I created in Teams by following the instructions found here:

https://learn.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook#create-incoming-webhook-1

And now it responds with 200 OK and shows up in the Channel!