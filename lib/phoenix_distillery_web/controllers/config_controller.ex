defmodule PhoenixDistilleryWeb.ConfigController do
    use PhoenixDistilleryWeb, :controller

    def config_check(conn, _) do
        conn
        |> put_status(200)
        |> json(%{
            from_file: Application.get_env(:phoenix_distillery, :from_file),
            from_regular_env: Application.get_env(:phoenix_distillery, :from_regular_env),
            from_dynamic_env: Application.get_env(:phoenix_distillery, :from_dynamic_env)
        })
    end

end
