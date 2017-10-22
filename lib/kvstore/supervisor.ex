defmodule KVstore.Supervisor do
    use Supervisor
  
    def start_link(opts) do
      Supervisor.start_link(__MODULE__, opts, opts)
    end
  
    def init(opts) do
      children = [
        {KVstore.Storage, [file_name: opts[:table_name]]},
        Plug.Adapters.Cowboy.child_spec(:http, KVstore.Router, [], port: 8080)
      ]
  
      Supervisor.init(children, strategy: :one_for_one)
    end
  end
  