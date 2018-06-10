defmodule Miniml.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add :full, :string
      add :minified, :string

      timestamps()
    end

  end
end
