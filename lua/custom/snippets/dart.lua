require("luasnip.session.snippet_collection").clear_snippets("dart")

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

ls.add_snippets("dart", {
  s(
    "apiget",
    fmta(
      [[
  Future<<<return_val>>> <fn>(String fsId, String? projId) async {
    final path = ApiPaths.<fn_same>Path(fsId, projId);
    final resp = await _apiService.get(path);
    return <return_val_same>.from(resp["data"]);
  }
      ]],
      {
        fn = i(1),
        fn_same = rep(1),
        return_val = i(2),
        return_val_same = rep(2),
      }
    )
  ),
  s(
    "apipost",
    fmta(
      [[
  Future<<void>> <fn>(String fsId, String? projId, <body_type> <body>) async {
    final path = ApiPaths.<fn_same>Path(fsId, projId);
    await _apiService.post(path, data: {
      "<finish>": <body_same>,
    });
  }
      ]],
      {
        fn = i(1),
        fn_same = rep(1),
        body_type = i(2),
        body = i(3),
        body_same = rep(3),
        finish = i(0),
      }
    )
  ),
  s(
    "apidelete",
    fmta(
      [[
  Future<<void>> <fn>(String fsId, String? projId, <body_type> <body>) async {
    final path = ApiPaths.<fn_same>Path(fsId, projId, <body_same>);
    await _apiService.delete(path);
  }
      ]],
      {
        fn = i(1),
        fn_same = rep(1),
        body_type = i(2),
        body = i(3),
        body_same = rep(3),
      }
    )
  ),
  s(
    "pathfsproj",
    fmta(
      [[
  static String <fn>(String fsId, String? projId) {
    if (projId != null) {
      return '$fiscalSponsorsApiPath/$fsId/project/$projId/<path>';
    }
    return '$fiscalSponsorsApiPath/$fsId/<path_same>';
  }
      ]],
      {
        fn = i(1),
        path = i(2),
        path_same = rep(2),
      }
    )
  ),
})
