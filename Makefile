setup:
	bundle install
	yarn install
	yarn build
	yarn build:css
	bin/rails db:migrate
	bin/rails db:seed

lint:
	rake lint:all

tests:
	rake test

env:
	cp .env.example .env