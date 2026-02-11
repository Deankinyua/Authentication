defmodule Authentication.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Authentication.Accounts.User
  alias Authentication.Accounts.UserToken
  alias Authentication.Repo

  @type changeset :: Ecto.Changeset.t()
  @type params :: map()
  @type token :: binary()
  @type user :: User.t()
  @type user_id :: Ecto.UUID.t()

  @spec get_or_create_user(params()) :: {:ok, user()} | {:error, changeset()}
  def get_or_create_user(%{email: email} = user) do
    case get_user_by_email(email) do
      nil ->
        register_user(user)

      user ->
        {:ok, user}
    end
  end

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  @spec get_user_by_email(String.t()) :: user() | nil
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_user!(user_id()) :: user()
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec register_user(params()) :: {:ok, user()} | {:error, changeset()}
  def register_user(attrs \\ %{}) do
    %User{}
    |> change_user(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  @spec change_user(user(), params()) :: changeset()
  def change_user(%User{} = user, attrs \\ %{}) do
    User.user_changeset(user, attrs)
  end

  @doc """
  Generates a session token.
  """
  @spec generate_user_session_token(user()) :: binary()
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.

  If the token is valid `{user, token_inserted_at}` is returned, otherwise `nil` is returned.
  """
  @spec get_user_by_session_token(token() | nil) :: user() | nil
  def get_user_by_session_token(nil), do: nil

  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  @spec delete_user_session_token(token()) :: :ok
  def delete_user_session_token(token) do
    query = UserToken.token_and_context_query(token, "session")
    Repo.delete_all(query)

    :ok
  end

  @doc """
  Deletes all remaining tokens from db that belong to user.

  ## Examples

      iex> clear_all_tokens_for_user(%ElixirDrops.Accounts.User{})
      :ok

  """
  @spec clear_all_tokens_for_user(user()) :: :ok
  def clear_all_tokens_for_user(user) do
    q = UserToken.user_and_contexts_query(user, :all)
    Repo.delete_all(q)
    :ok
  end
end
