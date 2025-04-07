local M = {}

local ts = vim.treesitter
local parsers = require("nvim-treesitter.parsers")

local p = function(value)
  print(vim.inspect(value))
end

local t = function(node)
  print(ts.get_node_text(node, 0))
end

function M.print_query_captures()
  local parser = parsers.get_parser()
  local lang = parser:lang()
  local tree = parser:parse()[1]
  local root = tree:root()

  local query_str = [[
  (column_definition
    name: (identifier) @id)
  ]]

  local curr_node = ts.get_node()
  assert(curr_node, "No TS node at cursor position")

  --- @param node TSNode
  local function getParentCreateTableNode(node)
    if node:type() ~= "create_table" then
      local n_p = node:parent()

      if n_p == nil then
        return nil
      end
      return getParentCreateTableNode(n_p)
    end
    return node
  end

  curr_node = getParentCreateTableNode(curr_node)

  if curr_node == nil then
    p("No parent create_table found on cursor position")
    return
  end

  local query = ts.query.parse(lang, query_str)

  local result = ""
  for _, match, _ in query:iter_captures(curr_node, 0) do
    t(match)
    result = result .. "\n" .. ts.get_node_text(match, 0)
  end

  vim.fn.setreg("+", result)
end

vim.api.nvim_create_user_command("PrintCaptures", function()
  M.print_query_captures()
end, {})

return M
