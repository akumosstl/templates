# Java / Backend: Interview ROADMAP


***Checar se o candidato:***

•	Explica a estrutura de um backend em Java (camadas, responsabilidades, controle transacional, boas práticas).
•	Sabe falar por que usa certos padrões (ex.: Service, Repository, DTO, Controller).
•	Consegue descrever uma API REST real que criou: endpoints, verbos, status codes, tratamento de erro, segurança.
•	Consegue justificar escolhas: por que usar Java + Spring naquele contexto (performance, ecossistema, segurança, suporte a microserviços etc.).

***Sugestão:***

**Orientação Objeto**
- Como funciona ou qual a utilidade de um polimorfismo?
- Abstração - Esconde os detalhes da implementação dentro de algo (instance of);
- Encapsulamento - Esconde as propriedades do objeto (Getter Setter)
- Herança - Possibilita que as classes compartilham seus atributos, métodos e outros membros da classe entre si;
- Polimorfismo - Duas ou mais classes derivadas de uma mesma superclasse podem invocar métodos que têm a mesma identificação mas comportamentos distintos;

**Java 8**
Sobre atualizações do Java 8, surgiram duas funcionalidades bastante utéis para o desenvolvimento você sabe me dizer quais são? Qual a funcionalidade ou como funciona um Stream?
- Lambda
- Stream
- filters
- Method Reference
- Optionals
- Map Reduce

**EJB**
- Falando sobre EJB, uma das características do EJB é o controle de ESTADO, sabe me dizer quais são esses estados? Qual a diferença entre Stateless e Statefull?
- Stateless - O Stateless também não mantém o estado entre as chamadas de método, ou seja, caso tenha algum atributo dentro do EJB este atributo é perdido toda vez que o EJB é chamado.
- Statefull - O stateful mantém o estado entre as chamadas enquanto a sessão estiver ativa, mantendo os valores das variáveis;

**Qual tipo de ejb é voltado para persistência de dados?**
 Entity bean

Outra característica do EJB é o controle de transação as chamadas Transações declarativas, você já ouviu falar? Sabe me dizer como funciona um Requires New?
Not Supported - O metódo é executado sem transações abertas pelo cliente, se alguma transação estiver aberta está será suspensa até o término do método;
Supports - O método é executado com ou sem transação aberta. Nenhuma transação será criada;
Never - Obriga a ausência de transações na chamada do método. Se alguma transação existir será disparada uma exceção;
Requires New - Se no cliente tiver uma transação aberta, está será suspensa e uma nova transação será criada;
Required - Utiliza a transação do cliente aberta, ou cria uma nova se não tiver


# Angular / Frontend: Interview ROADMAP

B. Angular (entendimento real, não só uso)
O técnico deve validar, com perguntas abertas:
•	Diferença entre componentes standalone x módulos e quando usar cada um.
•	Comunicação parent x child com @Input, @Output e EventEmitter, com um exemplo concreto.
•	Ciclo de vida: principais hooks (OnInit, OnDestroy, etc.) e um caso prático em que usou um hook para resolver um problema.
•	Implementação de rotas com guards (ex.: AuthGuard, CanActivate) e um cenário em produção.
•	Uso de Observables e RxJS: 
o	por que usar Observables em vez de Promises em determinados casos;
o	operadores como pipe, takeUntil etc.;
o	exemplo de chamadas encadeadas (nested).


Agora falando sobre Angular, já trabalhou ou já ouviu sobre REDUX ou NGRX?
Redux
Para que serv…
Validar se o candidato:
•	Define REST com clareza (recursos, verbos HTTP, stateless, idempotência básica).
•	Explica status codes comuns (200, 201, 400, 401, 403, 404, 500) com exemplos.
•	Mostra como versiona APIs e trata erros (ex.: padrão de resposta).

Sugestão:
Rest
- Com relação ao padrão REST qual a diferença de um PUT para um PATCH?
- Tem alguma técnica ou regra que você considera como boas práticas na criação de um serviço REST?
- O REST oferece suporte XML, JSON, texto simples e HTML.
- Boas Práticas 
- Use JSON como o formato para o envio e o recebimento de dados 
- Use substantivos ao invés de verbos nos endpoints 
- Nomeie coleções com substantivos no plural 
- Use códigos de erro no tratamento de erros 
- Use aninhamento nos endpoints para mostrar as relações 
- Use filtragem, ordenação e paginação para obter os dados solicitados 
- Use SSL para ter mais segurança ○ Seja claro com o controle de versão

***Diferença entre PATCH e PUT***

- PUT - Alteração completa do objeto;
- PATCH - Alteração parcial do objeto;