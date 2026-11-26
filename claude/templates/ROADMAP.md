# <Projeto> — Roadmap

<Uma ou duas frases: o que é o produto e para quem.>

**Legenda**
- 🟢 = feito
- 🟡 = parcial (o que falta vem descrito no item)
- 🔴 = bloqueado (aguarda decisão, depende de algo externo ou tem um problema que impede seguir; o motivo vem no item)
- `[<Projeto A>]`, `[<Projeto B>]` = repositório da tarefa (quando houver mais de um)

As tarefas estão em ordem de execução: primeiro as pendências parciais (🟡), cada uma precedida do que ela exige, depois o resto na ordem das dependências. O que já está pronto fica em "Já feito", no final.

## Como usar este arquivo

Este arquivo é a fonte da verdade do projeto: o que existe, o que foi decidido e o que vem a seguir. Specs e notas são material de trabalho; quando uma tarefa fecha, o que continua valendo vem para cá.

**Fluxo de trabalho**
1. Antes de implementar, combinamos quais tarefas entram no lote e todas as decisões. A implementação só começa com o ok.
2. Se houver alterações pendentes, elas passam por code review e o que não for aproveitado é commitado antes.
3. O lote roda sem interrupção, uma tarefa por vez (cada uma num subagente, para manter o contexto pequeno):
   implementar → `verify` (lint, tipos, testes, quality gates) e conferência no app rodando quando possível → code review → correções → nota em `notes/<fatia>-slug.md` → commit em cada repositório afetado → marcar a tarefa aqui e movê-la para "Já feito".
4. Se uma tarefa precisar de decisão, ela é anotada, o lote segue com as independentes e as perguntas vêm juntas no fim.
5. Sem pausas periódicas: o escopo do lote é o ponto de controle.
6. Entre lotes, limpar o contexto (`/clear`): o que importa fica neste arquivo e nos commits.

**Specs, prompts e notas**
- Uma numeração só, a das tarefas deste arquivo. Nada de número sequencial próprio em specs ou notas.
- **Spec**: `specs/<tarefa>-slug.md` (ex.: `specs/12-checkout.md`). Tarefa grande é dividida em fatias `12a`, `12b`…, cada uma entregável e verificável sozinha.
- **Prompt da fatia** (quando a fatia roda num agente separado): `specs/<fatia>-prompt.md`.
- **Nota**: uma por fatia, com o id dela (`notes/12a-checkout-api.md`).
- Quando a tarefa fecha, decisões e pendências que continuam valendo vêm para este arquivo e a spec, os prompts e as notas podem ser apagados.

<details>
<summary>Modelo de spec</summary>

```md
# <n> — <Título>

Objetivo: <o resultado esperado, em uma frase>. Decisões de <data>.

## Princípios
- <regra que orienta as escolhas desta tarefa>

## <Área 1>
- <comportamento, regra, caso de borda>

## Fatias
- <n>a — <escopo>
- <n>b — <escopo>

## Fora desta tarefa
- <o que fica para depois e por quê>
```
</details>

<details>
<summary>Modelo de prompt da fatia</summary>

```md
Implemente a fatia **<n>a** (tarefa <n>), seguindo o fluxo de trabalho do `ROADMAP.md`
(implementar → verify → conferência → code review → correções → nota em `notes/<n>a-slug.md`
→ commit em cada repositório afetado → marcar no `ROADMAP.md`).

Leia antes: `specs/<n>-slug.md` (seções <...>), as tarefas relacionadas no `ROADMAP.md`
e o `CLAUDE.md`/`AGENTS.md` de cada repositório afetado.

## Escopo
1. **<Item>**: <o que fazer, com os arquivos e regras relevantes>.
2. ...

## Regras
- Siga os quality gates do projeto.
- <armadilhas do ambiente que valem para esta fatia>
- Se alguma decisão da spec não fechar com o código, anote, siga com o resto e traga a pergunta no fim.
```
</details>

<details>
<summary>Modelo de nota</summary>

```md
# <fatia> — <Título>

## O que foi feito
- <mudança, por repositório quando houver mais de um>

## Decisões
- <escolha feita durante a implementação e o porquê>

## Verificação
- <comandos que passaram, o que foi conferido no app, provas de que os gates barram o que devem>

## Commits
- <repositório> `<hash>`

## Não verificado
- <o que ficou sem prova e por quê>
```
</details>

## Conceitos

Glossário do domínio: cada entidade e o que ela significa neste produto.

- **<Entidade>**: <definição, regras de identidade, a que pertence>.

## Regras de negócio

Regras transversais, que valem para várias tarefas.

- <regra>

## Módulos e dependências

| Módulo | Depende de |
|---|---|
| <Módulo> | — |

## Convenções

- **<Repositório>**:
  - <estrutura de pastas, padrões de tela/API, referências de implementação>
  - <armadilhas do ambiente: comandos que derrubam o dev, migrações, serviços reais>
- **Git**: <regras de branch e commit do projeto>.

## Próximas — fazer antes de tudo

**Lote <n> (combinado em <data>): <tema>**, em fatias, cada uma com o fluxo completo:
1. <fatia> — <escopo>.
2. <fatia> — <escopo>.

## Fase 1 — <Nome>

### 1. [<Projeto>] <Título>
<Descrição: objetivo, regras, decisões, o que falta se for 🟡.>

## Já feito

### <n>. [<Projeto>] <Título> 🟢
<Resumo do que existe e das decisões que continuam valendo.>

## Backlog / a conversar

- <ideia ou pendência sem prioridade definida>
