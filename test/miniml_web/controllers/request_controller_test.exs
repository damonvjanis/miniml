defmodule MinimlWeb.RequestControllerTest do
  use MinimlWeb.ConnCase

  alias Miniml.Requests
  alias Miniml.Requests.Request

  @create_attrs %{full: "some full", minified: "some minified"}
  @update_attrs %{full: "some updated full", minified: "some updated minified"}
  @invalid_attrs %{full: nil, minified: nil}

  def fixture(:request) do
    {:ok, request} = Requests.create_request(@create_attrs)
    request
  end

  
  defp relationships do
    %{}
  end

  setup %{conn: conn} do
    conn = conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")
      
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, request_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates request and renders request when data is valid", %{conn: conn} do
    conn = post conn, request_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "request",
        "attributes" => @create_attrs,
        "relationships" => relationships
      }
    }
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, request_path(conn, :show, id)
    data = json_response(conn, 200)["data"]
    assert data["id"] == id
    assert data["type"] == "request"
    assert data["attributes"]["full"] == @create_attrs.full
    assert data["attributes"]["minified"] == @create_attrs.minified
  end

  test "does not create request and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, request_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "request",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen request and renders request when data is valid", %{conn: conn} do
    %Request{id: id} = request = fixture(:request)
    conn = put conn, request_path(conn, :update, request), %{
      "meta" => %{},
      "data" => %{
        "type" => "request",
        "id" => "#{request.id}",
        "attributes" => @update_attrs,
        "relationships" => relationships
      }
    }

    conn = get conn, request_path(conn, :show, id)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{id}"
    assert data["type"] == "request"
    assert data["attributes"]["full"] == @update_attrs.full
    assert data["attributes"]["minified"] == @update_attrs.minified
  end

  test "does not update chosen request and renders errors when data is invalid", %{conn: conn} do
    request = fixture(:request)
    conn = put conn, request_path(conn, :update, request), %{
      "meta" => %{},
      "data" => %{
        "type" => "request",
        "id" => "#{request.id}",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen request", %{conn: conn} do
    request = fixture(:request)
    conn = delete conn, request_path(conn, :delete, request)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, request_path(conn, :show, request)
    end
  end
end
