help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  build		- Build the application"
	@echo "  clean		- Clean the application"
	@echo "  env		- Load environment variables"
	@echo "  run		- Run the application"
	@echo "  restart	- Restart the application in prod"
	@echo "  test		- Run tests"
	@echo "  coverage	- Generate coverage report"
	@echo "  logs		- Display logs"
	@echo "  help		- Display this help message"
	@echo ""
	@echo "For more information, RTFM!"

build:
	docker-compose up -d --build --force-recreate --remove-orphans

clean:
	docker-compose down --remove-orphans

env:
	cp .env.example .env

run:
	docker-compose up -d

restart:
	docker-compose restart

test:
	docker-compose exec app go test -v ./...

coverage:
	docker-compose exec app go test -coverprofile=coverage.out ./...
	docker-compose exec app go tool cover -html=coverage.out

logs:
	docker-compose logs -f