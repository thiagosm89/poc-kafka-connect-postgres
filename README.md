# OBJETIVO

Este projeto fornecerá uma estrutura de teste para o Kafka Connect através de um docker local. <br/><br/>
Sempre que um linha for ```INSERIDA``` ou ```ALTERADA``` no banco de dados, na tabela ```usuario```, 
o kafka connect emitirá um evento para o tópico```teste-kafka-connect```.<br/> 
Para mais informações de como o connector do kafka
foi configurado, você pode abrir o arquivo JSON ```./curl/create_connector.json```. 

## INSTRUÇÕES PARA INICIAR
1. Clonar o projeto e entrar pelo terminal no diretório raiz, pois todos os comandos como o 
```docker-compose```, assim como o comando ```curl``` utilizado para deletar ou criar um 
conector no kafka connect, levarão em consideração o diretório raiz para encontrar os arquivos
necessários para seu funcionamento. 

2. Executar o ```docker-compose up -d```.<br/>
Conferir com ```docker ps``` para verificar se <strong>todas as máquinas estão UP</strong>, 
se alguma não estiver UP, executar novamente o comando do docker compose até todas ficarem UP.<br/>
O arquivo ```docker-composer.yml``` está comentado explicando cada um dos services.

3. Acessar o PGAdmin, banco ```postgres``` e confirmar se a tabela ```public.usuario``` foi criada com sucesso.<br/>
[Senhas do banco](#acessos-banco-de-dados)<br/>
[Acessar PGAdmin](#acessar-pgadmin)

4. Acessar o Control Center ```http://localhost:9021/```, e conferir se o tópico ```teste-kafka-connect```
está presente no ```Cluster 1```

5. Monitorar o tópico do kafka através do Apache Kafka. 
[Monitorar tópico](#plugar-um-consumidor-apache-kafka)

6. <strong style="color:red">Após estar monitorando os eventos</strong> que estão chegando no tópico, por fim iremos criar o conector
no kafka para começar a emissão de eventos. <br/> 
[Criar connector do kafka connect](#criar-conector-jdbc)<br/>
[Deletar um conector já existente](#deletar-um-conector-jdbc)<br/>
Assim que criado, os eventos já começarão a ser emitidos para o tópico e sempre que houver 
uma ```INSERÇÃO``` OU ```ALTERAÇÃO``` na tabela, um novo evento será emitido. <br/>
 
## ACESSAR PGAdmin
Host: https://localhost:16543 <br/>
Usuário: ```postgres@postgres```<br/>
Senha: ```admin```<br/>

## ACESSOS BANCO DE DADOS
Usuário: ```postgres```<br/>
Senha: ```admin```<br/>
Database: ```postgres```

## SCRIPT DO BANCO DE DADOS
#### EXECUÇÃO NA CRIAÇÃO DO CONTAINER
Os arquivos ```./sqls/create_table.sql``` e ```./sqls/insert.sql``` foram criados para executar no 
```entrypoint``` do serviço ```postgres``` declarado no ```docker-composer.yml```.<br/>
Ambos foram feitos para criar a tabela no banco e já inserir alguns dados inicialmente. Assim, é possível 
verificar o comportamento do connector do kafka quando plugado a um banco já populado.<br/>
Como resultado esperado, é que o tópico receba um evento para cada linha já existente inicialmente.

#### EXECUÇÃO MANUAL
Fornecemos um script para que você possa inserir alguns itens no banco de dados manualmente 
para realizar seus testes. <br/>
Para isso, acesse o arquivo ```./sqls/manual_inserts_to_test.sql```, copie o código no PGAdmin e execute.
O arquivo possui instruções de uso nos comentários, favor leia-os. 

## CRIAR CONECTOR JDBC

O conector que está nomeado como ```copiar_tabela```, 
está declarado dentro do arquivo ```./curl/create_connector.json```.<br/>

#### Propriedades do conector
> ```poll.interval.ms```: determina o tempo em millisegundos que o connector 
irá executar uma query no banco para fazer fetch de mais linhas. <br/>

> ```mode```: determina o modo para atualizar a tabela. <br/> 
Mais informações no link: https://docs.confluent.io/kafka-connect-jdbc/current/source-connector/source_config_options.html

#### Comando para criar o conector:

```
curl -X POST -H "Content-Type: application/json" -d @./curl/create_connector.json http://localhost:8083/connectors
```

## DELETAR UM CONECTOR JDBC

```
curl -X DELETE http://localhost:8083/connectors/copiar_tabela
```

## MONITORAR TÓPICO KAFKA

#### Gerenciar e criar tópicos
Para criar um tópico novo estará disponível o serviço ```control-center```, que pode ser acessado:
http://localhost:9021   <br/>
Você terá um centro de controle do kafka.<br/>
Ao iniciar o serviço do kafka, o tópico configurado nessa POC ```teste-kafka-connect```, já deverá 
estar criado com ```12 partições``` e isso pode ser confirmado usando o Control Center.

#### Plugar um consumidor Apache Kafka
Com o apache kafka, você poderá ficar escutando um tópíco em realtime e monitorar todos os eventos que 
estão chegando naquele tópico.<br/>
Após configurado o apache kafka, [CLIQUE AQUI PARA CONFIGURAR](https://kafka.apache.org/quickstart), você
pode executar o seguinte comando para monitorar o tópico que configuramos no arquivo 
```./curl/create_connector.json```, na propriedade ```topic.prefix```:
 
```
/path_to_apache_kafka/bin/kafka-console-consumer.sh --topic teste-kafka-connect --bootstrap-server localhost:9092
```

## LINKS UTILIZADOS PARA CONSTRUÇÃO DA POC

> O que é e como trabalha o Kafka Connect: <br/> 
https://docs.confluent.io/platform/current/connect/index.html?utm_medium=sem&utm_source=google&utm_campaign=ch.sem_br.nonbrand_tp.prs_tgt.kafka-connectors_mt.mbm_rgn.latam_lng.eng_dv.all_con.kafka-connect&utm_term=%2Bkafka%20%2Bconnect&creative=&device=c&placement=&gclid=CjwKCAjw3pWDBhB3EiwAV1c5rCLHIhtSx6vj4R2rWN_djnfo2Ai48RKjzy_lIB5ejGWDCoOPp3j56hoCxOgQAvD_BwE

> Neste link, possui informações de como integrar o kafka connect com algum driver JDBC: <br/>
https://docs.confluent.io/kafka-connect-jdbc/current/index.html

> Neste link temos o passo a passo para criar o connector JDBC, assim como a chamada a curl: <br/>
https://docs.confluent.io/kafka-connect-jdbc/current/source-connector/index.html

> Docker compose que me ajudou a construir o desse projeto, pois possui um exemplo com o Kafka Connect
como um container: <br/> 
https://github.com/confluentinc/demo-scene/blob/master/connect-jdbc/docker-compose.yml

> Este link possui algumas configurações do connector do kafka connect: <br/> 
https://docs.confluent.io/kafka-connect-jdbc/current/source-connector/source_config_options.html#jdbc-source-configs

> Link que me ajudou a encontrar a propriedade que faz a conversão da linha em JSON para o tópico:<br/>
https://gist.github.com/rmoff/f32543f78d821b25502f6db49eee9259

> https://docs.confluent.io/kafka-connect-jdbc/current/source-connector/index.html#pre-execution-sql-logging