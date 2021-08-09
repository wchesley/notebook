# Redis

Nextcloud is configured to use Redis for a distributed cache. Configured per Nextclouds docs at: 

[Memory caching - Nextcloud latest Administration Manual latest documentation](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/caching_configuration.html)

# Accessing the Redis queue

```jsx
redis-cli -h acmecorp.cache.amazonaws.com
```