defmodule EssentialTupleLake.Core.IdentityTest do
  use ExUnit.Case, async: true

  alias EssentialTupleLake.Core.Identity

  # Golden values computed by the origin Python etnf.py. These MUST hold: the parquet lake already
  # stores these uuids, so the Elixir port has to reproduce them byte-for-byte.
  test "namespace + entity keys are byte-compatible with the origin Python" do
    assert Identity.namespace() == "2fc6d0bc-5970-5e20-b9cb-3ab9f6274896"
    assert Identity.asset_uuid("scene:forest#abc") == "f7a643aa-e696-53e1-8245-d8a035376e4c"

    assert Identity.asset_uuid("godot_mesh:3d/platformer/player/player.glb") ==
             "c604c0eb-a4b0-5b4b-aa75-f86e467567f3"

    assert Identity.user_uuid("uro:user-a") == "0faee11c-c1ac-5766-acb6-664d64f0d87e"
    assert Identity.session_uuid("uro_backpack:bp-1") == "5c061262-dafa-577e-971c-a6b3330659b9"
  end

  test "deterministic and type-namespaced" do
    assert Identity.asset_uuid("k") == Identity.asset_uuid("k")
    assert Identity.entity_uuid("asset", "x") != Identity.entity_uuid("user", "x")
  end

  test "empty components are rejected" do
    assert_raise ArgumentError, fn -> Identity.entity_uuid("", "x") end
    assert_raise ArgumentError, fn -> Identity.entity_uuid("asset", "") end
  end
end
