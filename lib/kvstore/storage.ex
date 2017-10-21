defmodule KVstore.Storage do
    use GenServer
    @moduledoc """
    Модуль, который отвечает за хранение и предоставление данных в DETS
    """
   
    @doc """
    Обязательный параметр :file_name - название файла для хранения 
    """
    def init(opts) do
        file_name = Keyword.fetch!(opts, :file_name)
        {:ok, table_name} = :dets.open_file(file_name, [])
        refs  = %{}
        {:ok, {table_name, refs}}
    end
    
    def start_link(opts) do
        GenServer.start_link(__MODULE__, opts, name: __MODULE__)
    end

    ## Методы для работы с данными

    @doc """
    Сохранить значение

    ## Параметры

        - record: map типа StorageRecord

    """
    @spec create(StorageRecord.t) :: tuple
    def create(record) do
        GenServer.call(__MODULE__, {:create, record})
    end
    
    @doc """
    Найти значение

    ## Параметры

        - key: ключ для поиска 

    """
    def read(key) do
        GenServer.call(__MODULE__, {:read, key})
    end
    
    @doc """
    Обновить значение

    ## Параметры

        - record: map типа StorageRecord

    """
    def update(record) do
        GenServer.call(__MODULE__, {:update, record})
    end
    
    @doc """
    Удалить значение

    ## Параметры

        - key: ключ для поиска 

    """
    def delete(key) do
        GenServer.call(__MODULE__, {:delete, key})
    end
     
    @doc """
    Поиск по ключу

    ## Параметры
        - table: имя таблицы в которой искать 
        - key: ключ по которому искать знвчение 
    """
    def lookup(table, key) do
        case :dets.lookup(table, key) do
            [{name, value, ttl}] ->{:ok, {name, value, ttl}}
            [] -> :error
        end
    end   
    
    @doc """
    Проверяет, не протухли ли данные

    ## Параметры
        - table: имя таблицы в которой искать 
        - key: ключ по которому искать знвчение 
    """
    def check_ttl({table, name}) do
        case lookup(table, name) do
            {:ok, {key, val, ttl}} -> if ttl < :os.system_time(:seconds), do: :dets.delete(table, name) 
            :error -> :error
        end
    end

    ## Обработчики вызовов
    
    def handle_call({:create, record}, _from, {table, refs}) do
        check_ttl({table, record.key})
        case :dets.insert_new(table, StorageRecord.to_tuple_with_realtime(record)) do
            true -> {:reply, {:ok, StorageRecord.to_tuple_with_realtime(record)}, {table, refs}}
            false -> {:reply, {:error, "Already exist"}, {table, refs}}
        end
    end

    def handle_call({:read, key}, _from, {table, refs}) do
        check_ttl({table, key})
        case lookup(table, key) do
            {:ok, value} -> {:reply, {:ok, value}, {table, refs}}
            :error -> {:reply, {:error, "Not found"}, {table, refs}}
        end
    end

    def handle_call({:update, record}, _from, {table, refs}) do
        check_ttl({table, record.key})
        :dets.insert(table, StorageRecord.to_tuple_with_realtime(record))
        {:reply, {:ok, StorageRecord.to_tuple_with_realtime(record)}, {table, refs}}
    end

    def handle_call({:delete, name}, _from, {table, refs}) do
        case :dets.delete(table, name) do
            :ok -> {:reply, {:ok, {name}}, {table, refs}}
        end
    end

  end