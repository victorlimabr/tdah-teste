import 'package:flutter/material.dart';

import '../models/assessment.dart';
import '../models/question.dart';
import '../models/text_segment.dart';

/// SNAP-IV (18 itens) — triagem de TDAH em crianças e adolescentes,
/// respondida por pais ou professores. Tradução GEDA-UFRJ / UFRGS.
class Snap18Assessment extends Assessment {
  @override
  String get id => 'snap18';
  @override
  String get name => 'SNAP-IV';
  @override
  String get subtitle =>
      'Avaliação de TDAH em crianças, respondida por pais ou professores.';
  @override
  String get audience => 'Crianças';
  @override
  int get estimatedMinutes => 10;
  @override
  IconData get icon => Icons.child_care_outlined;
  @override
  bool get needsRespondent => true;

  @override
  List<String> get scale =>
      const ['Nem um pouco', 'Só um pouco', 'Bastante', 'Demais'];

  @override
  List<Section> get sections => const [
        Section(
          id: 'inatt',
          label: 'Desatenção',
          passThreshold: 6,
          questions: _inattention,
        ),
        Section(
          id: 'hyper',
          label: 'Hiperatividade',
          passThreshold: 6,
          questions: _hyperactivity,
        ),
      ];

  @override
  List<IntroPage> get intro => const [
        IntroPage(
          title: 'Diagnóstico de TDAH em crianças',
          image: 'assets/images/group_hug.png',
          paragraphs: [
            [
              Seg('Este é o '),
              Seg('SNAP-IV', hl: true),
              Seg(', baseado nos sintomas do '),
              Seg('DSM-IV', hl: true),
              Seg(', para avaliar '),
              Seg('crianças e adolescentes', hl: true),
              Seg('.'),
            ],
          ],
        ),
        IntroPage(
          title: 'Como funciona?',
          image: 'assets/images/onboarding_duo.png',
          paragraphs: [
            [Seg('São '), Seg('18 itens', hl: true), Seg(' em duas partes:')],
            [Seg('Desatenção: ', hl: true), Seg('itens 1 a 9.')],
            [
              Seg('Hiperatividade e impulsividade: ', hl: true),
              Seg('itens 10 a 18.'),
            ],
            [
              Seg('Responda usando a escala: '),
              Seg('Nem um pouco, Só um pouco, Bastante, Demais.', hl: true),
            ],
          ],
        ),
        IntroPage(
          title: 'Aviso Importante',
          image: 'assets/images/onboarding_mirror.png',
          paragraphs: [
            [
              Seg('Este teste é uma '),
              Seg('triagem inicial', hl: true),
              Seg(' e não substitui um diagnóstico profissional.'),
            ],
            [
              Seg('Deve ser respondido por quem '),
              Seg('convive com a criança', hl: true),
              Seg(' - pais ou professores.'),
            ],
            [
              Seg('Lembre-se:', hl: true),
              Seg(' só um profissional pode diagnosticar TDAH.'),
            ],
          ],
        ),
      ];

  @override
  TransitionContent? transitionAfter(int sectionIndex, AssessmentResult partial) {
    // Sem transição entre as subescalas: vai direto para a próxima parte.
    return null;
  }

  @override
  ResultContent resultContent(AssessmentResult result) {
    final inatt = result.sectionById('inatt').reached;
    final hyper = result.sectionById('hyper').reached;

    final List<Seg> body;
    if (inatt && hyper) {
      body = const [
        Seg('A avaliação indicou mais sintomas de '),
        Seg('desatenção', hl: true),
        Seg(' e de '),
        Seg('hiperatividade/impulsividade', hl: true),
        Seg(' que o esperado. É importante '),
        Seg('procurar um profissional especializado', hl: true),
        Seg(' para uma avaliação completa.'),
      ];
    } else if (inatt) {
      body = const [
        Seg('A avaliação indicou mais sintomas de '),
        Seg('desatenção', hl: true),
        Seg(' que o esperado. Vale '),
        Seg('procurar um profissional', hl: true),
        Seg(' para uma avaliação completa.'),
      ];
    } else if (hyper) {
      body = const [
        Seg('A avaliação indicou mais sintomas de '),
        Seg('hiperatividade/impulsividade', hl: true),
        Seg(' que o esperado. Vale '),
        Seg('procurar um profissional', hl: true),
        Seg(' para uma avaliação completa.'),
      ];
    } else {
      body = const [
        Seg('A avaliação '),
        Seg('não indicou um número significativo de sintomas', hl: true),
        Seg('. Se ainda assim houver preocupação, converse com um '),
        Seg('profissional de saúde.', hl: true),
      ];
    }

    return ResultContent(
      headline: 'Parabéns!',
      subtitle: 'Você completou o teste!',
      body: body,
    );
  }

  @override
  String shareMessage(AssessmentResult result) {
    final inatt = result.sectionById('inatt').reached;
    final hyper = result.sectionById('hyper').reached;
    final String verdict;
    if (inatt && hyper) {
      verdict = 'a avaliação indicou mais sintomas de desatenção e de '
          'hiperatividade/impulsividade que o esperado.';
    } else if (inatt) {
      verdict = 'a avaliação indicou mais sintomas de desatenção que o '
          'esperado.';
    } else if (hyper) {
      verdict = 'a avaliação indicou mais sintomas de '
          'hiperatividade/impulsividade que o esperado.';
    } else {
      verdict = 'a avaliação não indicou um número significativo de sintomas.';
    }
    return 'Respondi o SNAP-IV (triagem de TDAH em crianças). '
        'No resultado, $verdict\n\n'
        '⚠️ Este teste não é um diagnóstico. Só um profissional de saúde '
        'pode diagnosticar TDAH.';
  }
}

const _inattention = <Question>[
  Question(
    number: 1,
    countFrom: 2,
    text: 'Não consegue prestar muita atenção a detalhes ou comete erros por '
        'descuido nos trabalhos da escola ou tarefas.',
  ),
  Question(
    number: 2,
    countFrom: 2,
    text: 'Tem dificuldade de manter a atenção em tarefas ou atividades de '
        'lazer.',
  ),
  Question(
    number: 3,
    countFrom: 2,
    text: 'Parece não estar ouvindo quando se fala diretamente com ele.',
  ),
  Question(
    number: 4,
    countFrom: 2,
    text: 'Não segue instruções até o fim e não termina deveres de escola, '
        'tarefas ou obrigações.',
  ),
  Question(
    number: 5,
    countFrom: 2,
    text: 'Tem dificuldade para organizar tarefas e atividades.',
  ),
  Question(
    number: 6,
    countFrom: 2,
    text: 'Evita, não gosta ou se envolve contra a vontade em tarefas que '
        'exigem esforço mental prolongado.',
  ),
  Question(
    number: 7,
    countFrom: 2,
    text: 'Perde coisas necessárias para atividades (p. ex: brinquedos, '
        'deveres da escola, lápis ou livros).',
  ),
  Question(
    number: 8,
    countFrom: 2,
    text: 'Distrai-se com estímulos externos.',
  ),
  Question(
    number: 9,
    countFrom: 2,
    text: 'É esquecido em atividades do dia-a-dia.',
  ),
];

const _hyperactivity = <Question>[
  Question(
    number: 10,
    countFrom: 2,
    text: 'Mexe com as mãos ou pés ou se remexe na cadeira.',
  ),
  Question(
    number: 11,
    countFrom: 2,
    text: 'Sai do lugar na sala de aula ou em outras situações em que se '
        'espera que fique sentado.',
  ),
  Question(
    number: 12,
    countFrom: 2,
    text: 'Corre de um lado para outro ou sobe demais nas coisas em situações '
        'em que isto é inapropriado.',
  ),
  Question(
    number: 13,
    countFrom: 2,
    text: 'Tem dificuldade em brincar ou envolver-se em atividades de lazer de '
        'forma calma.',
  ),
  Question(
    number: 14,
    countFrom: 2,
    text: 'Não pára ou frequentemente está a "mil por hora".',
  ),
  Question(
    number: 15,
    countFrom: 2,
    text: 'Fala em excesso.',
  ),
  Question(
    number: 16,
    countFrom: 2,
    text: 'Responde as perguntas de forma precipitada antes delas terem sido '
        'terminadas.',
  ),
  Question(
    number: 17,
    countFrom: 2,
    text: 'Tem dificuldade de esperar sua vez.',
  ),
  Question(
    number: 18,
    countFrom: 2,
    text: 'Interrompe os outros ou se intromete (por exemplo: intromete-se nas '
        'conversas, jogos, etc.).',
  ),
];
