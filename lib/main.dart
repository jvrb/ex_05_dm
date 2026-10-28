import 'package:flutter/material.dart';

void main() {
  runApp(const ParticipanteApp());
}

// 1. Classe de Dados imutável (Model)
class Participante {
  final String email;
  final String nome;
  final String telefone;
  final String cpf;

  const Participante({
    required this.email,
    required this.nome,
    required this.telefone,
    required this.cpf,
  });
}

// 2. Widget raiz da aplicação
class ParticipanteApp extends StatelessWidget {
  const ParticipanteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Participante',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TelaCadastro(),
    );
  }
}

// 3. Tela de Cadastro (StatefulWidget para gerenciar controladores e estado)
class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  // Chave global para controlar o estado do Form e disparar a validação
  final _formKey = GlobalKey<FormState>();

  // Controladores para ler e alterar o texto de cada campo
  final _emailController = TextEditingController();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();

  // Regras de validação do E-mail
  String? _validarEmail(String? valor) {
    final email = valor?.trim() ?? '';
    if (email.isEmpty) {
      return 'Informe o e-mail.';
    }
    final formato = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!formato.hasMatch(email)) {
      return 'Informe um e-mail válido, como ana@email.com.';
    }
    return null;
  }

  // Regras de validação do Nome
  String? _validarNome(String? valor) {
    final nome = valor?.trim() ?? '';
    if (nome.isEmpty) {
      return 'Informe o nome.';
    }
    if (nome.length < 3) {
      return 'O nome deve ter pelo menos três caracteres.';
    }
    return null;
  }

  // Regras de validação do Telefone (Formato DD-DDDDD-DDDD)
  String? _validarTelefone(String? valor) {
    final telefone = valor?.trim() ?? '';
    if (telefone.isEmpty) {
      return 'Informe o telefone.';
    }
    final formato = RegExp(r'^\d{2}-\d{5}-\d{4}$');
    if (!formato.hasMatch(telefone)) {
      return 'Informe no formato DD-DDDDD-DDDD.';
    }
    return null;
  }

  // Regras de validação do CPF (Exatamente 11 dígitos numéricos)
  String? _validarCpf(String? valor) {
    final cpf = valor?.trim() ?? '';
    if (cpf.isEmpty) {
      return 'Informe o CPF.';
    }
    final formato = RegExp(r'^\d{11}$');
    if (!formato.hasMatch(cpf)) {
      return 'O CPF deve conter exatamente 11 dígitos (apenas números).';
    }
    return null;
  }

  // Ação executada ao clicar em "Exibir dados" ou pressionar enter no último campo
  void _exibirDados() {
    final formularioValido = _formKey.currentState!.validate();
    if (!formularioValido) {
      return;
    }

    // Criando o objeto participante com os dados limpos por trim()
    final participante = Participante(
      email: _emailController.text.trim(),
      nome: _nomeController.text.trim(),
      telefone: _telefoneController.text.trim(),
      cpf: _cpfController.text.trim(),
    );

    // Fecha o teclado virtual
    FocusScope.of(context).unfocus();

    // Navega para a tela de resumo passando o objeto
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => TelaResumo(participante: participante),
      ),
    );
  }

  // Ação para limpar os campos e redefinir os erros
  void _limpar() {
    _formKey.currentState!.reset();
    _emailController.clear();
    _nomeController.clear();
    _telefoneController.clear();
    _cpfController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    // Descarte obrigatório dos controladores para liberar memória
    _emailController.dispose();
    _nomeController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de participante'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo E-mail
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'ana@email.com',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                validator: _validarEmail,
              ),
              const SizedBox(height: 16),

              // Campo Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  hintText: 'Ex.: Ana Souza',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: _validarNome,
              ),
              const SizedBox(height: 16),

              // Campo Telefone
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: '12-98765-4321',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: _validarTelefone,
              ),
              const SizedBox(height: 16),

              // Campo CPF
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  hintText: 'Apenas 11 números',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: _validarCpf,
                onFieldSubmitted: (_) => _exibirDados(),
              ),
              const SizedBox(height: 24),

              // Botão Exibir dados
              ElevatedButton(
                onPressed: _exibirDados,
                child: const Text('Exibir dados'),
              ),
              const SizedBox(height: 8),

              // Botão Limpar
              OutlinedButton(
                onPressed: _limpar,
                child: const Text('Limpar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. Tela de Resumo
class TelaResumo extends StatelessWidget {
  final Participante participante;

  const TelaResumo({
    super.key,
    required this.participante,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo do cadastro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Dados do participante',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text('E-mail: ${participante.email}'),
            const SizedBox(height: 12),
            Text('Nome: ${participante.nome}'),
            const SizedBox(height: 12),
            Text('Telefone: ${participante.telefone}'),
            const SizedBox(height: 12),
            Text('CPF: ${participante.cpf}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar para editar'),
            ),
          ],
        ),
      ),
    );
  }
}