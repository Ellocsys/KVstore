defmodule KVstore do
    use Application
    
      def start(_type, _args) do
        table_name = :test_table
        KVstore.Supervisor.start_link([name: KVstore.Supervisor, table_name: table_name])
      end
  
    end