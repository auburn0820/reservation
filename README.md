# reservation
시험 및 예약 시스템
## 시작하기
## 사전 요구사항
이 프로젝트를 실행하기 위해 다음과 같은 요구사항이 필요합니다.
- Docker
- Docker Compose
## 설치하기
1. 이 레포지토리를 복제합니다.
```shell
git clone https://github.com/your-username/your-project.git
```
2. 프로젝트 디렉터리로 이동합니다.
```shell
cd reservation
```
3. Docker Compose를 사용하여 서비스를 시작합니다.
```shell
docker-compose up
```
이제 애플리케이션은 `http://localhost:3000`에서 실행됩니다.
## 데이터베이스
이 프로젝트는 로컬 환경에서 PostgreSQL을 기본 데이터베이스로 사용하며, 프로덕션 환경에서도 PostgreSQL을 사용합니다. 테스트 환경에서는 SQLite3를 사용합니다.
## 테스트 실행하기
```shell
bundle exec rspec
```