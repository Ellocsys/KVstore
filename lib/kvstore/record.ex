
defmodule StorageRecord do

    defstruct key: nil, value: nil, ttl: 0

    @type t(key, value, ttl) :: %StorageRecord{key: key, value: value, ttl: ttl}

    @type t :: %StorageRecord{key: any, value: any, ttl: integer}


    @doc """
    Конвертирует в кортедж вида {key, val, ttl}

    ## Параметры
        - record: StorageRecord для конвертирования 
    """
    @spec to_tuple(StorageRecord.t) :: tuple
    def to_tuple(record) do
        {record.key, record.value, record.ttl}
    end
    
    @doc """
    Конвертирует в кортедж вида {key, val, ttl}

    ## Параметры
        - record: StorageRecord для конвертирования 
        - current_time: системное время от которого вести расчет ttl 
    """
    @spec to_tuple_with_realtime(StorageRecord.t, integer) :: tuple
    def to_tuple_with_realtime(record, current_time \\ :os.system_time(:seconds)) do
        {record.key, record.value, current_time + record.ttl}
    end
end