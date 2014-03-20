![Pushover](https://pushover.net/assets/pushover-header-eaa79ef56c7041125acbe9fb9290b2fa.png)

Send [pushover.net](http://pushover.net) notifications from [Turbo.lua](http://turbolua.org)

## Examples

### Sending a message
```lua
local pushover = require("pushover")
local push = pushover("pushover_user", "pushover_token")

-- Optional parameters may be included: device, title, url, url_title, priority, timestamp, sound
-- Read more about the parameters on: https://pushover.net/api

local request = {
	message = "Hello World!",	-- required
	title = "luvit.io",			-- optional
	sound = "magic",			-- optional
}

push(request)
```

### Sending a message to multiple users
```lua
local users = {
	"pushover_user1",
	"pushover_user2",
	"pushover_user3",
}

local request = {message = "Hello World!"}

for _, user in pairs(users) do
	request.user = user
	push(request)
end
```
