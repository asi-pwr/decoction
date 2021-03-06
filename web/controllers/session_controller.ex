defmodule Decoction.SessionController do
  use Decoction.Web, :controller
  use Guardian.Phoenix.Controller

  def new(conn, _params, user, _claims) do
    case user do
      nil ->
        render conn, "new.html"
      _ ->
        conn
        |> put_flash(:info, "You are already logged in.")
        |> redirect(to: "/")
    end
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}, _user = nil, _claims) do
    case Decoction.Auth.verify_email_and_password(conn, email, password, repo: Repo) do
      {:ok, user, conn} ->
        conn
        |> Decoction.Auth.login(user)
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username/password combination.")
        |> render("new.html")
    end
  end

  def delete(conn, _params, _user, _claims) do
    conn
    |> Decoction.Auth.logout()
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: "/")
  end
end
