local ESX = nil

TriggerEvent("esx:getSharedObject", function(library)
    ESX = library
end)

SetHttpHandler(function(req, res)
    print(json.encode(req))

	local path = req.path

	if req.method == 'POST' then
		return handlePost(req, res)
	end

	-- should this be the index?
	if req.path == '/' then
		path = 'index.html'
	end

	-- remove any '..' from the path
	path = path:gsub("%.%.", "")

    res.send("tjena")

	return 
end)