import 'package:flutter/material.dart';

import '../models/question.dart';

/// As 18 perguntas do ASRS-18 (ASRS-v1.1), na ordem oficial.
///
/// `shadedFrom` reproduz a "área sombreada" do questionário impresso:
/// - Parte A, perguntas 1-3: sombreado a partir de "De vez em quando" (2)
/// - Parte A, perguntas 4-6: sombreado a partir de "Quase sempre" (3)
/// - Parte B: varia por pergunta, conforme o formulário original.
const List<Question> kQuestions = <Question>[
  // ---------------- PARTE A (rastreio) ----------------
  Question(
    number: 1,
    part: 'A',
    text:
        'Com que frequência você deixa um projeto pela metade depois de já ter feito as partes mais difíceis?',
    type: SymptomType.inattention,
    shadedFrom: 2,
    icon: Icons.donut_large,
  ),
  Question(
    number: 2,
    part: 'A',
    text:
        'Com que frequência você tem dificuldade para fazer um trabalho que exige organização?',
    type: SymptomType.inattention,
    shadedFrom: 2,
    icon: Icons.checklist,
  ),
  Question(
    number: 3,
    part: 'A',
    text:
        'Com que frequência você tem dificuldade para lembrar de compromissos ou obrigações?',
    type: SymptomType.inattention,
    shadedFrom: 2,
    icon: Icons.event_note,
  ),
  Question(
    number: 4,
    part: 'A',
    text:
        'Quando você precisa fazer algo que exige muita concentração, com que frequência você evita ou adia o início?',
    type: SymptomType.inattention,
    shadedFrom: 3,
    icon: Icons.hourglass_top,
  ),
  Question(
    number: 5,
    part: 'A',
    text:
        'Com que frequência você fica se mexendo na cadeira ou balançando as mãos ou os pés quando precisa ficar sentado(a) por muito tempo?',
    type: SymptomType.hyperactivity,
    shadedFrom: 3,
    icon: Icons.event_seat,
  ),
  Question(
    number: 6,
    part: 'A',
    text:
        'Com que frequência você se sente ativo(a) demais e necessitando fazer coisas, como se estivesse "com um motor ligado"?',
    type: SymptomType.hyperactivity,
    shadedFrom: 3,
    icon: Icons.bolt,
  ),

  // ---------------- PARTE B (complementar) ----------------
  Question(
    number: 7,
    part: 'B',
    text:
        'Com que frequência você comete erros bobos por falta de atenção quando tem de trabalhar num projeto chato ou difícil?',
    type: SymptomType.inattention,
    shadedFrom: 3,
    icon: Icons.error_outline,
  ),
  Question(
    number: 8,
    part: 'B',
    text:
        'Com que frequência você tem dificuldade para manter a atenção quando está fazendo um trabalho chato ou repetitivo?',
    type: SymptomType.inattention,
    shadedFrom: 3,
    icon: Icons.repeat,
  ),
  Question(
    number: 9,
    part: 'B',
    text:
        'Com que frequência você tem dificuldade para se concentrar no que as pessoas dizem, mesmo quando elas estão falando diretamente com você?',
    type: SymptomType.inattention,
    shadedFrom: 2,
    icon: Icons.hearing,
  ),
  Question(
    number: 10,
    part: 'B',
    text:
        'Com que frequência você coloca as coisas fora do lugar ou tem dificuldade de encontrar as coisas em casa ou no trabalho?',
    type: SymptomType.inattention,
    shadedFrom: 3,
    icon: Icons.search_off,
  ),
  Question(
    number: 11,
    part: 'B',
    text:
        'Com que frequência você se distrai com atividades ou barulho a sua volta?',
    type: SymptomType.inattention,
    shadedFrom: 3,
    icon: Icons.graphic_eq,
  ),
  Question(
    number: 12,
    part: 'B',
    text:
        'Com que frequência você se levanta da cadeira em reuniões ou em outras situações onde deveria ficar sentado(a)?',
    type: SymptomType.hyperactivity,
    shadedFrom: 2,
    icon: Icons.directions_walk,
  ),
  Question(
    number: 13,
    part: 'B',
    text: 'Com que frequência você se sente inquieto(a) ou agitado(a)?',
    type: SymptomType.hyperactivity,
    shadedFrom: 3,
    icon: Icons.vibration,
  ),
  Question(
    number: 14,
    part: 'B',
    text:
        'Com que frequência você tem dificuldade para sossegar e relaxar quando tem tempo livre para você?',
    type: SymptomType.hyperactivity,
    shadedFrom: 3,
    icon: Icons.self_improvement,
  ),
  Question(
    number: 15,
    part: 'B',
    text:
        'Com que frequência você se pega falando demais em situações sociais?',
    type: SymptomType.hyperactivity,
    shadedFrom: 3,
    icon: Icons.chat_bubble_outline,
  ),
  Question(
    number: 16,
    part: 'B',
    text:
        'Quando você está conversando, com que frequência você se pega terminando as frases das pessoas antes delas?',
    type: SymptomType.hyperactivity,
    shadedFrom: 2,
    icon: Icons.forum_outlined,
  ),
  Question(
    number: 17,
    part: 'B',
    text:
        'Com que frequência você tem dificuldade para esperar nas situações onde cada um tem a sua vez?',
    type: SymptomType.hyperactivity,
    shadedFrom: 3,
    icon: Icons.hourglass_empty,
  ),
  Question(
    number: 18,
    part: 'B',
    text:
        'Com que frequência você interrompe os outros quando eles estão ocupados?',
    type: SymptomType.hyperactivity,
    shadedFrom: 2,
    icon: Icons.pan_tool_outlined,
  ),
];
