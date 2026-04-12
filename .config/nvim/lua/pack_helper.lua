---Helper to convert a string|function into a function via vim.cmd if needed
---@param callback function|string
---@return function
local function ensure_callback(callback)
	if type(callback) == "function" then
		return callback
	elseif type(callback) == "string" then
		return function() vim.cmd(callback) end
	end
	error("Invalid callback type: " .. type(callback))
end

---@class PackKeymap
---@field [1] string Mode
---@field [2] string Keymap
---@field [3] function|string Command
---@field [4]? string Description

---Helper to set multiple keymaps
---@param keymaps PackKeymap[]?
local function set_keymaps(keymaps)
	if not keymaps then return end
	for _, km in ipairs(keymaps) do
		vim.keymap.set(km[1], km[2], ensure_callback(km[3]), { desc = km[4] })
	end
end

---Helper to set autocommand on plugin install/update
---@param plugin string
---@param build_callback? function|string
local function build(plugin, build_callback)
	if not build_callback then return end
	build_callback = ensure_callback(build_callback)
	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			local name, kind = ev.data.spec.name, ev.data.kind
			if name == plugin and (kind == "install" or kind == "update") then
				if not ev.data.active then vim.cmd.packadd(plugin) end
				build_callback()
			end
		end
	})
end

---@class PackSpec
---@field [1]? string Positional source (e.g., "user/repo" or full URL)
---@field src? string Explicit source (e.g., "user/repo" or full URL)
---@field version? string Version specifier (e.g., "1.*", "^2.0", "latest")
---@field opts? table If provided, passed to the plugin's setup function
---@field after? function Function to run after adding the plugin
---@field keys? PackKeymap[] List of keymaps to set after adding the plugin
---@field build? function|string Callback to run after updating the plugin

---Helper to call vim.pack.add()
---@param spec PackSpec
function Pack(spec)
	local src = spec.src or spec[1]
	assert(src, "Pack: table must have a 'src' key or a positional string at [1]")
	if not src:match("^https?://") then
		src = "https://github.com/" .. src
	end
	local name = src:match("/([^/]+)$"):gsub("%.git$", "")
	build(name, spec.build)
	local pack = { src = src }
	pack.version = spec.version and vim.version.range(spec.version) or nil
	vim.pack.add({ pack })
	if spec.opts then
		local module_name = name:gsub("%.n?vim$", "")
		require(module_name).setup(spec.opts)
	end
	if spec.after then spec.after() end
	set_keymaps(spec.keys)
end
