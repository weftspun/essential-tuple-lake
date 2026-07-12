# SPDX-License-Identifier: MIT OR Apache-2.0
# Copyright (c) 2026 K. S. Ernest (iFire) Lee and weftspun contributors

defmodule EssentialTupleLake.Core.Identity do
  @moduledoc """
  Deterministic UUIDv5 entity keys — the content-addressable ETNF identity.

  Same canonical natural key -> same uuid, so a re-imported / rescaled duplicate resolves to the SAME
  id (free cold-start dedup). Byte-compatible with the origin Python `etnf.py` (the parquet lake already
  stores these uuids), so the namespace seed is kept verbatim and MUST NOT change.
  """

  # The lake namespace, derived once from the origin repo URL. Changing this would rekey the whole lake.
  @origin_url "https://github.com/V-Sekai-fire/vsk-session-item-recommendation-01"

  @doc "The fixed lake namespace uuid (uuid5 of the origin URL, in the RFC-4122 URL namespace)."
  def namespace, do: Uniq.UUID.uuid5(:url, @origin_url)

  @doc """
  `uuid5(namespace, "<entity_type>:<natural_key>")` — the SCHEMA.md key rule.

  Both components must be non-empty; an empty component is a programming error, not a data case.
  """
  def entity_uuid(entity_type, natural_key)
      when entity_type in ["", nil] or natural_key in ["", nil] do
    raise ArgumentError, "entity_type and natural_key must both be non-empty"
  end

  def entity_uuid(entity_type, natural_key) do
    Uniq.UUID.uuid5(namespace(), "#{entity_type}:#{natural_key}")
  end

  @doc "Asset identity keyed by its canonical natural key (content hash / normalized slug)."
  def asset_uuid(canonical_key), do: entity_uuid("asset", canonical_key)

  def user_uuid(natural_key), do: entity_uuid("user", natural_key)

  def session_uuid(natural_key), do: entity_uuid("session", natural_key)
end
