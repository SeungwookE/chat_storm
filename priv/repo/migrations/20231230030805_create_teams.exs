defmodule Chat.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :team_code, :string

      timestamps(type: :utc_datetime)
    end
  end
end
