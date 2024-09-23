defmodule Chat.TeamNote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_notes" do

    field :team_id, :id
    field :message_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team_note, attrs) do
    team_note
    |> cast(attrs, [])
    |> validate_required([])
  end
end
