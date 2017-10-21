defmodule KVstore.StorageTest do
  use ExUnit.Case

  setup do
    test_record = %StorageRecord{key: "test", value: 1111, ttl: 1}
    test_params = %{test_record| sys_time: :os.system_time(:seconds), message_error: {:error, "Not found"}, exist_error: {:error, "Already exist"}} 
  end

  test("create record", test_params)  do
    assert KVstore.Storage.create(test_params.to_tuple) == {:ok, {test_params[:key], test_params[:val], test_params[:sys_time] + test_params[:ttl]}}
  end
  
  test("create exist record", test_params)  do
    KVstore.Storage.create(test_params.to_tuple)
    assert KVstore.Storage.create(test_params.to_tuple) == test_params[:exist_error]
  end
  
  test("read record", test_params)  do
    KVstore.Storage.create(test_params.to_tuple)
    assert KVstore.Storage.read({test_params[:key]}) == {:ok, {test_params[:key], test_params[:val], test_params[:sys_time] + test_params[:ttl]}}
  end
  
  test("read not exist record", test_params)  do
    assert KVstore.Storage.read({test_params[:key]}) == test_params[:message_error]
  end
  
  test("update record", test_params)  do
    assert KVstore.Storage.update({test_params[:key], test_params[:val] + 1, test_params[:ttl]}) == {:ok, { test_params[:key],  test_params[:val] + 1, test_params[:sys_time] + test_params[:ttl]}}
  end
  
  test("delete record", test_params)  do
    KVstore.Storage.create(test_params.to_tuple)
    assert KVstore.Storage.delete({test_params[:key]}) == {:ok, {test_params[:key]}}
  end
  
  test("delete not exist record", test_params)  do
    assert KVstore.Storage.delete({test_params[:key]}) == {:ok, {test_params[:key]}}
  end

  test("read timeout record",  test_params)  do
    KVstore.Storage.create(test_params.to_tuple)
    :timer.sleep(1000)
    assert KVstore.Storage.read({test_params[:key]}) == test_params[:message_error]
  end

end