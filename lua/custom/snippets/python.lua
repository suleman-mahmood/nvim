require("luasnip.session.snippet_collection").clear_snippets("python")

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

ls.add_snippets("python", {
  s(
    "workflow",
    fmta(
      [[
from loguru import logger
from pydantic import BaseModel

from mazlo.database.context.data_context import DataContext
from mazlo.utils.db_utils import must
from mazlo.vendor.synctera_client import SyncteraClient
from mazlo.workflow.workflow import workflow


class <workflow_name>Args(BaseModel):
    <args_list>


@workflow
async def <workflow_fn_name>(arg: <workflow_name_same>Args, data_context: DataContext, synctera_client: SyncteraClient):
    <finish>
      ]],
      {
        workflow_name = i(1),
        workflow_name_same = rep(1),
        workflow_fn_name = i(2),
        args_list = i(3),
        finish = i(0),
      }
    )
  ),
  s(
    "mm",
    fmta(
      [[
<module_name> = module_mocker(<workflow>, "<module_name_same>")
      ]],
      {
        module_name = i(1),
        module_name_same = rep(1),
        workflow = i(2),
      }
    )
  ),
  s(
    "route",
    fmta(
      [[
class <body_same>Body(BaseModel):
    pass


@fs_router.<method>("<route>")
@proj_router.<method_same>("<route_same>")
async def <route_fn>(
    body: <body>Body,
    fiscal_sponsor_id: str,
    project_id: str | None = None,
    data_context: DataContext = Depends(get_data_context(required_permissions=["<perm>"])),
):
    <finish>
      ]],
      {
        method = i(1),
        method_same = rep(1),
        route = i(2),
        route_same = rep(2),
        route_fn = i(3),
        body = i(4),
        body_same = rep(4),
        perm = i(5),
        finish = i(0),
      }
    )
  ),
  s(
    "testunit",
    fmta(
      [[
@pytest.mark.parametrize(
    "",
    [
      "",
    ],
)
async def test_<fn_name>(module_mocker, user_data_context_with_pg: DataContext):
    # Arrange
    <finish>
    # financial_unit_db.get_financial_unit = AsyncMock(return_value=financial_unit)

    # Act

    # Assert
    # financial_unit_db.get_financial_unit.assert_awaited_once_with(user_data_context_with_pg, financial_unit.unit_id)
      ]],
      {
        fn_name = i(1),
        finish = i(0),
      }
    )
  ),
})
