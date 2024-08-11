defmodule Hermes.RouterTest do
  @moduledoc """
  Tests for the Hermes.Router module.
  """

  use ExUnit.Case, async: true

  setup_all do
    %{router: %Hermes.Router.Literal{entries: [{?a..?m, :foo@l14}, {?n..?z, :bar@l14}]}}
  end

  @tag :distributed
  test "node routing success", %{router: router} do
    assert Hermes.Router.route(router, "dummy_bucket", Kernel, :node, []) == :foo@l14
    assert Hermes.Router.route(router, "zombie_bucket", Kernel, :node, []) == :bar@l14
  end

  test "node routing failure", %{router: router} do
    assert_raise Hermes.Router.Error, ~r"No route found for \"<<0>>\" in table", fn ->
      Hermes.Router.route(router, "<<0>>", Kernel, :node, [])
    end
  end
end
