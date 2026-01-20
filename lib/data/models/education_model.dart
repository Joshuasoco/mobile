/// MSME Pathways - Education Models
/// 
/// Data models for loan education modules and lessons.
library;

/// Category of education content.
enum EducationCategory {
  /// Basic financial literacy
  basics('Basics', 'Foundation ng financial literacy'),
  /// Loan application processes
  applications('Applications', 'Paano mag-apply ng loan'),
  /// Repayment and management
  repayment('Repayment', 'Pagbabayad at management'),
  /// Business growth
  growth('Business Growth', 'Papalakihin ang negosyo');

  final String label;
  final String description;
  const EducationCategory(this.label, this.description);
}

/// Type of lesson content.
enum ContentType {
  /// Text-based article
  article,
  /// Video content
  video,
  /// Interactive quiz
  quiz,
  /// Infographic
  infographic,
}

/// Represents a single lesson within a module.
class LessonContent {
  /// Unique lesson identifier.
  final String id;

  /// Lesson title.
  final String title;

  /// Brief description.
  final String description;

  /// Type of content.
  final ContentType type;

  /// Duration in minutes.
  final int durationMinutes;

  /// Main content body (markdown-like).
  final String content;

  /// Optional video URL.
  /// TODO: Backend - Integrate video streaming
  final String? videoUrl;

  /// Quiz questions if this is a quiz.
  final List<QuizQuestion>? quizQuestions;

  /// Order within the module.
  final int order;

  /// Creates a lesson content.
  const LessonContent({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.durationMinutes,
    required this.content,
    this.videoUrl,
    this.quizQuestions,
    required this.order,
  });

  /// Whether this is a quiz lesson.
  bool get isQuiz => type == ContentType.quiz;

  /// Whether this has video.
  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
}

/// Represents a quiz question.
class QuizQuestion {
  /// Question text.
  final String question;

  /// Answer options.
  final List<String> options;

  /// Index of correct answer.
  final int correctIndex;

  /// Explanation for the correct answer.
  final String explanation;

  /// Creates a quiz question.
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

/// Represents user progress in a lesson.
class LessonProgress {
  /// Lesson ID.
  final String lessonId;

  /// Whether completed.
  final bool completed;

  /// Quiz score if applicable (0-100).
  final int? quizScore;

  /// Time spent in seconds.
  final int timeSpentSeconds;

  /// When last accessed.
  final DateTime? lastAccessedAt;

  /// Creates lesson progress.
  const LessonProgress({
    required this.lessonId,
    this.completed = false,
    this.quizScore,
    this.timeSpentSeconds = 0,
    this.lastAccessedAt,
  });

  /// Creates a copy with updated fields.
  LessonProgress copyWith({
    bool? completed,
    int? quizScore,
    int? timeSpentSeconds,
    DateTime? lastAccessedAt,
  }) {
    return LessonProgress(
      lessonId: lessonId,
      completed: completed ?? this.completed,
      quizScore: quizScore ?? this.quizScore,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
    );
  }
}

/// Represents an education module.
class LoanEducationModule {
  /// Unique module identifier.
  final String id;

  /// Module title.
  final String title;

  /// Module description.
  final String description;

  /// Category.
  final EducationCategory category;

  /// Icon name for display.
  final String iconName;

  /// Primary color for theming.
  final int colorValue;

  /// List of lessons.
  final List<LessonContent> lessons;

  /// Whether this is a featured module.
  final bool isFeatured;

  /// Creates an education module.
  const LoanEducationModule({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.iconName,
    required this.colorValue,
    required this.lessons,
    this.isFeatured = false,
  });

  /// Total lessons count.
  int get totalLessons => lessons.length;

  /// Total duration in minutes.
  int get totalDuration =>
      lessons.fold(0, (sum, lesson) => sum + lesson.durationMinutes);

  /// Formatted duration string.
  String get durationFormatted {
    if (totalDuration < 60) return '$totalDuration min';
    final hours = totalDuration ~/ 60;
    final mins = totalDuration % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }
}

/// Mock data for education modules.
class EducationModules {
  EducationModules._();

  /// Get all modules.
  static List<LoanEducationModule> getAll() => [
    financialLiteracy101,
    loanApplicationGuide,
    businessPlanning,
    smartRepayment,
  ];

  /// Financial Literacy 101 module.
  static const financialLiteracy101 = LoanEducationModule(
    id: 'fin-lit-101',
    title: 'Financial Literacy 101',
    description: 'Alamin ang basics ng pera at negosyo',
    category: EducationCategory.basics,
    iconName: 'school',
    colorValue: 0xFF26A69A,
    isFeatured: true,
    lessons: [
      LessonContent(
        id: 'fl-1',
        title: 'Ano ang Financial Literacy?',
        description: 'Understanding basic money concepts',
        type: ContentType.article,
        durationMinutes: 8,
        order: 1,
        content: '''
# Ano ang Financial Literacy?

Ang **financial literacy** ang kakayahan mong maintindihan at magamit nang tama ang pera.

## Bakit Importante Ito?

1. **Maging wise sa pera** - Alam mo kung saan napupunta ang kinikita mo
2. **Makapag-save** - May ipon para sa emergencies
3. **Makaiwas sa utang** - Hindi masyadong umaasa sa loan
4. **Mapalago ang negosyo** - Tamang decisions para lumaki ang kita

## Mga Basic Concepts

### Income vs Expenses
- **Income** = Pera na pumapasok (kita, sales)
- **Expenses** = Pera na lumalabas (gastos, bills)

### Savings Rule
Subukang mag-save ng **20%** ng income mo bago gumastos.

> 💡 **Tip**: Kahit ₱100 per day, malaki na yan sa isang buwan!
''',
      ),
      LessonContent(
        id: 'fl-2',
        title: 'Budgeting para sa MSME',
        description: 'Practical tips para sa small business',
        type: ContentType.article,
        durationMinutes: 10,
        order: 2,
        content: '''
# Budgeting para sa MSME

## Bakit Kailangan ng Budget?

Ang budget ang "roadmap" ng pera mo. Ito ang gabay kung:
- Magkano ang pwedeng gastusin
- Magkano ang kailangang i-save
- Kailan pwedeng bumili ng bagong stock

## Simple Budgeting Method

### The 50-30-20 Rule (Modified for Business)

| Category | % of Income | Example (₱30,000/mo) |
|----------|-------------|---------------------|
| Operating Costs | 50% | ₱15,000 |
| Growth/Investment | 30% | ₱9,000 |
| Emergency Fund | 20% | ₱6,000 |

## Tips para Magsimula

1. **Track lahat ng gastos** - Kahit barya lang
2. **Gumawa ng weekly review** - Tingnan kung on track
3. **Separate personal at business** - Very important!
''',
      ),
      LessonContent(
        id: 'fl-3',
        title: 'Quiz: Financial Basics',
        description: 'Test your knowledge!',
        type: ContentType.quiz,
        durationMinutes: 5,
        order: 3,
        content: 'Take this quiz to test what you learned!',
        quizQuestions: [
          QuizQuestion(
            question: 'Ano ang recommended na percentage ng income na i-save?',
            options: ['5%', '10%', '20%', '50%'],
            correctIndex: 2,
            explanation: 'Recommended na mag-save ng 20% ng income bago gumastos sa iba.',
          ),
          QuizQuestion(
            question: 'Ano ang tawag sa kakayahang maintindihan at magamit nang tama ang pera?',
            options: ['Accounting', 'Financial Literacy', 'Bookkeeping', 'Banking'],
            correctIndex: 1,
            explanation: 'Financial literacy ang kakayahang maintindihan at wisely na gamitin ang pera.',
          ),
          QuizQuestion(
            question: 'Bakit importante ang separate ang personal at business money?',
            options: [
              'Para mas madaling mag-track ng expenses',
              'Para alam mo kung kumikita ba talaga ang negosyo',
              'Para mas organized ang records',
              'Lahat ng nabanggit',
            ],
            correctIndex: 3,
            explanation: 'Lahat ng reasons na ito ay importante para sa healthy na business finances.',
          ),
        ],
      ),
    ],
  );

  /// Loan Application Guide module.
  static const loanApplicationGuide = LoanEducationModule(
    id: 'loan-app-guide',
    title: 'Loan Application Guide',
    description: 'Step-by-step guide sa pag-apply ng loan',
    category: EducationCategory.applications,
    iconName: 'description',
    colorValue: 0xFF5C6BC0,
    lessons: [
      LessonContent(
        id: 'lag-1',
        title: 'Mga Uri ng Loans para sa MSME',
        description: 'Alamin kung anong loan ang tamang para sa iyo',
        type: ContentType.article,
        durationMinutes: 12,
        order: 1,
        content: '''
# Mga Uri ng Loans para sa MSME

## 1. Working Capital Loan
Para sa **daily operations** ng negosyo
- Pambili ng stocks
- Pang-sweldo sa employees
- Usual na gastusin

**Ideal for:** Established businesses na need ng cash flow boost

## 2. Equipment Loan
Para sa **pagbili ng equipment/tools**
- Refrigerator para sa sari-sari store
- Sewing machine para sa tailoring
- Food cart para sa food business

**Ideal for:** Businesses na expanding

## 3. Microfinance Loan
Para sa **maliit na capital needs**
- Usually ₱5,000 - ₱50,000
- Mas mabilis na approval
- Alternative data accepted

**Ideal for:** New businesses or informal enterprises
''',
      ),
      LessonContent(
        id: 'lag-2',
        title: 'Paano Maghanda para sa Application',
        description: 'Documents at requirements checklist',
        type: ContentType.article,
        durationMinutes: 10,
        order: 2,
        content: '''
# Paano Maghanda para sa Application

## Required Documents Checklist

### Basic Requirements
✅ Valid Government ID
✅ Proof of Address (utility bill, barangay clearance)
✅ Recent photo (2x2)

### Business Documents
✅ DTI Registration (kung meron)
✅ Barangay Business Permit
✅ Sales records (kahit notebook lang)

### Financial Documents
✅ Bank statements (if meron)
✅ GCash/Maya transaction history
✅ Receipts ng regular customers

## Alternative Data na Pwedeng Gamitin

Hindi ka pa registered? Pwede pa rin!

- 📱 **Mobile wallet history** - GCash, Maya transactions
- 🛒 **Supplier receipts** - Proof of regular operations
- 👥 **Customer testimonials** - References from regular buyers
''',
      ),
    ],
  );

  /// Business Planning module.
  static const businessPlanning = LoanEducationModule(
    id: 'biz-planning',
    title: 'Business Planning',
    description: 'Gumawa ng solid na business plan',
    category: EducationCategory.growth,
    iconName: 'trending_up',
    colorValue: 0xFFEC407A,
    lessons: [
      LessonContent(
        id: 'bp-1',
        title: 'Bakit Kailangan ng Business Plan?',
        description: 'The importance of planning',
        type: ContentType.article,
        durationMinutes: 8,
        order: 1,
        content: '''
# Bakit Kailangan ng Business Plan?

## Ang Business Plan ay...

Hindi lang papel na ipapasa sa bank. Ito ang **guide** mo para:
- Malaman kung saan papunta ang negosyo
- Mag-prepare sa challenges
- Mas madaling makakuha ng loan

## Simple Business Plan Template

### 1. Executive Summary
Isang paragraph na nagsasabi kung ano ang negosyo mo.

### 2. Products/Services
Ano ang binebenta o serbisyo mo?

### 3. Target Customers
Sino ang mga bibili?

### 4. Competition
Sino ang kalaban mo? Paano ka mag-stand out?

### 5. Financial Projections
Magkano ang expected na kita at gastos?
''',
      ),
    ],
  );

  /// Smart Repayment module.
  static const smartRepayment = LoanEducationModule(
    id: 'smart-repay',
    title: 'Smart Repayment',
    description: 'Tips para makapag-bayad on time',
    category: EducationCategory.repayment,
    iconName: 'payments',
    colorValue: 0xFFFF7043,
    lessons: [
      LessonContent(
        id: 'sr-1',
        title: 'Repayment Strategies',
        description: 'Paano mag-manage ng loan payments',
        type: ContentType.article,
        durationMinutes: 10,
        order: 1,
        content: '''
# Repayment Strategies

## Golden Rules ng Loan Repayment

### 1. Never Miss a Payment
- Set reminders sa phone
- Auto-debit kung kaya
- Pay a day early para safe

### 2. Pay More Than Minimum
Kung kaya, dagdagan ang payment para:
- Mas mabilis matapos
- Mas mababa ang total interest

### 3. Emergency Fund First
Bago mag-loan, siguruhin may ipon ka for emergencies.

## Kung Nahihirapan Ka...

**DON'T**: Magtago o magpalit ng number
**DO**: Kausapin agad ang lender

Karamihan sa lenders ay may:
- Restructuring options
- Grace periods
- Payment plan adjustments
''',
      ),
    ],
  );
}
