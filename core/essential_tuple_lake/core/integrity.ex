defmodule EssentialTupleLake.Core.Integrity do
  @moduledoc """
  ETNF integrity checks — PK-unique and FK-resolves — as pure functions over rows (maps).

  These are the invariants every relation must hold before it enters the lake: a primary key is
  unique, and every foreign key resolves into its parent. Zero dependencies, so they live in `core/`.
  """

  @doc "Return `:ok` if every `pk` tuple across `rows` is unique; raise on the first duplicate."
  def assert_unique_pk(rows, pk) when is_list(pk) do
    duplicate =
      rows
      |> Enum.frequencies_by(fn row -> Enum.map(pk, &Map.fetch!(row, &1)) end)
      |> Enum.find(fn {_key, count} -> count > 1 end)

    case duplicate do
      nil -> :ok
      {key, _count} -> raise ArgumentError, "duplicate PK #{inspect(pk)} = #{inspect(key)}"
    end
  end

  @doc "Return `:ok` if every `child[fk]` resolves into some `parent[parent_key]`; raise on orphans."
  def assert_fk_resolves(child_rows, fk, parent_rows, parent_key) do
    parent_keys = MapSet.new(parent_rows, &Map.fetch!(&1, parent_key))

    orphans =
      child_rows
      |> Enum.map(&Map.fetch!(&1, fk))
      |> Enum.reject(&MapSet.member?(parent_keys, &1))

    case orphans do
      [] ->
        :ok

      _ ->
        raise ArgumentError,
              "#{length(orphans)} orphan FK #{fk} not in #{parent_key}: #{inspect(Enum.take(orphans, 3))}"
    end
  end
end
