# Kvstore
Тестовое задание для разработчика Elixir

Tender.pro, 2017

На языке Elixir написать key-value хранилище с удалением данных по таймауту (TTL) и управлением (CRUD) через web. TTL задается при добавлении пары key-value в хранилище. Необходимо обезопасить приложение от потери данных между перезапусками.
Выполнив задание, отправьте нам ссылку на репозиторий с решением. При решении задачи не допускается создание форков с исходного репозитория

## Описание
В данном репозитории подготовелен каркас для тестового задания. Все зависимости, необходимые для решения задачи, в конфиг уже добавлены, изменение списка зависимостей не рекомендуется.
В директории lib есть набор пустых файлов, которые соискатель должен заполнить своим кодом. Если соискатель добавит дополнительные файлы в эту директорию, то потребуется аргументация этой необходимости. Не забываем про тесты.

## Запуск
Запуск осуществляется стандартно: iex -S mix

## Как взаимодействовать
Точка входа в "/" 

Поддердивает 4 типа запросов:

- post: с параметрами key(ключ для хранения), val(значение), ttl(время хранения(только число))

- get: с параметром key(ключ для поиска)

- put: с параметрами key(ключ для хранения), val(значение), ttl(время хранения(только число))

- delete: с параметром key(ключ для поиска)


License
-------

This project is under the **MIT** License. See the [LICENSE](LICENSE) file for the full license text.

Copyright (c) 2017 [Tender.Pro](http://www.tender.pro)