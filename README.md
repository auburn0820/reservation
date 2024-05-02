# Reservation

시험 및 예약 시스템

## 설명

- DB의 `Primary Key`를 API에 노출하는 것은, 추후 다른 데이터베이스 시스템으로의 마이그레이션을 할 때 까다로운 부분으로 다가올 수 있습니다(Auto-Increment PK를 지원하지 않는 DB로 마이그레이션 한다고 했을 때 등). 그래서 각 엔티티에 `UUID`로 엔티티 ID를 분리했습니다.
- DB에서 레코드를 삭제하는 것은, 추후 운영 상의 대응 등이 어려운 부분이 있기 때문에 레코드의 상태 값 컬럼을 추가하여 삭제 등의 여부를 나타냈습니다.
- 인증은 JWT 토큰을 사용하였고, 만료 시간은 24시간입니다.

## 시작하기

## 사전 요구사항

이 프로젝트를 실행하기 위해 다음과 같은 요구사항이 필요합니다.

- Docker
- Docker Compose

컨테이너가 아닌 환경에서 실행할 경우 아래 사항이 추가적으로 필요합니다.

- Ruby 3.3.0
- Rails 7.1.3
- PostgreSQL
- SQLite (테스트 코드 실행을 위해 필요)
- `Gemfile.lock`은 Container 실행을 위해 레포지토리에 업로드하였으나, 로컬에서 실행할 경우엔 삭제를 한 후 실행을 해주시기 바랍니다.

## 설치하기

**도커 컨테이너로 실행하기**

1. 레포지토리를 복제합니다.

```bash
git clone https://github.com/auburn0820/reservation.git
```

1. 프로젝트 디렉터리로 이동합니다.

```bash
cd reservation
```

1. Docker Compose를 사용하여 서비스를 시작합니다.

```bash
docker-compose up
```

이제 애플리케이션은 `http://localhost:3000`에서 실행됩니다.

해당 컨테이너를 실행하는 과정에서 테스트 코드를 실행합니다.

**로컬에서 실행하기**

1. 레포지토리를 복제합니다.

```bash
git clone https://github.com/auburn0820/reservation.git
```

1. 프로젝트 디렉터리로 이동합니다.

```bash
cd reservation
```

1. 젬을 설치합니다.

```bash
bundle install
```

1. Postgres를 실행하기 위해 docker-compose를 실행합니다.

```bash
docker-compose -f docker-compose.local.yaml up
```

1. 데이터베이스 마이그레이션을 진행합니다.

```bash
rails db:migrate
```

1. 데이터 초기 값을 세팅합니다. (선택)

```bash
bundle exec rake db:seed
```

1. Rails를 실행합니다.

```bash
rails server -b '0.0.0.0' -p 3000
```

## 데이터베이스

이 프로젝트는 로컬 환경에서 PostgreSQL을 기본 데이터베이스로 사용하며, 프로덕션 환경에서도 PostgreSQL을 사용합니다. 테스트 환경에서는 SQLite3를 사용합니다.

## 테스트 실행하기

```bash
bundle exec rspec
```

## 기타

- `master.key` 파일은 레포지토리에 절대 업로드하면 안 되나, 로컬 실행을 위해 업로드하였습니다.
- 테이블 스키마 세팅을 위해 `docker-compose up` 명령어를 실행하면 `rails db:migrate`를 통해 테이블을 생성합니다.
- 데이터 초기화를 위해 `docker-compose up` 명령어를 실행하면 `db/seeds.rb`를 실행하여 초기 데이터를 생성합니다.
- 테스트 코드는 빠른 실행을 위해 데이터베이스를 `SQLite3`로 실행합니다.

## 사전 세팅 데이터

### users

| id | user_id | email | password | Role | Created At | Updated At |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | e231295e-f9bf-4bcf-a87b-56335ca6018f | mailto:abcd@gmail.com | password! | admin | 생성일시 | 수정일시 |
| 2 | 3b3afa2f-08d0-4831-aef7-5d43a8ce028d | mailto:haaland@naver.com | password! | customer | 생성일시 | 수정일시 |

### exams

| id | exam_id | name | status | started_at | ended_at | created_at | updated_at |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 687d4e22-be23-4f2a-81da-fd4a053147c3 | 첫 번째 시험 | activated | 2024년 5월 8일 20:30:00.689063 | 2024년 5월 8일 21:30:00.689268 | 생성일시 | 수정일시 |
| 2 | 50ab44c3-d68a-4d2e-880a-5dd47c08865d | 두 번째 시험 | activated | 2024년 5월 2일 20:30:00.705027 | 2024년 5월 2일 21:30:00.705070 | 생성일시 | 수정일시 |
| 3 | fdbeb9d1-f12f-4ed1-84bb-e4a21d776e2a | 이미 끝난 시험 | activated | 2024년 4월 26일 20:30:00.708986 | 2024년 4월 26일 21:30:00.710132 | 생성일시 | 수정일시 |