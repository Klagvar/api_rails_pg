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

## Подробности по лабе

### Описание предметной области
- Разрабатывается REST API (Rails 8, режим API-only) для рекрутинга: компании публикуют вакансии, соискатели откликаются, компания отмечает прочтение и приглашение. Ответы в JSON.
- База данных — PostgreSQL. Для демонстрации используется коллекция Postman с преднастроенной последовательностью запросов.

### Таблицы (модели) и назначение
- `companies` — компании-работодатели (публикуют вакансии, управляют статусами откликов)
  - Поля: `name`, `location`, `deleted:boolean` (soft delete)
- `jobs` — вакансии компаний
  - Поля: `name`, `place`, `company_id` (FK), `deleted:boolean` (soft delete)
- `geeks` — соискатели (разработчики)
  - Поля: `name`, `stack` (технологический стек), `resume` (текст/URL резюме)
- `applies` — отклики соискателей на вакансии
  - Поля: `job_id` (FK), `geek_id` (FK), `read:boolean`, `invited:boolean`

Ассоциации:
- Company `has_many :jobs`
- Job `belongs_to :company`, `has_many :applies`
- Geek `has_many :applies`
- Apply `belongs_to :job`, `belongs_to :geek`

### Файлы и что в них сделано по лабе
- `config/routes.rb` — пространство имён API `v1`, ресурсы `companies`, `jobs` (в т.ч. nested под company), `geeks`, `applies`; маршрут `PUT /v1/companies/:id/mark_deleted`; catch-all для 404.
- `app/controllers/application_controller.rb` — обработчики ошибок: корректный HTTP 404 для `RecordNotFound` и `RoutingError`, HTTP 409 для `InvalidForeignKey`.
- `app/controllers/api/v1/companies_controller.rb` — CRUD, фильтры по `name/location`, soft delete методом `mark_deleted`.
- `app/controllers/api/v1/jobs_controller.rb` — CRUD, фильтры по `name/place`, выборки по компании; soft delete (`DELETE /v1/jobs/:id` помечает `deleted=true` и возвращает JSON-подтверждение).
- `app/controllers/api/v1/geeks_controller.rb` — CRUD, фильтры по `name/stack`.
- `app/controllers/api/v1/applies_controller.rb` — CRUD, фильтры по `read/invited/geek_id/job_id/company_id`; `DELETE` возвращает JSON-подтверждение удалённой записи.
- `app/models/company.rb` — валидации, метод `delete_company` для soft delete.
- `app/models/job.rb` — валидации, метод `delete_job` для soft delete; ассоциации с `company` и `applies`.
- `app/models/geek.rb`, `app/models/apply.rb` — валидации и ассоциации.
- `app/serializers/*_serializer.rb` — список атрибутов в JSON-ответах моделей.
- `db/seeds.rb` — наполнение данными для всех моделей; очистка и сброс последовательностей id.
- Миграции:
  - `db/migrate/*_add_deleted_to_jobs.rb` — поле `deleted:boolean` (default:false, not null) в `jobs`.
  - `db/migrate/*_set_default_and_not_null_for_companies_deleted.rb` — выравнивание `companies.deleted` (default:false, not null) + бэкфилл NULL→false.
- `api_rails_pg.postman_collection.json` — коллекция Postman с последовательностью запросов для защиты (см. ниже).

### Запросы и назначение (по группам)

Companies
- GET `/v1/companies` — список компаний (+ фильтры `name`, `location`)
- POST `/v1/companies` — создать компанию
- GET `/v1/companies/:id` — получить компанию
- PUT `/v1/companies/:id` — обновить компанию
- PUT `/v1/companies/:id/mark_deleted` — soft delete (пометить удалённой)
- DELETE `/v1/companies/:id` — удалить (жёстко), при наличных зависимостях возможен 409

Jobs
- GET `/v1/jobs` — список вакансий (+ фильтры `name`, `place`; скрывает `deleted=true`)
- GET `/v1/companies/:company_id/jobs` — вакансии компании (скрывает `deleted=true`)
- GET `/v1/jobs/:id` — получить вакансию
- POST `/v1/jobs` — создать вакансию
- PUT `/v1/jobs/:id` — обновить вакансию
- DELETE `/v1/jobs/:id` — soft delete (пометить `deleted=true`, JSON-подтверждение)

Geeks
- GET `/v1/geeks` — список соискателей (+ фильтры `name`, `stack`)
- GET `/v1/geeks/:id` — получить соискателя
- POST `/v1/geeks` — создать соискателя
- PUT `/v1/geeks/:id` — обновить соискателя (например, `resume`)
- DELETE `/v1/geeks/:id` — удалить соискателя

Applies
- GET `/v1/applies` — список откликов (+ фильтры: `read`, `invited`, `geek_id`, `job_id`, `company_id`)
- GET `/v1/applies/:id` — получить отклик
- POST `/v1/applies` — создать отклик (связка `job_id` + `geek_id`)
- PUT `/v1/applies/:id` — обновить поля `read`/`invited`
- DELETE `/v1/applies/:id` — удалить отклик (JSON-подтверждение)

### Сброс базы под сиды
Для повторяемости демонстрации (id как в коллекции Postman):
```
cd api_rails_pg
bin/rails db:drop
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```