
defmodule StorageRecord do

    defstruct key: nil, value: nil, ttl: 0

    @type t(key, value, ttl) :: %StorageRecord{key: key, value: value, ttl: ttl}

    @type t :: %StorageRecord{key: any, value: any, ttl: integer}

    @spec to_tuple(StorageRecord.t) :: tuple
    def to_tuple(record) do
        {record.key, record.value, record.ttl}
    end
end