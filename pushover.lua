--[[

	==================================================
	File:		pushover.lua
	Author:		@luastoned
	Version:	v1.0
	==================================================

--]]

local pushover = {
	api_version = "1",
	api_url = "https://api.pushover.net/",
}

-- Patch!
require("patch")

-- Always set me when using SSL, before loading framework.
TURBO_SSL = true
local turbo = require("turbo")

local function push(user, token)
	local pushtbl = table.copy(pushover)
	return function(request, callback, ...)
		local arg = {...}
		local callback = callback or function() end
		local url = pushtbl.api_url .. pushtbl.api_version .. "/messages.json"
		
		request.user = request.user or user
		request.token = request.token or token
		request.message = request.message or "You forgot to send a message!"
		
		local tio = turbo.ioloop.instance()
		local function pushCallback()
			-- Must place everything in a IOLoop callback.
			local res = coroutine.yield(turbo.async.HTTPClient():fetch(url, {
				method = "POST",
				params = request,
			}))
			
			if (res.error or res.headers:get_status_code() ~= 200) then
				-- Check for errors.
				tio:close()
				return
			else
				-- Print result to stdout.
				-- print(res.body)
				callback(res.body, unpack(arg))
			end
			tio:close()
		end

		tio:add_callback(pushCallback)
		tio:start()
	end
end

local meta = {
	__call = function(tbl, ...)
		return push(unpack({...}))
	end
}

setmetatable(pushover, meta)
return pushover