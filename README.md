# MIPS_CPU

Projeto em Verilog de um processador MIPS com pipeline de 5 estágios.

## Integrantes

- Eduardo A. Carvalho - 2021017750
- Leonardo Monteiro Labegalini - 2021012769
- Lucas Luan B. Barbosa - 2021017872

## Descrição

Este projeto implementa um processador MIPS com pipeline de 5 estágios, incluindo suporte a multiplicador multiciclo e dois domínios de clock sincronizados por PLL. O objetivo é estudar arquitetura de processadores, riscos de pipeline e integração de módulos em hardware digital.

### Estágios do Pipeline

1. **Instruction Fetch**  
   Busca da instrução na memória de instruções.

2. **Instruction Decode**  
   Decodificação da instrução e leitura dos registradores.

3. **Execute**  
   Execução de operações aritméticas/lógicas e multiplicação.

4. **Memory**  
   Acesso à memória de dados.

5. **Write Back**  
   Escrita do resultado de volta ao banco de registradores.

### Principais Módulos

- [`cpu`](cpu.v): Topo do processador, integra todos os módulos.
- [`ALU`](ALU/alu.v): Unidade lógica e aritmética.
- [`Multiplicador`](Multiplicador/): Multiplicador multiciclo.
- [`Control`](Control/control.v): Unidade de controle.
- [`RegisterFile`](RegisterFile/): Banco de registradores.
- [`InstructionMemory`](InstructionMemory/): Memória de instruções.
- [`DataMemory`](DataMemory/): Memória de dados.
- [`MUX`](MUX/): Multiplexadores.
- [`PC`](PC/): Contador de programa.
- [`PLL`](PLL/): Geração e sincronização de clocks.
- [`ADDRDecoding`](ADDRDecoding/): Decodificação de endereços.

### Características

- Pipeline de 5 estágios.
- Multiplicador multiciclo com domínio de clock separado.
- Sincronização de clocks via PLL.
- Suporte a riscos de dados com inserção de bolhas.
- Frequências máximas analisadas para FPGA Cyclone IV GX EP4CGX150DF31C7.

### Frequências Máximas (Time Quest Timing Analyzer)

| Módulo         | Slow 85C | Slow 0C  | Fast 0C  |
|----------------|----------|----------|----------|
| Sistema        | 109.66MHz| 118.67MHz| 201.01MHz|
| Multiplicador  | 294.20MHz| 320.82MHz| 604.96MHz|

### Como simular

1. Abra o projeto no Quartus ou outro simulador compatível.
2. Utilize os testbenches disponíveis em cada pasta de módulo, por exemplo [`TB.v`](TB.v), [`ALU/alu_TB.v`](ALU/alu_TB.v), etc.
3. Compile e rode as simulações para verificar o funcionamento dos módulos.

### Observações

- A expressão `(A*B) – (C+D)` não é executada corretamente em sequência devido a dependências de dados e latência do pipeline. É necessário inserir bolhas para garantir a execução correta.
- Não há problemas de metaestabilidade, pois os domínios de clock são sincronizados pela PLL.
- Para maior desempenho, recomenda-se substituir o multiplicador multiciclo por um funcional ou operar o multiplicador em paralelo ao pipeline.

---

Para mais detalhes, consulte os comentários no arquivo [`cpu.v`](cpu.v).