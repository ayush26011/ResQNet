class FirstAidCategory {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final List<FirstAidArticle> articles;

  const FirstAidCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.articles,
  });
}

class FirstAidArticle {
  final String id;
  final String title;
  final String summary;
  final List<String> steps;
  final List<String> warnings;
  final String emoji;
  final String duration;
  final String difficulty;

  const FirstAidArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.steps,
    required this.warnings,
    required this.emoji,
    required this.duration,
    required this.difficulty,
  });
}

final firstAidCategories = <FirstAidCategory>[
  FirstAidCategory(
    id: 'cpr',
    title: 'CPR',
    subtitle: 'Cardiac emergency',
    emoji: '❤️',
    articles: [
      FirstAidArticle(
        id: 'cpr-adult',
        title: 'CPR for Adults',
        summary:
            "Cardiopulmonary resuscitation (CPR) is a lifesaving technique useful in emergencies where someone's breathing or heartbeat has stopped.",
        steps: [
          'Check the scene for safety, then check the person for responsiveness.',
          'Call emergency services (112 / 911) or ask someone else to call.',
          'Place the heel of your hand on the center of the chest.',
          'Push hard and fast: at least 2 inches deep at 100–120 compressions per minute.',
          'Give 2 rescue breaths after every 30 compressions if trained.',
          'Continue until help arrives or the person begins breathing.',
        ],
        warnings: [
          'Do not perform CPR if the person is breathing normally.',
          'Rib fractures may occur — continue CPR anyway.',
        ],
        emoji: '❤️',
        duration: '5 min read',
        difficulty: 'Critical',
      ),
      FirstAidArticle(
        id: 'cpr-child',
        title: 'CPR for Children',
        summary:
            'Child CPR follows similar steps to adult CPR but uses gentler compressions tailored to smaller bodies.',
        steps: [
          'Check responsiveness: tap shoulder and shout.',
          'Call 112 or ask a bystander to call.',
          'Use one or two hands for chest compressions (2 inches deep).',
          'Give 30 compressions at 100–120/min, then 2 gentle breaths.',
          'Continue until help arrives.',
        ],
        warnings: [
          'Use only one hand for children under 8.',
          'Do not tilt head too far back for infants.',
        ],
        emoji: '👶',
        duration: '4 min read',
        difficulty: 'Critical',
      ),
    ],
  ),
  FirstAidCategory(
    id: 'burns',
    title: 'Burns',
    subtitle: 'Fire & heat injuries',
    emoji: '🔥',
    articles: [
      FirstAidArticle(
        id: 'burns-minor',
        title: 'Minor Burns (1st & 2nd Degree)',
        summary:
            'Minor burns affect the outer layers of skin. Quick first aid reduces pain and prevents infection.',
        steps: [
          'Cool the burn under cool (not cold) running water for 10–20 minutes.',
          'Do NOT use ice, butter, or toothpaste.',
          'Cover loosely with a sterile non-stick bandage.',
          'Take over-the-counter pain relief if needed.',
          'Do not break blisters — let them heal naturally.',
        ],
        warnings: [
          'Seek immediate help if burn is larger than 3 inches.',
          'Burns on face, hands, feet, genitals need urgent care.',
        ],
        emoji: '💧',
        duration: '3 min read',
        difficulty: 'Moderate',
      ),
    ],
  ),
  FirstAidCategory(
    id: 'fractures',
    title: 'Fractures',
    subtitle: 'Bone & joint injuries',
    emoji: '🦴',
    articles: [
      FirstAidArticle(
        id: 'fracture-limb',
        title: 'Limb Fractures',
        summary:
            'A fracture is a broken bone. Proper immobilization prevents further injury during emergency response.',
        steps: [
          'Stop any bleeding by applying gentle pressure with a clean cloth.',
          'Immobilize the injured area — do NOT try to realign the bone.',
          'Apply ice packs wrapped in cloth to limit swelling.',
          'Elevate the injury above heart level if possible.',
          'Seek emergency medical help immediately.',
        ],
        warnings: [
          'Never move someone with a suspected spine or neck fracture.',
          'Do not apply tourniquet unless trained to do so.',
        ],
        emoji: '🩹',
        duration: '4 min read',
        difficulty: 'High',
      ),
    ],
  ),
  FirstAidCategory(
    id: 'flood',
    title: 'Flood Safety',
    subtitle: 'Water emergency',
    emoji: '🌊',
    articles: [
      FirstAidArticle(
        id: 'flood-safety',
        title: 'Flood Emergency Response',
        summary:
            'Floods are the most common natural disaster. Knowing how to respond quickly can save lives.',
        steps: [
          'Move immediately to higher ground — do not wait.',
          'Avoid walking in moving water — 6 inches can knock you down.',
          'Do not drive into flooded roads — turn around.',
          'If trapped, go to the highest level of the building.',
          'Signal for help from windows or roof with bright clothing.',
          'After flooding, avoid tap water until authorities confirm it is safe.',
        ],
        warnings: [
          '6 inches of moving water can knock an adult off their feet.',
          'Never touch electrical equipment during floods.',
        ],
        emoji: '🌊',
        duration: '5 min read',
        difficulty: 'Critical',
      ),
    ],
  ),
  FirstAidCategory(
    id: 'fire',
    title: 'Fire Safety',
    subtitle: 'Fire emergency',
    emoji: '🚒',
    articles: [
      FirstAidArticle(
        id: 'fire-escape',
        title: 'Fire Escape & Safety',
        summary:
            'In a fire emergency, seconds count. Knowing the right steps can mean the difference between life and death.',
        steps: [
          'Alert others — yell "Fire!" and activate the fire alarm.',
          'Call emergency services immediately (112).',
          'Stay low — smoke rises, so crawl below it.',
          'Before opening doors, check for heat with the back of your hand.',
          'Use stairs — never elevators during a fire.',
          'Once out, stay out — never go back in.',
        ],
        warnings: [
          'Smoke inhalation is the #1 cause of fire deaths.',
          'Never hide under beds or in closets.',
        ],
        emoji: '🚪',
        duration: '4 min read',
        difficulty: 'Critical',
      ),
    ],
  ),
  FirstAidCategory(
    id: 'choking',
    title: 'Choking',
    subtitle: 'Airway obstruction',
    emoji: '😮‍💨',
    articles: [
      FirstAidArticle(
        id: 'choking-adult',
        title: 'Choking — Heimlich Maneuver',
        summary:
            'Choking is a life-threatening emergency. The Heimlich maneuver can dislodge a foreign object quickly.',
        steps: [
          'Ask "Are you choking?" — if they cannot speak, act immediately.',
          'Stand behind the person and wrap your arms around their waist.',
          'Make a fist with one hand, place it thumb-side against abdomen above navel.',
          'Grasp your fist with other hand, give quick upward thrusts.',
          'Repeat until object is expelled or person loses consciousness.',
          'If unconscious, begin CPR immediately.',
        ],
        warnings: [
          'Do not perform abdominal thrusts on infants — use back blows.',
          'Seek medical care after Heimlich — internal injuries may occur.',
        ],
        emoji: '🤜',
        duration: '3 min read',
        difficulty: 'Critical',
      ),
    ],
  ),
];
