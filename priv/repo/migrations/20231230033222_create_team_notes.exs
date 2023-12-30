defmodule Chat.Repo.Migrations.CreateTeamNotes do
  use Ecto.Migration

  def change do
    create table(:team_notes) do
      add :team_id, references(:teams, on_delete: :nothing)
      add :message_id, references(:messages, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:team_notes, [:team_id])
    create index(:team_notes, [:message_id])
  end
end
