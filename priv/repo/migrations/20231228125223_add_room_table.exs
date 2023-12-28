defmodule Chat.Repo.Migrations.AddRoomTable do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :team_code, :string
      timestamps()
    end

    create table(:users) do
      add :name, :string
      add :role, :string
      add :level, :string
      add :password, :string
      timestamps()
    end

    create table(:user_teams) do
      add :user_id, references(:users, on_delete: :nothing)
      add :team_id, references(:teams, on_delete: :nothing)
    end

    create table(:rooms) do
      add :name, :string
      add :team_only, :boolean, default: false
      add :room_code, :string
      add :is_private, :boolean, default: false
      add :user_id, references(:users, on_delete: :nothing)
      add :team_id, references(:teams, on_delete: :nothing)
      timestamps()
    end

    create table(:user_rooms) do
      add :user_id, references(:users, on_delete: :nothing)
      add :room_id, references(:rooms, on_delete: :nothing)
    end

    create table(:participants) do
      add :room_id, references(:rooms, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
    end

    create table(:messages) do
      add :room_id, references(:rooms, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :content, :string
      timestamps()
    end

    create table(:team_notes) do
      add :team_id, references(:teams, on_delete: :nothing)
      add :message_id, references(:messages, on_delete: :nothing)
    end
  end
end
