defmodule HermesUmbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      build_path: ".build",
      deps_path: ".deps",
      deps: deps(),
      test_coverage: [output: ".cover"],
      releases: releases()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [{:credo, "~> 1.7", only: [:dev, :test], runtime: false}]
  end

  defp releases do
    [
      api: [
        version: "0.0.1",
        applications: [
          hermes_server: :permanent
        ],
        cookie: "my_cookie"
      ],
      app_alpha: [
        version: "0.0.1",
        applications: [
          hermes: :permanent
        ],
        cookie: "my_cookie"
      ],
      app_beta: [
        version: "0.0.1",
        applications: [
          hermes: :permanent
        ],
        cookie: "my_cookie"
      ]
    ]
  end
end
