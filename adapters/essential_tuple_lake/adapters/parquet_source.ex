# SPDX-License-Identifier: MIT OR Apache-2.0
# Copyright (c) 2026 K. S. Ernest (iFire) Lee and weftspun contributors

defmodule EssentialTupleLake.Adapters.ParquetSource do
  @moduledoc "`RelationSource` over Explorer/Polars parquet — reads `<lake_dir>/<name>.parquet` to rows."

  @behaviour EssentialTupleLake.Ports.RelationSource

  alias Explorer.DataFrame

  @impl true
  def read(name) do
    Path.join(lake_dir(), "#{name}.parquet")
    |> DataFrame.from_parquet!()
    |> DataFrame.to_rows()
  end

  defp lake_dir, do: Application.get_env(:essential_tuple_lake, :lake_dir, "lake")
end
