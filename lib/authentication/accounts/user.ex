defmodule Authentication.Accounts.User do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :avatar, :string
    field :email, :string
    field :username, :string

    timestamps(type: :utc_datetime)
  end

  @doc """
  A user changeset for registration.
  """
  @spec user_changeset(t(), map(), any()) ::
          Ecto.Changeset.t()
  def user_changeset(user, attrs, _opts \\ []) do
    user
    |> cast(attrs, [:avatar, :email, :username])
    |> validate_required([:avatar, :email, :username])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end
end
