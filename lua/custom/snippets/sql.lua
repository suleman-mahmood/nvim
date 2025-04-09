require("luasnip.session.snippet_collection").clear_snippets("sql")

local ls = require("luasnip")

-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

local function to_pascal_case(args, parent, user_args)
  local res = require("textcase").api.to_pascal_case(args[1][1])
  return res
end

ls.add_snippets("sql", {
  s(
    "create_table",
    fmta(
      [[
create table <table_name> (
  id bigint primary key generated always as identity,
  public_id text not null unique,

  <finish>

  created_at timestamptz not null default now()
);
      ]],
      {
        table_name = i(1),
        finish = i(0),
      }
    )
  ),
  s(
    "enum",
    fmta(
      [[
create type <enum_name> as enum (
  <finish>
);
      ]],
      {
        enum_name = i(1),
        finish = i(0),
      }
    )
  ),
  s(
    "fk",
    fmta(
      [[
<table_name>_id bigint not null references <table_name_same>(id),
<finish>
      ]],
      {
        table_name = i(1),
        table_name_same = rep(1),
        finish = i(0),
      }
    )
  ),
})
