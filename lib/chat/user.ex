defmodule Chat.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :level, :string
    field :name, :string
    field :password, :string
    field :roll, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :roll, :level, :password])
    |> validate_required([:name, :roll, :level, :password])
  end
end
