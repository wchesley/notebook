# Debug MongoDB data

Assign: Walker Chesley
Status: Completed

- Player online status is not updated when they go offline
- Online player count is never decremented (Shows 13 when I last looked)
    - Updating more correctly now, needs further verification. Tests maybe?
- ~~Steam Name is not updated on existing players~~
- ~~To assist in debugging this, print the whole player object that is sent back to the update_player() method.~~

```python
for item in player_obj:
	default.s_print(item)
```

- ~~Might have to adjust logic that sends data back to the update_player method? Will of course, have to see what we're sending back there~~
    - Scratch that^^^^ I remember now, that Savvy's SteamName was saved properly, it's just not updating those that are already there.