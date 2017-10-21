defmodule KVstore.StorageTest do
  use ExUnit.Case

  setup do
    test_record = %StorageRecord{key: "test", value: 1111, ttl: 1}
    test_params = %{record: test_record, sys_time: :os.system_time(:seconds), message_error: {:error, "Not found"}, exist_error: {:error, "Already exist"}}
  end

  test("create record", test_params)  do
    assert KVstore.Storage.create(test_params.record) == {:ok, StorageRecord.to_tuple_with_realtime(test_params.record, test_params.sys_time) }
    KVstore.Storage.delete(test_params.record.key)
  end
  
  test("create exist record", test_params)  do
    KVstore.Storage.create(test_params.record)
    assert KVstore.Storage.create(test_params.record) == test_params.exist_error
    KVstore.Storage.delete(test_params.record.key)
  end
  
  test("read record", test_params)  do
    KVstore.Storage.create(test_params.record)
    assert KVstore.Storage.read(test_params.record.key) == {:ok, StorageRecord.to_tuple_with_realtime(test_params.record, test_params.sys_time)}
    KVstore.Storage.delete(test_params.record.key)
  end
  
  test("read not exist record", test_params)  do
    assert KVstore.Storage.read(test_params.record.key) == test_params.message_error
  end
  
  test("update record", test_params)  do
    new_record = %StorageRecord{key: test_params.record.key, value: test_params.record.value + 1, ttl: test_params.record.ttl}
    assert KVstore.Storage.update(new_record) == {:ok, StorageRecord.to_tuple_with_realtime(new_record ,test_params.sys_time)}
    KVstore.Storage.delete(test_params.record.key)
  end
  
  test("delete record", test_params)  do
    KVstore.Storage.create(test_params.record)
    assert KVstore.Storage.delete(test_params.record.key) == {:ok, {test_params.record.key}}
  end
  
  test("delete not exist record", test_params)  do
    assert KVstore.Storage.delete(test_params.record.key) == {:ok, {test_params.record.key}}
  end

  test("read timeout record",  test_params)  do
    KVstore.Storage.create(test_params.record)
    :timer.sleep(test_params.record.ttl * 1000)
    assert KVstore.Storage.read(test_params.record) == test_params.message_error
    KVstore.Storage.delete(test_params.record.key)
  end

end