defmodule KVstore.Supervisor do
    use Supervisor
  
    def start_link(opts) do
      Supervisor.start_link(__MODULE__, opts, opts)
    end
  
    def init(opts) do
      children = [
        {KVstore.Storage, [file_name: opts[:table_name]]},
      ]
  
      Supervisor.init(children, strategy: :one_for_one)
    end
  end
  