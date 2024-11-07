# Comandos utilizados para construir o pacote da aplicação com Melange e construir a imagem de contêiner com APKO.

### GERAR CHAVE PARA OS BUILDS

Será gerado os arquivos melange.rsa e melange.rsa.pub no diretório atual

```bash
docker run --rm -v "${PWD}":/work cgr.dev/chainguard/melange keygen
```

### BUILD DO APK DEFINIDO NO MELANGE.YAML

Com o comando abaixo, será configurado um volume compartilhado da pasta atual com o local "/work" dentro do contêiner.
O pacote será construído para sistemas com a mesma arquitetura do host usado no momento, caso queira criar para uma arquitetura específica basta adicionar ao parâmetro "--arch".
O pacote será assinado usando a chave melange.rsa criada no comando anterior.

```bash
docker run --privileged --rm -v "$PWD":/work \
  cgr.dev/chainguard/melange build melange.yaml \
  --arch host --signing-key melange.rsa
```

### BUILD DA IMAGEM DE CONTÊINER

O comando a seguir configurará um volume compartilhando sua pasta atual com o local /work no contêiner, e irá fazer build da imagem com base no arquivo apko.yaml
Isso cria uma imagem OCI com base na arquitetura do seu sistema host (especificada pelo sinalizador `--arch host`). Se você receber avisos neste ponto, eles provavelmente estão relacionados aos tipos de SBOMs que estão sendo carregados e podem ser ignorados com segurança.

O comando irá gerar uma imagem OCI compactada (.tar) que pode ser importada com um `docker load` e um arquivo SBOM para sua arquitetura de host. 

```bash
docker run --rm --workdir /work -v ${PWD}:/work cgr.dev/chainguard/apko \
  build apko.yaml giropops-senhas:0.1 giropops-senhas.tar --arch host
```

### CARREGAR E DISPONIBILIZAR IMAGEM

Agora, basta carregar a imagem: `docker load < giropops-senhas.tar`

Feito isso, a imagem estará disponível para ser utilizada.

OBS: A arquitetura do seu sistema será adicionada à tag da imagem, para alterar: `docker tag giropops-senhas:01'-arch':<tag_atual> <novo_nome>:<nova_tag>`

### REDIS

Para que a aplicação funcione corretamente será necessária a execução do Redis.

Execute o Redis em container com o comando: `docker run -d --name <NOMEAR_CONTAINER> -p <6379>:<6379> cgr.dev/chainguard/redis:latest`

Execute o container da aplicação com: docker `run -d --name <NOMEAR_CONTAINER> -p <HOST>:<CONTAINER> -e REDIS_HOST=<HOST> linuxtips-giropops-senhas:0.1`
