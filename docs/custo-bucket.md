O custo de deixar um bucket S3 criado na AWS com o estado (`state`) armazenado nele depende de alguns fatores, como o número de requisições, o tamanho do arquivo de estado e a classe de armazenamento do S3 que você escolher. Vou explicar os principais componentes que afetam o custo:

### 1. **Armazenamento no S3**

- O custo de armazenamento no S3 é calculado com base no volume de dados armazenados. Para o seu caso, o arquivo `terraform.tfstate` geralmente tem um tamanho pequeno, mas vamos analisar os custos gerais.
- **Custo por GB/mês**:
  - A classe padrão do S3 é o **S3 Standard**, que custa cerca de **$0.023 por GB por mês** (dependendo da região).
  - Se o seu arquivo `terraform.tfstate` tiver cerca de 1 MB (0.001 GB), o custo de armazenamento seria bem baixo: **$0.023 * 0.001 = $0.000023 por mês**.
  - Se você tiver versões do `terraform.tfstate` armazenadas (no caso de versionamento ativado), o custo de armazenamento será mais alto, pois cada versão do arquivo será cobrada.

### 2. **Versionamento no S3**

- Quando o **versionamento** está ativado no bucket S3, cada nova versão do arquivo será armazenada separadamente. Isso significa que, dependendo da frequência de alterações no estado, o número de versões pode aumentar, impactando o custo.
- **Custo adicional**: Se o arquivo de estado mudar frequentemente, cada versão pode ter o mesmo custo de armazenamento de um novo arquivo.
- Se, por exemplo, você tiver **10 versões** do arquivo `terraform.tfstate` (incluindo a versão atual), o custo seria multiplicado por 10, mas ainda assim seria uma quantia baixa. 
- Considerando 10 versões de 1 MB cada, o custo total de armazenamento seria:  
  - **10 MB** (0.01 GB) * **$0.023/GB** = **$0.00023 por mês**.

### 3. **Requisições no S3**

As requisições ao bucket S3 também influenciam o custo, mas como você vai interagir com o bucket S3 principalmente durante as operações do Terraform (e essas interações são pequenas), o custo de requisições será mínimo. As tarifas são as seguintes:

- **PUT, COPY, POST, LIST**: aproximadamente **$0.005 por 1.000 requisições**.
- **GET e outras leituras**: aproximadamente **$0.0004 por 1.000 requisições**.

Portanto, mesmo que o Terraform faça requisições frequentes ao bucket S3 para armazenar ou ler o estado, o custo de requisições será muito baixo.

### 4. **Transferência de Dados**

- Se o seu arquivo de estado for acessado de fora da AWS (por exemplo, quando você usa o `terraform` de uma máquina local e se conecta ao S3), haverá custos de **transferência de dados**. 
- **Custo de transferência**:
  - Até **1 GB** de saída para a internet é **gratuito** por mês.
  - Depois de 1 GB, a tarifa varia dependendo da quantidade de dados transferidos, mas para pequenos arquivos como o `terraform.tfstate`, é improvável que você ultrapasse esse valor, a menos que haja uma grande quantidade de transferências.

### Estimativa de custo mensal (para 1 MB de estado):

- **Armazenamento (1 MB no S3 Standard)**: Aproximadamente **$0.000023** por mês.
- **Versionamento**: Se houver 10 versões (10 MB), o custo seria **$0.00023** por mês.
- **Requisições**: Se o Terraform interage com o bucket algumas vezes por mês, o custo seria muito baixo (menos de **$0.01 por mês**).

### Resumo do Custo Estimado:

- **Custo de Armazenamento** (1 MB, sem versionamento): **$0.000023 por mês**.
- **Custo de Armazenamento com Versionamento** (10 versões de 1 MB): **$0.00023 por mês**.
- **Custo de Requisições**: **$0.01 ou menos** por mês.
- **Custo de Transferência de Dados**: **Provavelmente grátis**, desde que não ultrapasse 1 GB de saída.

Em resumo, o custo de armazenar o arquivo `terraform.tfstate` em um bucket S3, mesmo com versionamento ativado, é **muito baixo**, provavelmente na faixa de **centavos por mês**, mesmo com múltiplas versões e requisições.

Se você tiver um número muito grande de versões ou acessos frequentes, o custo pode aumentar um pouco, mas para a maioria dos casos, o valor será bem acessível!

