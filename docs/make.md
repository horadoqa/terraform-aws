# Como usar o Makefile

O **Makefile** é uma ferramenta que automatiza tarefas repetitivas e complexas de forma simples e eficiente. Ao usá-lo, você garante que todas as etapas do processo, como instalação de dependências, execução de scripts ou deploy, sejam feitas de maneira consistente e padronizada, reduzindo erros e economizando tempo.

## Importância de usar o Makefile

O Makefile proporciona diversas vantagens, como:

- **Automação**: Centraliza e automatiza as tarefas comuns de desenvolvimento e deploy.
- **Consistência**: Garante que as tarefas sejam executadas de maneira uniforme em diferentes ambientes e por diferentes membros da equipe.
- **Facilidade de uso**: Evita que o time precise lembrar ou digitar longos comandos repetidamente, bastando usar o `make` com a tarefa desejada.
- **Manutenção**: Facilita a manutenção e atualização do fluxo de trabalho, pois todas as etapas estão definidas e documentadas dentro do Makefile.

## Deploy para Amazon Linux

Para realizar o deploy para uma instância **Amazon Linux**, basta executar o comando:

```bash
make menu

Escolha uma opção:
1. Criar infraestrutura (Deploy)
2. Destruir infraestrutura
3. Sair
```

Este comando irá:

- Executar as tarefas definidas no Makefile para provisionar ou atualizar a aplicação na instância Amazon Linux.
- Garantir que todas as dependências necessárias sejam instaladas.
- Automatizar o processo de deploy, evitando a necessidade de rodar comandos manualmente.

**Nota**: Certifique-se de que todas as variáveis de ambiente e pré-requisitos estejam configurados corretamente antes de executar o comando.

