defmodule Chat.Repo.Migrations.AddUniqueConstraintToRooms do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      modify :name, :string, null: false
    end
    create unique_index(:rooms, :name)
  end
end
