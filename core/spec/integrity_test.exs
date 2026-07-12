# SPDX-License-Identifier: MIT OR Apache-2.0
# Copyright (c) 2026 K. S. Ernest (iFire) Lee and weftspun contributors

defmodule EssentialTupleLake.Core.IntegrityTest do
  use ExUnit.Case, async: true

  alias EssentialTupleLake.Core.Integrity

  test "assert_unique_pk passes on unique keys and raises on a duplicate" do
    assert Integrity.assert_unique_pk([%{"id" => 1}, %{"id" => 2}], ["id"]) == :ok
    assert_raise ArgumentError, fn -> Integrity.assert_unique_pk([%{"id" => 1}, %{"id" => 1}], ["id"]) end
  end

  test "assert_unique_pk supports composite keys" do
    rows = [%{"a" => 1, "b" => "x"}, %{"a" => 1, "b" => "y"}]
    assert Integrity.assert_unique_pk(rows, ["a", "b"]) == :ok
  end

  test "assert_fk_resolves passes when every fk resolves and raises on an orphan" do
    parent = [%{"pk" => "a"}, %{"pk" => "b"}]
    assert Integrity.assert_fk_resolves([%{"fk" => "a"}], "fk", parent, "pk") == :ok
    assert_raise ArgumentError, fn -> Integrity.assert_fk_resolves([%{"fk" => "z"}], "fk", parent, "pk") end
  end
end
