defmodule KVstore.Storage do
    use GenServer
    @moduledoc """
    Модуль, который отвечает за хранение и предоставление данных в DETS
    """
    
    def init(opts) do
        file_name = Keyword.fetch!(opts, :file_name)
        refs  = %{}
        {:ok, {file_name, refs}}
    end
    
    def start_link(opts) do
        GenServer.start_link(__MODULE__, opts, name: __MODULE__)
    end

  end