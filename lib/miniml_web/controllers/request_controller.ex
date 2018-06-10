defmodule MinimlWeb.RequestController do
  use MinimlWeb, :controller

  alias Miniml.Requests
  alias Miniml.Requests.Request
  alias Miniml.Requests.Random

  action_fallback MinimlWeb.FallbackController

  def create(conn, %{"data" => %{"type" => "requests", "attributes" => params}}) do
    params = Map.put(params, "minified", Random.generate())

    with {:ok, %Request{} = request} <- Requests.create_request(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", request_path(conn, :show, request))
      |> render("show.json-api", data: request)
    end
  end

  def show(conn, %{"id" => id}) do
    request = Requests.get_request!(id)

    render(conn, "show.json-api", data: request)
  end

  def show_by_minified(conn, %{"id" => id}) do
    request = Requests.get_by!(id)

    render(conn, "show.json-api", data: request)
  end

  # def index(conn, _params) do
  #   requests = Requests.list_requests()
  #   render(conn, "index.json-api", data: requests)
  # end

  # def update(conn, %{"id" => id, "data" => data = %{"type" => "request", "attributes" => request_params}}) do
  #   request = Requests.get_request!(id)

  #   with {:ok, %Request{} = request} <- Requests.update_request(request, request_params) do
  #     render(conn, "show.json-api", data: request)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   request = Requests.get_request!(id)
  #   with {:ok, %Request{}} <- Requests.delete_request(request) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
