# SPDX-License-Identifier: MIT OR Apache-2.0
# Copyright (c) 2026 K. S. Ernest (iFire) Lee and weftspun contributors

defmodule EssentialTupleLake.Adapters.ParquetSink do
  @moduledoc """
  `RelationSink` over Explorer/Polars parquet — one relation per `<lake_dir>/<name>.parquet`.

  Enforces PK-unique (the domain invariant) before writing, so a bad relation never reaches disk.
  """

  @behaviour EssentialTupleLake.Ports.RelationSink

  alias EssentialTupleLake.Core.Integrity
  alias Explorer.DataFrame

  @impl true
  def write(name, rows, primary_key) do
    Integrity.assert_unique_pk(rows, primary_key)

    path = Path.join(lake_dir(), "#{name}.parquet")
    File.mkdir_p!(lake_dir())

    rows
    |> DataFrame.new()
    |> DataFrame.to_parquet!(path)

    :ok
  end

  defp lake_dir, do: Application.get_env(:essential_tuple_lake, :lake_dir, "lake")
end
