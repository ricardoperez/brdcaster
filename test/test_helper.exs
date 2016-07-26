ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Brdcaster.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Brdcaster.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Brdcaster.Repo)

