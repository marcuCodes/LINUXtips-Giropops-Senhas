Para que a aplicação funcione corretamente será necessária a execução do Redis.

Execute o Redis em container com o comando: docker run -d --name <NOMEAR_CONTAINER> -p 6379:6379 redis

Execute o container da aplicação com: docker run -d --name <NOMEAR_CONTAINER> -e REDIS_HOST=<HOST> linuxtips-giropops-senhas:1.0
