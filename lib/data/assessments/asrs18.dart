import 'package:flutter/material.dart';

import '../models/assessment.dart';
import '../models/question.dart';
import '../models/text_segment.dart';

/// ASRS-18 (ASRS-v1.1) — autoavaliação de sintomas de TDAH em adultos.
class Asrs18Assessment extends Assessment {
  @override
  String get id => 'asrs18';
  @override
  String get name => 'ASRS-18';
  @override
  String get subtitle => 'Autoavaliação de sintomas de TDAH em adultos.';
  @override
  String get audience => 'Adultos';
  @override
  int get estimatedMinutes => 5;
  @override
  IconData get icon => Icons.person_outline;
  @override
  bool get needsRespondent => false;

  @override
  List<String> get scale => const [
        'Nunca',
        'Raramente',
        'Às vezes',
        'Frequentemente',
        'Muito frequentemente',
      ];

  @override
  List<Section> get sections => const [
        Section(
          id: 'A',
          label: 'Parte A',
          passThreshold: 4,
          questions: _partA,
        ),
        Section(
          id: 'B',
          label: 'Parte B',
          passThreshold: 999, // complementar/informativa
          isScreener: false,
          questions: _partB,
        ),
      ];

  @override
  List<IntroPage> get intro => const [
        IntroPage(
          title: 'Bem-vindo ao Teste de sintomas de TDAH!',
          image: 'assets/images/group_hug.png',
          paragraphs: [
            [
              Seg('Nosso teste é baseado na '),
              Seg('escala ASRS-18', hl: true),
              Seg(', uma '),
              Seg('ferramenta validada', hl: true),
              Seg(' para '),
              Seg('autoavaliação de sintomas em adultos', hl: true),
              Seg('.'),
            ],
          ],
        ),
        IntroPage(
          title: 'Como funciona o autoteste?',
          image: 'assets/images/onboarding_duo.png',
          paragraphs: [
            [Seg('O teste é dividido em '), Seg('duas partes:', hl: true)],
            [
              Seg('Parte A: ', hl: true),
              Seg('Identifica os sintomas mais comuns.'),
            ],
            [
              Seg('Parte B: ', hl: true),
              Seg('Explora sintomas complementares.'),
            ],
            [
              Seg('Responda com sinceridade às perguntas sobre seu '
                  'comportamento, usando a escala: '),
              Seg('Nunca, Raramente, Às vezes, Frequentemente, '
                  'Muito frequentemente.', hl: true),
            ],
          ],
        ),
        IntroPage(
          title: 'Aviso Importante',
          image: 'assets/images/onboarding_mirror.png',
          paragraphs: [
            [
              Seg('Este teste é uma '),
              Seg('autoavaliação inicial', hl: true),
              Seg(' e não substitui um diagnóstico profissional.'),
            ],
            [
              Seg('Se os resultados indicarem possíveis sintomas de TDAH, '
                  'recomendamos procurar um '),
              Seg('médico ou psicólogo especializado', hl: true),
              Seg(' para uma avaliação completa.'),
            ],
            [
              Seg('Lembre-se:', hl: true),
              Seg(' o diagnóstico é o primeiro passo para o tratamento e '
                  'melhoria da qualidade de vida!'),
            ],
          ],
        ),
        IntroPage(
          title: 'Parte A',
          image: 'assets/images/group_hug.png',
          paragraphs: [
            [
              Seg('Contém '),
              Seg('6 questões centrais', hl: true),
              Seg(', consideradas mais relevantes para '),
              Seg('identificar sintomas', hl: true),
              Seg(' do TDAH em adultos.'),
            ],
          ],
        ),
      ];

  @override
  TransitionContent? transitionAfter(int sectionIndex, AssessmentResult partial) {
    if (sectionIndex != 0) return null; // só há transição depois da Parte A
    final positive = partial.sectionById('A').reached;
    return TransitionContent(
      title: 'Parabéns!',
      subtitle: 'Você completou a primeira parte do teste!',
      showExit: !positive,
      body: positive
          ? const [
              Seg('O resultado sugere uma '),
              Seg('compatibilidade alta com um possível diagnóstico', hl: true),
              Seg(', recomendando uma '),
              Seg('investigação médica.', hl: true),
              Seg(' Vamos para a parte B para uma '),
              Seg('análise mais detalhada', hl: true),
              Seg(' para apoiar a avaliação.'),
            ]
          : const [
              Seg('Os critérios de triagem para TDAH '),
              Seg('não foram atendidos', hl: true),
              Seg('. A '),
              Seg('parte B ainda pode ser preenchida', hl: true),
              Seg(' para fornecer informações adicionais, mas '),
              Seg('não é obrigatória.', hl: true),
            ],
    );
  }

  @override
  ResultContent resultContent(AssessmentResult result) {
    return ResultContent(
      headline: 'Parabéns!',
      subtitle: 'Você completou o teste!',
      body: result.isPositive
          ? const [
              Seg('A triagem indicou '),
              Seg('compatibilidade com sintomas de TDAH', hl: true),
              Seg(', é importante '),
              Seg('procurar um médico ou psicólogo especializado', hl: true),
              Seg(' para '),
              Seg('confirmar o diagnóstico', hl: true),
              Seg(' e '),
              Seg('discutir possíveis tratamentos.', hl: true),
            ]
          : const [
              Seg('A triagem '),
              Seg('não indicou um número significativo de sintomas', hl: true),
              Seg(' de TDAH. Se ainda assim eles '),
              Seg('afetam o seu dia a dia', hl: true),
              Seg(', vale conversar com um '),
              Seg('profissional de saúde.', hl: true),
            ],
    );
  }

  @override
  String shareMessage(AssessmentResult result) {
    final verdict = result.isPositive
        ? 'a triagem indicou compatibilidade com sintomas de TDAH — vale '
            'procurar uma avaliação profissional.'
        : 'a triagem não indicou um número significativo de sintomas.';
    return 'Fiz a autoavaliação de sintomas de TDAH (escala ASRS-18). '
        'No meu resultado, $verdict\n\n'
        '⚠️ Este teste não é um diagnóstico. Só um profissional de saúde '
        'pode diagnosticar TDAH.';
  }
}

const _partA = <Question>[
  Question(
    number: 1,
    countFrom: 2,
    text: 'Com que frequência você deixa um projeto pela metade depois de já '
        'ter feito as partes mais difíceis?',
  ),
  Question(
    number: 2,
    countFrom: 2,
    text: 'Com que frequência você tem dificuldade para fazer um trabalho que '
        'exige organização?',
  ),
  Question(
    number: 3,
    countFrom: 2,
    text: 'Com que frequência você tem dificuldade para lembrar de '
        'compromissos ou obrigações?',
  ),
  Question(
    number: 4,
    countFrom: 3,
    text: 'Quando você precisa fazer algo que exige muita concentração, com '
        'que frequência você evita ou adia o início?',
  ),
  Question(
    number: 5,
    countFrom: 3,
    text: 'Com que frequência você fica se mexendo na cadeira ou balançando as '
        'mãos ou os pés quando precisa ficar sentado(a) por muito tempo?',
  ),
  Question(
    number: 6,
    countFrom: 3,
    text: 'Com que frequência você se sente ativo(a) demais e necessitando '
        'fazer coisas, como se estivesse "com um motor ligado"?',
  ),
];

const _partB = <Question>[
  Question(
    number: 7,
    countFrom: 3,
    text: 'Com que frequência você comete erros bobos por falta de atenção '
        'quando tem de trabalhar num projeto chato ou difícil?',
  ),
  Question(
    number: 8,
    countFrom: 3,
    text: 'Com que frequência você tem dificuldade para manter a atenção '
        'quando está fazendo um trabalho chato ou repetitivo?',
  ),
  Question(
    number: 9,
    countFrom: 2,
    text: 'Com que frequência você tem dificuldade para se concentrar no que '
        'as pessoas dizem, mesmo quando elas estão falando diretamente com '
        'você?',
  ),
  Question(
    number: 10,
    countFrom: 3,
    text: 'Com que frequência você coloca as coisas fora do lugar ou tem '
        'dificuldade de encontrar as coisas em casa ou no trabalho?',
  ),
  Question(
    number: 11,
    countFrom: 3,
    text: 'Com que frequência você se distrai com atividades ou barulho a sua '
        'volta?',
  ),
  Question(
    number: 12,
    countFrom: 2,
    text: 'Com que frequência você se levanta da cadeira em reuniões ou em '
        'outras situações onde deveria ficar sentado(a)?',
  ),
  Question(
    number: 13,
    countFrom: 3,
    text: 'Com que frequência você se sente inquieto(a) ou agitado(a)?',
  ),
  Question(
    number: 14,
    countFrom: 3,
    text: 'Com que frequência você tem dificuldade para sossegar e relaxar '
        'quando tem tempo livre para você?',
  ),
  Question(
    number: 15,
    countFrom: 3,
    text: 'Com que frequência você se pega falando demais em situações '
        'sociais?',
  ),
  Question(
    number: 16,
    countFrom: 2,
    text: 'Quando você está conversando, com que frequência você se pega '
        'terminando as frases das pessoas antes delas?',
  ),
  Question(
    number: 17,
    countFrom: 3,
    text: 'Com que frequência você tem dificuldade para esperar nas situações '
        'onde cada um tem a sua vez?',
  ),
  Question(
    number: 18,
    countFrom: 2,
    text: 'Com que frequência você interrompe os outros quando eles estão '
        'ocupados?',
  ),
];
