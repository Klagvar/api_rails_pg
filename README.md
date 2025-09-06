# API Rails PG
- Требования: Ruby 3.3+, Rails 8, PostgreSQL
- Запуск: bin/rails db:setup && bin/rails s
- Дэшборд: http://localhost:3000
- Основные эндпоинты:
  - /v1/companies (GET/POST/PUT, PUT /v1/companies/:id/mark_deleted)
  - /v1/jobs (GET с фильтрами name/place, POST/PUT/DELETE, nested /v1/companies/:id/jobs)
  - /v1/geeks (GET с фильтрами name/stack, POST/PUT)
  - /v1/applies (GET с фильтрами read/invited/job_id/geek_id/company_id, POST/PUT/DELETE)
- Ошибки: 404 JSON, FK violation → 409 JSON

## Postman
- Установить Postman → создать Environment `api_rails_pg` с переменной `baseUrl = http://localhost:3000` и выбрать его справа сверху.
- Импортировать `api_rails_pg.postman_collection.json` (в корне репозитория).
- В коллекции есть все запросы из лабы (CRUD/фильтры/soft delete). Для примеров используются валидные id из сидов.
- Альтернатива: страница-дэшборд `http://localhost:3000/` с кнопками ко всем эндпоинтам.