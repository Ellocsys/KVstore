defmodule KVstore do
    use Application
    
      def start(_type, _args) do
        table_name = Application.get_env(:kvstore, :storage_name)
        KVstore.Supervisor.start_link([name: KVstore.Supervisor, table_name: table_name])
      end
  
    end