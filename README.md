# Ads Microservice

Микросервис Ads для курса Ruby Microservices.

# Зависимости

- Ruby `2.6.6`
- Bundler `2.1.4`
- Sinatra `2.0.0`
- Sequel `5.32.0`
- Puma `4.3+`
- PostgreSQL `9.3+`

# Установка и запуск приложения

1. Склонируйте репозиторий:

```
git clone git@github.com:savchenkoDev/ads.git && cd ads
```

2. Установите зависимости и создайте базу данных:

```
bundle install

createdb -h localhost -U postgres ads_dev
bin/rake db:migrate

createdb -h localhost -U postgres ads_test
RACK_ENV=test bin/rake db:migrate
```

3. Запустите приложение:

```
bin/puma
```

# Запуск консоли приложения

```
bin/console
```

# Запуск тестов

```
bin/rspec
```


```
docker run --rm --name rabbitmq -p 5672:5672 -p 15672:15672 --hostname node1 -v rabbitmq:/var/lib/rabbitmq rabbitmq:3-management
```