# Saborê — Aplicativo de Receitas

Aplicativo mobile desenvolvido em **Flutter** que permite descobrir receitas, pesquisar por nome, consultar ingredientes e modo de preparo e montar uma lista de favoritos durante a sessão. Os dados são obtidos da API pública [DummyJSON Recipes](https://dummyjson.com/docs/recipes).

Projeto final da disciplina de Introdução ao Desenvolvimento Mobile — <seu nome>.

## Funcionalidades

| Requisito | Implementação |
| :--- | :--- |
| RF01 — Tela principal | Identidade visual, campo de pesquisa e listagem carregada automaticamente na abertura. |
| RF02 — Listagem | Cartões com nome, imagem, tempo total, nota e culinária. Imagem com indicador de carregamento e ícone alternativo em caso de falha. |
| RF03 — Pesquisa | Busca remota em `/recipes/search?q=`. Remove espaços externos, recusa consulta vazia e oferece botões "Limpar" e "Ver todas". |
| RF04 — Detalhes | Imagem, tipo de refeição, preparo, cozimento, porções, nota, ingredientes e passos numerados com rolagem. |
| RF05 — Favoritos | Adicionar/remover pelo coração (listagem ou detalhes), sem duplicatas (controle por `id`), com tela própria e contador no topo. |
| RF06 — Carregamento | Indicador durante as requisições, botão de busca desabilitado e descarte de respostas antigas. |
| RF07 — Erros | Mensagens específicas para falta de conexão, tempo esgotado, status HTTP de erro e JSON inválido, com botão "Tentar novamente". |
| RF08 — Ausência de resultados | Mensagens distintas para busca sem resultados, erro de rede e favoritos vazios. |
| RF09 — Navegação | Rotas nomeadas; a tela inicial permanece na pilha e conserva pesquisa e rolagem ao voltar dos detalhes. |

## Decisões técnicas

- **Detalhes:** a resposta da listagem e da pesquisa já contém ingredientes, instruções e metadados, por isso a tela de detalhes reaproveita o objeto `Recipe` recebido, sem nova chamada a `/recipes/{id}`.
- **Consultas concorrentes:** cada requisição recebe um identificador (`_requestId`); apenas a resposta mais recente atualiza a tela. O botão de busca fica desabilitado enquanto há carregamento.
- **Carregamento inicial:** disparado uma única vez em `initState`, nunca no `build`.
- **Favoritos:** mantidos em memória em um `AppState` (`ChangeNotifier`), disponibilizado a todas as telas por um `InheritedNotifier` (`AppStateScope`) — fonte única de verdade.
- **Conversão do JSON:** o modelo confere o tipo de cada campo. Tempos e porções ausentes ficam `null` e são exibidos como "—" (nunca como zero); `rating` é lido como `num` e convertido para `double`; `mealType` é sempre tratado como lista.

## Estrutura do projeto

```text
lib/
├── main.dart                  # Ponto de entrada, tema e AppStateScope
├── routes.dart                # Rotas nomeadas e navegação
├── models/
│   └── recipe_model.dart      # Modelo Recipe e conversão segura do JSON
├── services/
│   └── api_service.dart       # Requisições GET e tratamento de erros
├── state/
│   └── app_state.dart         # Favoritos da sessão
├── screens/
│   ├── home_screen.dart       # Listagem, pesquisa e estados de carregamento/erro/vazio
│   ├── detail_screen.dart     # Detalhes da receita
│   └── favorites_screen.dart  # Favoritos
└── widgets/
    ├── recipe_card.dart       # Cartão de receita
    ├── recipe_image.dart      # Imagem com fallback
    └── status_message.dart    # Mensagens de vazio e erro
test/
└── widget_test.dart           # Testes do modelo Recipe
```

## Dependências

| Pacote | Versão | Uso |
| :--- | :--- | :--- |
| `flutter` (SDK) | — | Interface |
| `http` | ^1.2.2 | Requisições à API |

## Ambiente utilizado

- Flutter SDK: `<versão>` (canal stable)
- Dart SDK: `<versão>`
- IDE: Android Studio `<versão>`
- Testado em: `<emulador / aparelho e versão do Android>`

## Como executar

1. Instale o [Flutter SDK](https://docs.flutter.dev/get-started/install) e configure um emulador Android ou aparelho físico.
2. Clone o repositório:
   ```bash
   git clone https://github.com/<seu-usuario>/sabore_app.git
   cd sabore_app
   ```
3. Instale as dependências:
   ```bash
   flutter pub get
   ```
4. Execute o aplicativo:
   ```bash
   flutter run
   ```
5. (Opcional) Rode os testes:
   ```bash
   flutter test
   ```

É necessária conexão com a internet para carregar as receitas.

## Vídeo de demonstração

<link do vídeo>