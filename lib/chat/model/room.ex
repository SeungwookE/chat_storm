defmodule Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias Chat.Room
  alias Chat.Repo

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
    |> IO.inspect()
    |> validate_required([:id, :name])
    |> validate_length(:name, min: 1, max: 15)
  end

  def create_room(room_name) do
    # 1. create a struct
    # 2. create a changeset from struct
    # 3. insert data
    %Room{}
    |> changeset(%{name: room_name})
    |> Repo.insert()
  end
end
