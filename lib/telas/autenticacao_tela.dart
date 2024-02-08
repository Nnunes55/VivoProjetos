import 'package:flutter/material.dart';
import 'package:flutter_application_2/_comum/meu_snackbar.dart';
import 'package:flutter_application_2/_comum/minhas_cores.dart';
import 'package:flutter_application_2/componentes/decoracao_campo_autenticacao.dart';
import 'package:flutter_application_2/servicos/autenticacao_servico.dart';

class AutenticacaoTela extends StatefulWidget {
  const AutenticacaoTela({super.key});

  @override
  State<AutenticacaoTela> createState() => _AutenticacaoTelaState();
}

class _AutenticacaoTelaState extends State<AutenticacaoTela> {
  bool queroEntrar = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmacaoSenhaController =
      TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  final AutenticacaoServico _autenServico = AutenticacaoServico();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  MinhasCores.azulTopoGradiente,
                  MinhasCores.azulBaixoGradiente,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset("assets/vivo.png", height: 70),
                      const Text(
                        "VivoProjetos",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: getAuthenticationInputDecoration("E-mail"),
                        validator: (String? value) {
                          if (value == null) {
                            return "o e-mail não pode ser vazio";
                          }
                          if (value.length < 5) {
                            return "o e-mail é muito curto";
                          }
                          if (!value.contains("@")) {
                            return "o e-mail não é valido";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _senhaController,
                        decoration: getAuthenticationInputDecoration("Senha"),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null) {
                            return "a senha não pode ser vazia";
                          }
                          if (value.length < 5) {
                            return "a senha é muito curta";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Visibility(
                        visible: !queroEntrar,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _confirmacaoSenhaController,
                              decoration: getAuthenticationInputDecoration(
                                  "Confirme a senha"),
                              obscureText: true,
                              validator: (String? value) {
                                if (value == null) {
                                  return "a confirmação de senha não pode ser vazia";
                                }
                                if (value.length < 5) {
                                  return "a confirmação de senha é muito curta";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _nomeController,
                              decoration:
                                  getAuthenticationInputDecoration("Nome"),
                              validator: (String? value) {
                                if (value == null) {
                                  return "o nome não pode ser vazio";
                                }
                                if (value.length < 5) {
                                  return "o nome é muito curto";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          botaoPrincipalClicado();
                        },
                        child: Text((queroEntrar) ? "Entrar" : "Cadastrar"),
                      ),
                      const Divider(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            queroEntrar = !queroEntrar;
                          });
                        },
                        child: Text((queroEntrar)
                            ? "Ainda não tem uma conta? Cadastre-se!"
                            : "Já tem uma conta? Entre!"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  botaoPrincipalClicado() {
    String nome = _nomeController.text;
    String senha = _senhaController.text;
    String confirmacaoSenha = _confirmacaoSenhaController.text;
    String email = _emailController.text;

    if (_formKey.currentState!.validate()) {
      if (queroEntrar) {
        print("Entrada Validada!");
        _autenServico.logarUsuarios(email: email, senha: senha).then(
          (String? erro) {
            if (erro != null) {
              mostrarSnackBar(context: context, texto: erro);
            }
          },
        );
      } else {
        print("Cadastro Validado!");
        print(
            "${_emailController.text}, ${_senhaController.text}, ${_confirmacaoSenhaController.text}, ${_nomeController.text}");
        _autenServico
            .cadastrarUsuario(
                nome: nome,
                senha: senha,
                confirmacaoSenha: confirmacaoSenha,
                email: email)
            .then(
          (String? erro) {
            if (erro != null) {
              //voltou com erro
              mostrarSnackBar(context: context, texto: erro);
            }
          },
        );
      }
    } else {
      print("Form invalido!");
    }
  }
}
