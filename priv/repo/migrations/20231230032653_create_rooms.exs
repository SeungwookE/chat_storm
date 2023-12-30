defmodule Chat.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :team_only, :boolean, default: false, null: false
      add :room_code, :string
      add :is_private, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)
      add :team_id, references(:teams, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:rooms, [:user_id])
    create index(:rooms, [:team_id])
  end
end
