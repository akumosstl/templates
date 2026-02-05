📘 Guia de Estudo — Teorema CAP (Consistency, Availability, Partition Tolerance)
🎯 Objetivo

Compreender profundamente o Teorema CAP e como ele orienta decisões de arquitetura em sistemas distribuídos.

1. ⚙️ O que é o Teorema CAP?

O Teorema CAP, proposto por Eric Brewer, afirma que em um sistema distribuído você não pode garantir simultaneamente:

C – Consistency (Consistência)

A – Availability (Disponibilidade)

P – Partition Tolerance (Tolerância a Partição)

👉 É possível ter no máximo dois desses três, em presença de falhas de rede.

2. 🔍 Os Três Componentes do CAP
   2.1 🧩 Consistency — Consistência

Todos os nós retornam o mesmo dado no mesmo momento.

Após uma escrita, todas as réplicas têm o dado atualizado.

Usuário X e Y nunca veem valores divergentes.

Exemplos:

Sistemas bancários

Aplicações com forte integridade de dados

2.2 ⚡ Availability — Disponibilidade

Cada requisição recebe uma resposta válida, mesmo que alguns nós estejam fora.

O sistema sempre responde.

Pode retornar uma versão antiga, mas não falha.

Exemplos:

Redes sociais

Sistemas de baixa latência

2.3 🌐 Partition Tolerance — Tolerância a Partição

O sistema continua funcionando mesmo quando há falhas na comunicação entre nós.

Imprescindível em sistemas distribuídos reais

Partições de rede (latência alta, falhas) são inevitáveis

✔ Na prática, P é obrigatório em sistemas distribuídos modernos.
Então a escolha real costuma ser entre:

CP (Consistência + Tolerância a Partição)

AP (Disponibilidade + Tolerância a Partição)

3. 🛠 Quando o Sistema Escolhe CP ou AP?
   3.1 CP — Consistent + Partition Tolerant

Preferido onde consistência é mais importante que disponibilidade.

📌 O sistema pode não responder temporariamente, mas nunca retorna valores incorretos.

Exemplos:

MongoDB com write concern “majority”

HBase

Spanner (forte consistência)

Use quando:

Dados críticos (financeiro, estoque real-time)

Integridade é prioridade

3.2 AP — Available + Partition Tolerant

Preferido quando disponibilidade é mais importante que consistência imediata.

📌 O sistema sempre responde, mas pode mostrar dados antigos (eventual consistency).

Exemplos:

Cassandra

DynamoDB

CouchDB

Redis Cluster (dependendo da config)

Use quando:

Baixa latência é prioridade

Carga massiva de leitura

Redes sociais, métricas, logs

4. 📜 Exemplos práticos para entender CAP
   📌 Exemplo CP

Um banco de dados recusa gravações quando não há quorum
→ melhor falhar do que registrar dados inconsistentes.

📌 Exemplo AP

Um shopping online mostra estoque desatualizado por alguns segundos
→ melhor vender e corrigir depois do que perder vendas.

📌 Exemplo onde P é inevitável

Dois data centers perdem comunicação
→ o sistema deve escolher consistência ou disponibilidade.

5. 🔄 CAP Não é Absoluto — Teorema PACELC

O Teorema PACELC complementa o CAP:

Se houver Partição (P), escolha entre Consistência (C) e Disponibilidade (A).
Caso contrário (Else), escolha entre Latência (L) e Consistência (C).

Ou seja:

Com particionamento → CAP

Sem particionamento → latência vs consistência

PACELC é mais realista para sistemas distribuídos modernos.

6. 🧠 Resumo Visual
   +----------------+
   | Consistency |
   +----------------+
   / \
   /   \
   /     \
   AP / \ CP
   Availability / \ Partition Tolerance
   /           \
   +----------------+
   | Availability |
   +----------------+

7. 🧪 Exercícios para Praticar

Explique com suas próprias palavras a diferença entre AP e CP.

Dê exemplos reais de aplicações que exigem CP e AP.

Em um cenário de marketplace, qual modelo você escolheria? E por quê?

Liste 3 bancos que implementam AP e 3 que implementam CP.

Desenhe um diagrama mostrando um cenário de partição e o impacto no sistema.

8. 📚 Leituras Recomendadas

Designing Data-Intensive Applications – Martin Kleppmann

Papers: Amazon Dynamo; Bigtable; Spanner

Site: “Jepsen Tests” (Kyle Kingsbury)