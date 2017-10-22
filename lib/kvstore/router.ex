defmodule KVstore.Router do
    use Plug.Router
  
    plug :match
    plug :dispatch

    def init(options) do
      options
    end
  
    post "/" do
      conn = fetch_query_params(conn)
      {ttl, _} = Integer.parse(conn.params["ttl"])
      result = KVstore.Storage.create(%StorageRecord{key: conn.params["key"], value: conn.params["val"], ttl: ttl})
      send_resp(conn, 200, "received #{inspect(result)}")
    end
    
    get "/" do
      conn = fetch_query_params(conn)
      result = KVstore.Storage.read(conn.params["key"])
      send_resp(conn, 200, "received #{inspect(result)}")
    end
    
    put "/" do
      conn = fetch_query_params(conn)
      {ttl, _} = Integer.parse(conn.params["ttl"])
      result = KVstore.Storage.update(%StorageRecord{key: conn.params["key"], value: conn.params["val"], ttl: ttl})
      send_resp(conn, 200, "received #{inspect(result)}")
    end
    
    delete "/" do
      conn = fetch_query_params(conn)
      result = KVstore.Storage.delete(conn.params["key"])
      send_resp(conn, 200, "received #{inspect(result)}")
    end

    match _ do
      IO.inspect(conn.params)
      send_resp(conn, 404, "Страница не найдена")
    end

  end
  