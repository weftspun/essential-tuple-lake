# SPDX-License-Identifier: MIT OR Apache-2.0
# Copyright (c) 2026 K. S. Ernest (iFire) Lee and weftspun contributors

defmodule EssentialTupleLake.MixProject do
  use Mix.Project

  # Hexagonal layout mapped onto mix source paths: the ports & adapters structure IS the directory
  # structure. core/ = zero-dep domain (+ core/spec/ tests), ports/ = behaviours, adapters/ = impls.
  def project do
    [
      app: :essential_tuple_lake,
      version: "0.1.0",
      elixir: "~> 1.18",
      elixirc_paths: ["core", "ports", "adapters"],
      test_paths: ["core/spec"],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      # core: RFC-4122 UUIDv5 — stable, content-addressable ETNF keys (pure Elixir, zero native deps).
      {:uniq, "~> 0.6"},
      # adapters: Polars-backed dataframes for parquet read/write + the join view.
      {:explorer, "~> 0.10"},
      # packaging: one self-contained cross-platform binary per target.
      {:burrito, "~> 1.3", runtime: false}
    ]
  end

  # `mix release` + Burrito wrap -> a single self-contained executable per target.
  defp releases do
    [
      essential_tuple_lake: [
        steps: [:assemble, &Burrito.wrap/1],
        burrito: [
          targets: [
            linux: [os: :linux, cpu: :x86_64],
            windows: [os: :windows, cpu: :x86_64]
          ]
        ]
      ]
    ]
  end
end
