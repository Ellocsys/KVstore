defmodule KVstore.StorageTest do
  use ExUnit.Case

  # Создадим тестовую запись и добавим некоторую инфу(шаблоны сообщений об ошибках)
  setup do
    test_record = %StorageRecord{key: "test", value: 1111, ttl: 1}
    test_params = %{record: test_record, message_error: {:error, "Not found"}, exist_error: {:error, "Already exist"}}
  end

  # Так как запись в dets имеет последствия, после создания записей необходимо их удалять

  # Проверим создание
  test("create record", test_params)  do
    assert KVstore.Storage.create(test_params.record) == {:ok, StorageRecord.to_tuple_with_realtime(test_params.record) }
    KVstore.Storage.delete(test_params.record.key)
  end
  
  # Для создания новой записи рспользуется insert_new поэтому для повторяющейся записи долна быть ошибка
  test("create exist record", test_params)  do
    KVstore.Storage.create(test_params.record)
    assert KVstore.Storage.create(test_params.record) == test_params.exist_error
    KVstore.Storage.delete(test_params.record.key)
  end
  
  # Просто чтение
  test("read record", test_params)  do
    KVstore.Storage.create(test_params.record)
    assert KVstore.Storage.read(test_params.record.key) == {:ok, StorageRecord.to_tuple_with_realtime(test_params.record)}
    KVstore.Storage.delete(test_params.record.key)
  end
  
  # Чтение несуществующей записи
  test("read not exist record", test_params)  do
    assert KVstore.Storage.read(test_params.record.key) == test_params.message_error
  end
  
  # обновление записи
  test("update record", test_params)  do
    new_record = %StorageRecord{key: test_params.record.key, value: test_params.record.value + 1, ttl: test_params.record.ttl}
    assert KVstore.Storage.update(new_record) == {:ok, StorageRecord.to_tuple_with_realtime(new_record)}
    KVstore.Storage.delete(test_params.record.key)
  end
  
  # Удаление(по сути существет или нет запись - поведение одинаковое) 
  test("delete record", test_params)  do
    KVstore.Storage.create(test_params.record)
    assert KVstore.Storage.delete(test_params.record.key) == {:ok, {test_params.record.key}}
  end
  
  test("delete not exist record", test_params)  do
    assert KVstore.Storage.delete(test_params.record.key) == {:ok, {test_params.record.key}}
  end

  # Проверка работы ttl фильтрации
  test("read timeout record",  test_params)  do
    KVstore.Storage.create(test_params.record)
    :timer.sleep(test_params.record.ttl * 1000)
    assert KVstore.Storage.read(test_params.record) == test_params.message_error
    KVstore.Storage.delete(test_params.record.key)
  end

end