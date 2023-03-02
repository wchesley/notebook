# Discord
Also see [ByteBot](../ByteBot/README.md)

## Webhooks over curl
Get Webhook URL for channel or create one. 

Test it's working like so: 
`curl -H "Content-Type: application/json" -d '{"username": "test", "content": "hello"}' "https://discord.com/api/webhooks/Your_server/Your_actual_webhook_url_here"`

### Structure of Webhook

Before using Webhooks you have to know the structure. All elements listed here are optional but request body should contain content, embeds or attachments, otherwise request will fail.

* `username` - overrides the predefined username of the webhook
* `avatar_url` - overrides the predefined avatar of the webhook
* `content` - text message, can contain up to 2000 characters
* `embeds` - array of embed objects. In comparison with bots, webhooks can have more than one custom embed
    * `color` - color code of the embed. You have to use Decimal numeral system, not Hexadecimal. You can use SpyColor for that. It has decimal number converter.
    * `author` - embed author object
        * `name` - name of author
        * `url` - url of author. If name was used, it becomes a hyperlink
        * `icon_url` - url of author icon
    * `title` - title of embed
    * `url` - url of embed. If title was used, it becomes hyperlink
    * `description` - description text
    * `fields` - array of embed field objects
        * `name` - name of the field
        * `value` - value of the field
        * `inline` - if true, fields will be displayed in the same line, 3 per line, 4th+ will be moved to the next line
    * `thumbnail` - embed thumbnail object
        url - url of thumbnail
    * `image` - embed image object
        url - image url
    * `footer` - embed footer object
        * `text` - footer text, doesn't support Markdown
        * `icon_url` - url of footer icon
    * `timestamp` - ISO8601 timestamp (yyyy-mm-ddThh:mm:ss.msZ)
* `tts` - makes message to be spoken as with /tts command
* `allowed_mentions` - object allowing to control who will be mentioned by message
    * `parse` - array, can include next values: "roles", "users" and "everyone", depends on which decides which mentions work. If empty, none mention work.
    * `roles` - array, lists ids of roles which can be mentioned with message, remove "roles" from parse when you use this one.
    * `users` - array, lists ids of roles which can be mentioned with message, remove "users" from parse when you use this one.

### Example bash script posting alert via curl
<sub>pulled from <a href="https://gist.github.com/ergusto/f09cd2bb9a9146b5c56f67991e3bfabf">Github Gist Here</a></sub>
```bash
#!/bin/sh

WEBHOOK_URL="put your url here"
JSON="{\"content\":null,\"embeds\": [{\"color\": \"16237652\"},{\"timestamp\": \"YYYY-MM-DDTHH:MM:SS.MSSZ\"},{\"fields\": [{\"name\": \"Grabbed Movie\",\"value\": \"$radarr_movie_title\"},{\"name\": \"Release Name\",\"value\": \"$radarr_release_title\"},{\"name\": \"Quality\",\"value\": \"$radarr_release_quality\",\"inline\": true},{\"name\": \"Source\",\"value\": \"$radarr_release_indexer\",\"inline\": true},{\"name\": \"Size\",\"value\": \"$radarr_release_size\"}]}]}\"

curl -d "$JSON" -H "Content-Type: application/json" "$WEBHOOK_URL"
```

```json
{\"content\":null,\"embeds\": [{\"color\": \"16237652\"},{\"timestamp\": \"YYYY-MM-DDTHH:MM:SS.MSSZ\"},{\"fields\": [{\"name\": \"Begining Backup\",\"value\": \"$radarr_movie_title\"}]}\"
```
