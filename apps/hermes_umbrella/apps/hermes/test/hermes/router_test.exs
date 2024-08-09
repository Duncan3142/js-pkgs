defmodule Hermes.RouterTest do
  @moduledoc """
  Tests for the Hermes.Router module.
  """

  use ExUnit.Case, async: true

  @tag :distributed
  test "node routing success" do
    assert Hermes.Router.route("dummy_bucket", Kernel, :node, []) == :"foo@l14"
    assert Hermes.Router.route("zombie_bucket", Kernel, :node, []) == :"bar@l14"
  end

  test "node routing failure" do
    assert_raise ArgumentError, "No route found for \"<<0>>\" in table [{97..109, :foo@l14}, {110..122, :bar@l14}]", fn -> Hermes.Router.route("<<0>>", Kernel, :node, []) end
  end

end
