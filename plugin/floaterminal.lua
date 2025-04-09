local M = {}

local ts = vim.treesitter
local parsers = require("nvim-treesitter.parsers")

local p = function(value)
  print(vim.inspect(value))
end

local t = function(node)
  print(ts.get_node_text(node, 0))
end

function M.insert_rust()
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
  local table_name_query = ts.query.parse(lang, "(create_table (object_reference name: (identifier) @identifier))")
  local fk_query = ts.query.parse(
    lang,
    [[
    (column_definition 
      name: (identifier) @fk
      (keyword_references))
    ]]
  )

  local cols = {}
  for _, match, _ in query:iter_captures(curr_node, 0) do
    table.insert(cols, ts.get_node_text(match, 0))
  end

  local table_name = ""
  for _, match, _ in table_name_query:iter_captures(curr_node, 0) do
    table_name = ts.get_node_text(match, 0)
  end

  local fks = {}
  for _, match, _ in fk_query:iter_captures(curr_node, 0) do
    table.insert(fks, ts.get_node_text(match, 0))
  end

  local internal_ids = ""
  for i, value in ipairs(fks) do
    internal_ids = internal_ids
      .. "let "
      .. value
      .. "= id_map_db::get_"
      .. value
      .. "_internal_id(&args."
      .. value
      .. ", pool).await?;\n"
  end

  local arg_cols = {}
  for i, value in ipairs(cols) do
    arg_cols[i] = "args." .. value
  end

  local insert_col_str = "(" .. table.concat(cols, ", ") .. ")\n"
  local col_insert_vars_str = table.concat(arg_cols, ",\n        ") .. ",\n"
  local total_cols = #cols

  local numbers = {}
  for i = 1, total_cols do
    table.insert(numbers, "$" .. i)
  end
  local args_str = "(" .. table.concat(numbers, ", ") .. ")\n"

  local result = internal_ids
    .. [[
    sqlx::query!(
        r#"
        insert into ]]
    .. table_name
    .. "\n"
    .. [[
          ]]
    .. insert_col_str
    .. [[
        values
          ]]
    .. args_str
    .. [[
        "#,
        ]]
    .. col_insert_vars_str
    .. [[
    )
    .execute(pool)
    .await
  ]]

  vim.fn.setreg("+", result)
end

function M.select_rust()
  local parser = parsers.get_parser()
  local lang = parser:lang()
  local tree = parser:parse()[1]

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
  local table_name_query = ts.query.parse(lang, "(create_table (object_reference name: (identifier) @identifier))")

  local cols = {}
  for _, match, _ in query:iter_captures(curr_node, 0) do
    table.insert(cols, ts.get_node_text(match, 0))
  end

  local table_name = ""
  for _, match, _ in table_name_query:iter_captures(curr_node, 0) do
    table_name = ts.get_node_text(match, 0)
  end

  local select_col_str = "    " .. table.concat(cols, ",\n            ")

  local result = [[
    sqlx::query_as!(
        ]] .. table_name .. ",\n" .. [[
        r#"
        select
        ]] .. select_col_str .. "\n" .. [[
        from
            ]] .. table_name .. "\n" .. [[
        "#,
    )
    .fetch_all(pool)
    .await
  ]]

  vim.fn.setreg("+", result)
end

vim.api.nvim_create_user_command("InsertRust", function()
  M.insert_rust()
end, {})

vim.api.nvim_create_user_command("SelectRust", function()
  M.select_rust()
end, {})

return M
