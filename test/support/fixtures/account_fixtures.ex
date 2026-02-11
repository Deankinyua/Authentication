defmodule Authentication.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Authentication.Accounts` context.
  """

  alias Authentication.Accounts
  alias Authentication.Accounts.User

  @doc """
  Generate a unique user email.
  """
  @spec unique_user_email() :: String.t()
  def unique_user_email, do: "user#{System.unique_integer()}@example.com"

  @doc """
  Generate a user.
  """
  @spec user_fixture(map()) :: User.t()
  def user_fixture(attrs \\ %{}) do
    unique_id = System.unique_integer([:positive])

    {:ok, user} =
      attrs
      |> Enum.into(%{
        avatar: "https://lh3.googleusercontent.com/a/#{unique_id}",
        email: unique_user_email(),
        username: "some_name_#{unique_id}"
      })
      |> Accounts.register_user()

    user
  end
end
