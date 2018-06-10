defmodule Miniml.Requests.Request do
  use Ecto.Schema
  import Ecto.Changeset


  schema "requests" do
    field :full, :string
    field :minified, :string

    timestamps()
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [:full, :minified])
    |> validate_required([:full])
  end
end
