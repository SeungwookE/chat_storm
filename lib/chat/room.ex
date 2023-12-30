defmodule Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :is_private, :boolean, default: false
    field :name, :string
    field :room_code, :string
    field :team_only, :boolean, default: false
    field :user_id, :id
    field :team_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :team_only, :room_code, :is_private])
    |> validate_required([:name, :team_only, :room_code, :is_private])
  end
end
