defmodule EssentialTupleLake.Ports.RelationSource do
  @moduledoc """
  Driving (primary) port: read an ETNF relation by name into rows.

  The core specifies this; adapters (parquet, fixtures) implement it. Data flows IN from the outside.
  """

  @callback read(name :: String.t()) :: [map()]
end
