# SPDX-License-Identifier: MIT OR Apache-2.0
# Copyright (c) 2026 K. S. Ernest (iFire) Lee and weftspun contributors

defmodule EssentialTupleLake.Ports.RelationSink do
  @moduledoc """
  Driven (secondary) port: write an ETNF relation, enforcing its primary key.

  The core's output flows OUT through this to the outside world; adapters (parquet, fixtures) implement
  it. Multiple adapters can implement one port, so a single relation can fan to several destinations.
  """

  @callback write(name :: String.t(), rows :: [map()], primary_key :: [String.t()]) :: :ok
end
