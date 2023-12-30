defmodule Chat.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participants" do

    field :room_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [])
    |> validate_required([])
  end
end
