# Importação de módulos essenciais
import sys  # Usado para calcular o uso de memória dos objetos com sys.getsizeof()
import time  # Utilizado para criar pausas entre os atendimentos automáticos com time.sleep()

# Classe que representa um paciente da fila médica
class Paciente:
    def __init__(self, nome, idade, prioridade):
        self.nome = nome  # Nome do paciente
        self.idade = idade  # Idade do paciente
        self.prioridade = prioridade  # Nível de prioridade: 1 = normal, 2 = prioritário
        self.anterior = None  # Referência para o paciente anterior (lista duplamente ligada)
        self.proximo = None  # Referência para o próximo paciente

    def __str__(self):
        # Retorna a representação do paciente, incluindo a prioridade (P = prioritário, N = normal)
        tipo = '(P)' if self.prioridade == 2 else '(N)'
        return f'[ {self.nome} {tipo} ]'

# Classe principal que representa a fila médica e suas funcionalidades
class FilaMedica:
    def __init__(self):
        self.inicio = None  # Início da fila (primeiro paciente)
        self.fim = None  # Fim da fila (último paciente)
        self.turno = 2  # Controla a alternância de atendimento entre prioridades

    # Calcula o uso total de memória da fila médica
    def calcular_memoria_total(self):
        total = sys.getsizeof(self)  # Memória da instância da fila
        atual = self.inicio
        while atual:
            total += sys.getsizeof(atual)  # Memória do nó/paciente
            total += sys.getsizeof(atual.nome)  # Memória da string nome
            total += sys.getsizeof(atual.idade)  # Memória do inteiro idade
            total += sys.getsizeof(atual.prioridade)  # Memória do inteiro prioridade
            atual = atual.proximo
        return total

    # Exibe o uso de memória antes e depois de uma operação
    def monitorar_memoria(self, antes, depois):
        print(f'Memória antes: {antes} bytes')
        print(f'Memória depois: {depois} bytes')
        print(f'Variação: {depois - antes} bytes')

    # Adiciona um novo paciente à fila com base em sua prioridade
    def adicionar_paciente(self, nome, idade, prioridade):
        paciente = Paciente(nome, idade, prioridade)
        memoria_antes = self.calcular_memoria_total()

        if not self.inicio:  # Se a fila estiver vazia
            self.inicio = self.fim = paciente
        elif prioridade == 2:  # Inserção com prioridade
            atual = self.inicio
            # Avança até o primeiro paciente normal
            while atual and atual.prioridade == 2:
                atual = atual.proximo
            if not atual:  # Todos são prioritários
                self.fim.proximo = paciente
                paciente.anterior = self.fim
                self.fim = paciente
            elif atual == self.inicio:  # Inserir no início
                paciente.proximo = self.inicio
                self.inicio.anterior = paciente
                self.inicio = paciente
            else:  # Inserir entre dois pacientes
                anterior = atual.anterior
                anterior.proximo = paciente
                paciente.anterior = anterior
                paciente.proximo = atual
                atual.anterior = paciente
        else:  # Inserção normal (fim da fila)
            self.fim.proximo = paciente
            paciente.anterior = self.fim
            self.fim = paciente

        print(f'Paciente {nome} adicionado.')
        memoria_depois = self.calcular_memoria_total()
        self.monitorar_memoria(memoria_antes, memoria_depois)

    # Remove um paciente da fila com base na política de atendimento
    def remover_paciente(self):
        if not self.inicio:  # Fila vazia
            print('Fila vazia.')
            return

        normais = prioritarios = 0
        atual = self.inicio
        # Conta pacientes normais e prioritários
        while atual:
            if atual.prioridade == 2:
                prioritarios += 1
            else:
                normais += 1
            atual = atual.proximo

        # Calcula proporção entre prioritários e normais
        proporcao = prioritarios / normais if normais else float('inf')

        # Alterna atendimento se proporção estiver dentro da regra
        if proporcao >= 1 / 7:
            tipo_remover = self.turno
            self.turno = 1 if self.turno == 2 else 2
        else:
            tipo_remover = 2 if prioritarios > 0 else 1

        # Encontra o paciente certo a ser removido
        atual = self.inicio
        while atual and atual.prioridade != tipo_remover:
            atual = atual.proximo

        if not atual:  # Nenhum paciente com a prioridade desejada
            print('Nenhum paciente adequado encontrado.')
            return

        memoria_antes = self.calcular_memoria_total()
        print(f'Atendendo paciente: {atual}')

        # Remove paciente da lista duplamente ligada
        if atual.anterior:
            atual.anterior.proximo = atual.proximo
        else:
            self.inicio = atual.proximo

        if atual.proximo:
            atual.proximo.anterior = atual.anterior
        else:
            self.fim = atual.anterior

        memoria_depois = self.calcular_memoria_total()
        self.monitorar_memoria(memoria_antes, memoria_depois)

    # Permite editar as informações de um paciente com base no nome
    def editar_paciente(self, nome, novo_nome=None, nova_idade=None, nova_prioridade=None):
        atual = self.inicio
        memoria_antes = self.calcular_memoria_total()

        while atual:
            if atual.nome == nome:
                if novo_nome:
                    atual.nome = novo_nome
                if nova_idade:
                    atual.idade = nova_idade
                if nova_prioridade:
                    atual.prioridade = nova_prioridade
                print(f'Paciente {nome} atualizado.')
                break
            atual = atual.proximo

        memoria_depois = self.calcular_memoria_total()
        self.monitorar_memoria(memoria_antes, memoria_depois)

    # Exibe a fila completa de pacientes
    def exibir_fila(self):
        atual = self.inicio
        if not atual:
            print('Fila vazia.')
            return

        print("\n📋 Fila de Atendimento:")
        fila_str = ""
        while atual:
            fila_str += str(atual)
            if atual.proximo:
                fila_str += " --> "  # Representa ligação entre os pacientes
            atual = atual.proximo
        print(fila_str + "\n")

    # Inicia os atendimentos automáticos com intervalo entre cada um
    def iniciar_atendimentos_automaticos(self, intervalo=5):
        print("\n⏳ Iniciando atendimentos automáticos a cada {} segundos...".format(intervalo))
        try:
            while True:
                self.remover_paciente()
                self.exibir_fila()
                time.sleep(intervalo)
        except KeyboardInterrupt:
            print("\n🔚 Atendimentos automáticos encerrados.")

# Função principal de interação com o usuário (modo texto)
def modo_interativo():
    fila = FilaMedica()
    print("\nModo Interativo Iniciado:")
    print("Comandos: adicionar Nome Idade P/N | atender | editar Nome Idade P/N | fila | iniciar | sair")

    while True:
        try:
            comando = input(">> ").strip().split()
            if not comando:
                continue
            acao = comando[0].lower()

            # Adiciona novo paciente com nome, idade e prioridade (P ou N)
            if acao == 'adicionar' and len(comando) == 4:
                nome = comando[1]
                idade = int(comando[2])
                prioridade = 2 if comando[3].upper() == 'P' else 1
                fila.adicionar_paciente(nome, idade, prioridade)

            # Remove paciente conforme política
            elif acao == 'atender':
                fila.remover_paciente()

            # Edita um paciente já existente
            elif acao == 'editar' and len(comando) == 4:
                nome = comando[1]
                idade = int(comando[2])
                prioridade = 2 if comando[3].upper() == 'P' else 1
                fila.editar_paciente(nome, nova_idade=idade, nova_prioridade=prioridade)

            # Exibe a fila atual
            elif acao == 'fila':
                fila.exibir_fila()

            # Inicia modo automático de atendimento
            elif acao == 'iniciar':
                fila.iniciar_atendimentos_automaticos()

            # Encerra o programa
            elif acao == 'sair':
                print("Encerrando.")
                break

            else:
                print("Comando inválido.")

        except Exception as e:
            print(f"Erro: {e}")

# Ponto de entrada do programa
if __name__ == '__main__':
    modo_interativo()
