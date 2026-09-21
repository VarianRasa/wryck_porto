import 'package:flutter/material.dart';

import '../models/portfolio_models.dart';

const profileSummary =
    'lulusan Sistem Informasi dari UPN Veteran Jakarta dengan minat pada '
    'UI/UX Design, Mobile Development, Web Development, Database Management, '
    'dan Data Analytics. Terbiasa berkolaborasi, beradaptasi, berkomunikasi, '
    'serta memecahkan masalah untuk membangun solusi yang berpusat pada '
    'pengguna dan berbasis data.';

const profileSummaryEn =
    'Bachelor of Information Systems graduate from UPN Veteran Jakarta with '
    'interests in UI/UX Design, Mobile Development, Web Development, Database '
    'Management, and Data Analytics. Collaborative, adaptable, and analytical, '
    'with strong communication and problem-solving skills for user-centered and '
    'data-driven solutions.';

const profileHeadlineId =
    'Lulusan Sistem Informasi | UI/UX | Mobile, Web & Data';

const profileHeadlineEn =
    'Information Systems Graduate | UI/UX | Mobile, Web & Data';

const currentlyExploring = [
  'Mobile Development',
  'Data Engineering',
  'UI/UX Design',
];

final contactActions = <ContactAction>[
  const ContactAction(
    label: 'Lokasi',
    value: 'Jakarta Selatan',
    icon: Icons.location_on_outlined,
  ),
  ContactAction(
    label: 'Telepon',
    value: '+62 817-7415-8611',
    icon: Icons.phone_outlined,
    uri: Uri.parse('https://wa.me/6281774158611'),
  ),
  ContactAction(
    label: 'Email',
    value: 'm.varianwarrick04@gmail.com',
    icon: Icons.mail_outline,
    uri: Uri.https('mail.google.com', '/mail/', {
      'view': 'cm',
      'fs': '1',
      'to': 'm.varianwarrick04@gmail.com',
    }),
  ),
  ContactAction(
    label: 'LinkedIn',
    value: 'linkedin.com/in/muhammad-varian-warrick',
    icon: Icons.work_outline,
    uri: Uri.parse(
      'https://www.linkedin.com/in/muhammad-varian-warrick-4887431b7/',
    ),
  ),
  ContactAction(
    label: 'CV',
    value: 'Buka CV PDF',
    icon: Icons.picture_as_pdf_outlined,
    uri: Uri.base.resolve('cv_muhammad_varian_warrick.pdf'),
  ),
];

final portfolioSections = <PortfolioSection>[
  const PortfolioSection(
    id: 'education',
    title: 'PENDIDIKAN',
    titleEn: 'EDUCATION',
    entrySlugs: ['upnvj-information-system'],
  ),
  const PortfolioSection(
    id: 'internship',
    title: 'INTERNSHIP EXPERIENCE',
    titleEn: 'INTERNSHIP EXPERIENCE',
    entrySlugs: ['jakarta-smart-city-internship'],
  ),
  const PortfolioSection(
    id: 'projects',
    title: 'PROJECT EXPERIENCE',
    titleEn: 'PROJECT EXPERIENCE',
    entrySlugs: [
      'chemtwist-application-ui',
      'necliv-application',
      'data-warehouse-olap',
      'smart-employee-jsc-redesign',
    ],
  ),
  const PortfolioSection(
    id: 'volunteering',
    title: 'VOLUNTEERING EXPERIENCE',
    titleEn: 'VOLUNTEERING EXPERIENCE',
    entrySlugs: ['mabim-fik-upnvj'],
  ),
  const PortfolioSection(
    id: 'skills',
    title: 'SKILLS, INTEREST, AND OTHER EXPERIENCE',
    titleEn: 'SKILLS, INTEREST, AND OTHER EXPERIENCE',
    entrySlugs: ['skills', 'interests', 'certification'],
  ),
  const PortfolioSection(
    id: 'extra',
    title: 'EXTRA QUALIFICATION',
    titleEn: 'EXTRA QUALIFICATION',
    entrySlugs: ['tools', 'languages'],
  ),
];

const featuredProjectSlugs = [
  'smart-employee-jsc-redesign',
  'data-warehouse-olap',
  'necliv-application',
];

const projectFilters = <ProjectFilter>[
  ProjectFilter(
    id: 'all',
    label: 'All',
    projectSlugs: [
      'chemtwist-application-ui',
      'necliv-application',
      'data-warehouse-olap',
      'smart-employee-jsc-redesign',
    ],
  ),
  ProjectFilter(
    id: 'uiux',
    label: 'UI/UX',
    projectSlugs: [
      'chemtwist-application-ui',
      'necliv-application',
      'smart-employee-jsc-redesign',
    ],
  ),
  ProjectFilter(
    id: 'data',
    label: 'Data',
    projectSlugs: ['data-warehouse-olap'],
  ),
  ProjectFilter(
    id: 'mobile-web',
    label: 'Mobile/Web',
    projectSlugs: ['chemtwist-application-ui', 'necliv-application'],
  ),
  ProjectFilter(
    id: 'internship',
    label: 'Internship',
    projectSlugs: ['smart-employee-jsc-redesign'],
  ),
];

final portfolioEntries = <PortfolioEntry>[
  PortfolioEntry(
    slug: 'profile',
    kind: PortfolioEntryKind.profile,
    title: 'Muhammad Varian Warrick',
    titleEn: 'Muhammad Varian Warrick',
    subtitle: 'Lulusan Sistem Informasi',
    subtitleEn: 'Information Systems graduate | UI/UX & Data',
    location: 'Jakarta Selatan, Indonesia',
    summary: profileSummary,
    summaryEn: profileSummaryEn,
    detailParagraphs: const [
      'Muhammad Varian Warrick adalah lulusan Sistem Informasi dari Fakultas '
          'Ilmu Komputer UPN Veteran Jakarta. Fokusnya berada pada pengembangan '
          'sistem informasi, antarmuka pengguna, dan pemanfaatan data untuk '
          'mendukung keputusan.',
      'Melalui proyek, internship, dan pengalaman organisasi, ia mengembangkan '
          'kemampuan komunikasi, adaptasi, problem solving, serta kolaborasi '
          'lintas fungsi. Area yang paling diminati meliputi UI/UX Design, '
          'Mobile Development, Web Development, Database Management, dan Data Analytics.',
    ],
    detailParagraphsEn: const [
      'Muhammad Varian Warrick is an Information Systems graduate from the '
          'Faculty of Computer Science, UPN Veteran Jakarta. His focus covers '
          'information systems, user interfaces, and data-driven decision support.',
      'Through projects, internship experience, and volunteering, he developed '
          'communication, adaptation, problem-solving, and cross-functional '
          'collaboration skills.',
    ],
    tags: const [
      'Information Systems',
      'Mobile Developer',
      'Web Developer',
      'UI/UX',
      'Data',
    ],
  ),
  PortfolioEntry(
    slug: 'upnvj-information-system',
    kind: PortfolioEntryKind.education,
    title: 'Universitas Pembangunan Nasional Veteran Jakarta',
    titleEn: 'Universitas Pembangunan Nasional Veteran Jakarta',
    subtitle: 'Bachelor of Information Systems',
    subtitleEn: 'Bachelor of Information Systems',
    period: 'Jul 2022 - Sept 2026',
    location: 'DKI Jakarta, Indonesia',
    summary:
        'Lulusan Sistem Informasi dengan GPA 3.89/4.00 dan fokus pada UI/UX, '
        'mobile development, web development, database management, dan data analytics.',
    summaryEn:
        'Information Systems graduate with a GPA of 3.89/4.00, focused on '
        'UI/UX, mobile development, web development, database management, and data analytics.',
    bullets: const [
      'GPA: 3.89/4.00.',
      'Relevant courses: UI/UX Design, Data Engineering, Human-Computer Interaction, Database Systems, Data Structures and Algorithms, Web Programming, Mobile Development.',
    ],
    bulletsEn: const [
      'GPA: 3.89/4.00.',
      'Relevant courses: UI/UX Design, Data Engineering, Human-Computer Interaction, Database Systems, Data Structures and Algorithms, Web Programming, Mobile Development.',
    ],
    detailParagraphs: const [
      'Program studi Sistem Informasi membentuk fondasi teknis dan analitis '
          'untuk memahami bagaimana kebutuhan pengguna, proses bisnis, '
          'database, dan aplikasi saling terhubung dalam sebuah sistem.',
      'Mata kuliah yang relevan memperkuat kemampuan pada UI/UX Design, '
          'Data Engineering, Human-Computer Interaction, Database Systems, '
          'Data Structures and Algorithms, Web Programming, serta Mobile Development.',
    ],
    detailParagraphsEn: const [
      'The Information Systems program builds technical and analytical '
          'foundations for connecting user needs, business processes, '
          'databases, and application development.',
      'Relevant courses strengthened understanding of UI/UX Design, Data '
          'Engineering, Human-Computer Interaction, Database Systems, Algorithms, '
          'Web Programming, and Mobile Development.',
    ],
    tags: const [
      'GPA 3.89/4.00',
      'Data Engineering',
      'HCI',
      'Database',
      'Flutter',
    ],
  ),
  PortfolioEntry(
    slug: 'jakarta-smart-city-internship',
    kind: PortfolioEntryKind.internship,
    title: 'Intern',
    titleEn: 'Intern',
    subtitle: 'Jakarta Smart City',
    period: 'Sept 2024 - Jan 2025',
    summary:
        'Terlibat dalam review dan redesign sistem Smart Employee JSC untuk '
        'meningkatkan usability, performa, dan kualitas pengalaman pengguna.',
    summaryEn:
        'Involved in reviewing and redesigning the Smart Employee JSC system '
        'to improve usability, performance, and the overall user experience.',
    bullets: const [
      'Terlibat dalam review dan redesign sistem Smart Employee JSC.',
      'Berkontribusi meningkatkan usability dan performance melalui prinsip UI/UX modern dan kolaborasi lintas fungsi.',
    ],
    bulletsEn: const [
      'Involved in the review and redesign of the Smart Employee JSC system.',
      'Contributed to improving usability and performance through modern UI/UX principles and cross-functional collaboration.',
    ],
    detailParagraphs: const [
      'Selama internship di Jakarta Smart City, fokus pekerjaan berada pada '
          'peninjauan sistem Smart Employee JSC dan perancangan ulang modul '
          'serta alur kerja yang membutuhkan peningkatan pengalaman pengguna.',
      'Kontribusi utama mencakup identifikasi isu usability, penyusunan arah '
          'redesign, dan penerapan prinsip UI/UX modern agar sistem lebih '
          'mudah dipahami serta lebih responsif terhadap kebutuhan pengguna.',
    ],
    detailParagraphsEn: const [
      'During the Jakarta Smart City internship, the work focused on reviewing '
          'Smart Employee JSC and redesigning modules and workflows that needed '
          'a clearer user experience.',
      'The contribution included identifying usability issues, shaping redesign '
          'directions, and applying modern UI/UX principles to make the system '
          'easier to understand and use.',
    ],
    tags: const ['UI/UX', 'System Review', 'Redesign', 'Collaboration'],
  ),
  PortfolioEntry(
    slug: 'chemtwist-application-ui',
    kind: PortfolioEntryKind.project,
    title: 'ChemTwist Application UI',
    titleEn: 'ChemTwist Application UI',
    subtitle: 'UPNVJ',
    period: 'Mei 2022 - Juni 2022',
    summary:
        'Merancang UI/UX menu aplikasi ChemTwist untuk halaman Login, Register, dan Play menggunakan Figma.',
    summaryEn:
        'Designed the ChemTwist application UI/UX menu for Login, Register, '
        'and Play pages using Figma.',
    bullets: const [
      'Membuat UI/UX Menu Display untuk Login Page, Register Page, dan Play Page.',
      'Membuat Application Interface untuk tampilan ChemTwist dengan Figma.',
    ],
    bulletsEn: const [
      'Created the UI/UX menu display for Login Page, Register Page, and Play Page.',
      'Created the application interface for the ChemTwist display with Figma.',
    ],
    detailParagraphs: const [
      'ChemTwist Application UI adalah proyek perancangan antarmuka untuk '
          'menampilkan alur dasar aplikasi, mulai dari masuk, mendaftar, '
          'hingga halaman bermain.',
      'Pekerjaan berfokus pada penyusunan tampilan yang jelas, konsisten, dan '
          'mudah diikuti oleh pengguna. Figma digunakan sebagai alat utama '
          'untuk membangun rancangan visual dan struktur layar.',
    ],
    detailParagraphsEn: const [
      'ChemTwist Application UI was an interface design project covering core '
          'application flows from login and registration to the play screen.',
      'The work focused on building clear, consistent screens in Figma so the '
          'application flow could be understood quickly by users.',
    ],
    categories: const ['UI/UX', 'Mobile/Web'],
    outcomes: const [
      'Rancangan layar utama aplikasi tersusun untuk Login, Register, dan Play.',
      'Alur visual aplikasi lebih mudah dipahami sebelum masuk tahap implementasi.',
    ],
    learnings: const [
      'Menyusun hierarchy visual untuk flow aplikasi sederhana.',
      'Menjaga konsistensi komponen antar halaman di Figma.',
    ],
    tags: const ['Figma', 'UI/UX', 'Login Page', 'Register Page', 'Play Page'],
  ),
  PortfolioEntry(
    slug: 'necliv-application',
    kind: PortfolioEntryKind.project,
    title: 'Necliv Application',
    titleEn: 'Necliv Application',
    subtitle: 'HACKFEST',
    period: 'Februari 2023',
    summary:
        'Membuat UI/UX menu Necliv berisi Learn Page, Community Page, Career Page, dan Profile Page dengan FlutterFlow.',
    summaryEn:
        'Created the Necliv UI/UX menu containing Learn, Community, Career, '
        'and Profile pages with FlutterFlow.',
    bullets: const [
      'Membuat UI/UX Menu Display untuk Learn Page, Community Page, Career Page, dan Profile Page.',
      'Membuat Application Interface untuk tampilan Necliv dengan FlutterFlow.',
    ],
    bulletsEn: const [
      'Created the UI/UX menu display for Learn Page, Community Page, Career Page, and Profile Page.',
      'Created the application interface for the Necliv display with FlutterFlow.',
    ],
    detailParagraphs: const [
      'Necliv Application dikembangkan dalam konteks HACKFEST sebagai rancangan '
          'aplikasi dengan beberapa area utama: belajar, komunitas, karier, '
          'dan profil pengguna.',
      'Kontribusi pada proyek ini menitikberatkan pada perancangan alur layar '
          'dan struktur navigasi. FlutterFlow digunakan untuk membantu '
          'membangun tampilan antarmuka secara cepat dan konsisten.',
    ],
    detailParagraphsEn: const [
      'Necliv Application was developed in the HACKFEST context as an app '
          'concept with learning, community, career, and profile areas.',
      'The contribution emphasized screen flow and navigation structure while '
          'using FlutterFlow to assemble a consistent application interface.',
    ],
    categories: const ['UI/UX', 'Mobile/Web'],
    outcomes: const [
      'Struktur layar utama Necliv tersusun untuk kebutuhan belajar, komunitas, karier, dan profil.',
      'Prototype antarmuka dapat dikembangkan cepat dengan FlutterFlow.',
    ],
    learnings: const [
      'Membagi fitur aplikasi ke dalam navigasi yang mudah dipindai.',
      'Menggunakan FlutterFlow untuk mempercepat validasi tampilan.',
    ],
    tags: const ['FlutterFlow', 'UI/UX', 'Learn Page', 'Community', 'Career'],
  ),
  PortfolioEntry(
    slug: 'data-warehouse-olap',
    kind: PortfolioEntryKind.project,
    title: 'Project Data Warehouse and OLAP',
    titleEn: 'Data Warehouse and OLAP Project',
    subtitle: 'UPNVJ',
    period: '16 Maret - 29 Maret 2023',
    summary:
        'Menyelesaikan implementasi data warehouse dan OLAP, termasuk desain database, ETL, dan analisis data dengan Pentaho Data Integration.',
    summaryEn:
        'Completed data warehouse and OLAP implementation, including database '
        'design, ETL processes, and data analysis with Pentaho Data Integration.',
    bullets: const [
      'Menyelesaikan implementasi end-to-end data warehouse dan OLAP solution.',
      'Melakukan database design dan ETL process menggunakan Pentaho Data Integration.',
      'Melakukan data analysis untuk mengekstraksi insight dan mendukung decision-making process.',
    ],
    bulletsEn: const [
      'Completed end-to-end implementation of a data warehouse and OLAP solution.',
      'Designed the database and ETL process using Pentaho Data Integration.',
      'Conducted data analysis to extract insights and support decision-making processes.',
    ],
    detailParagraphs: const [
      'Proyek Data Warehouse and OLAP berfokus pada penyusunan solusi data '
          'end-to-end, mulai dari perancangan database, proses ETL, hingga '
          'analisis untuk menghasilkan insight.',
      'Pentaho Data Integration digunakan dalam proses ETL. Proyek ini '
          'memperkuat pemahaman tentang bagaimana data disiapkan, '
          'ditransformasikan, dan dianalisis untuk mendukung pengambilan '
          'keputusan.',
    ],
    detailParagraphsEn: const [
      'The Data Warehouse and OLAP project focused on building an end-to-end '
          'data solution from database design and ETL to analytical insight.',
      'Pentaho Data Integration supported the ETL workflow and strengthened '
          'understanding of how data is prepared, transformed, and analyzed.',
    ],
    categories: const ['Data'],
    outcomes: const [
      'Solusi data warehouse dan OLAP selesai dari desain database sampai ETL.',
      'Analisis data digunakan untuk mendukung proses pengambilan keputusan.',
    ],
    learnings: const [
      'Mendesain pipeline ETL dengan Pentaho Data Integration.',
      'Menghubungkan struktur data warehouse dengan kebutuhan analisis.',
    ],
    tags: const ['Data Warehouse', 'OLAP', 'ETL', 'Pentaho', 'Data Analysis'],
  ),
  PortfolioEntry(
    slug: 'smart-employee-jsc-redesign',
    kind: PortfolioEntryKind.project,
    title: 'Review/Redesign Smart Employee JSC',
    titleEn: 'Smart Employee JSC Review/Redesign',
    subtitle: 'Jakarta Smart City',
    period: '24 Sept 2024 - 10 Jan 2025',
    summary:
        'Melakukan review dan redesign Smart Employee JSC untuk meningkatkan UX, scalability, performance, dan responsivitas desain.',
    summaryEn:
        'Reviewed and redesigned Smart Employee JSC to improve UX, scalability, '
        'performance, and responsive design quality.',
    bullets: const [
      'Redesign core modules dan workflows untuk meningkatkan user experience, system scalability, dan performance.',
      'Melakukan review menyeluruh terhadap sistem untuk menemukan inefficiencies, usability issues, dan gaps in functionality.',
      'Membuat interface menggunakan Figma untuk mendukung redesign.',
    ],
    bulletsEn: const [
      'Redesigned core modules and workflows to improve user experience, system scalability, and performance.',
      'Reviewed the existing system to identify inefficiencies, usability issues, and functionality gaps.',
      'Created interfaces in Figma to support the redesign.',
    ],
    detailParagraphs: const [
      'Review/Redesign Smart Employee JSC adalah proyek yang berfokus pada '
          'penilaian sistem berjalan dan penyusunan perbaikan antarmuka serta '
          'alur kerja berdasarkan kebutuhan pengguna.',
      'Pekerjaan mencakup review modul inti, identifikasi isu usability, dan '
          'penyusunan desain responsif dengan prinsip UI/UX modern agar sistem '
          'lebih mudah digunakan serta lebih siap dikembangkan.',
    ],
    detailParagraphsEn: const [
      'Smart Employee JSC Review/Redesign focused on evaluating the existing '
          'system and improving interfaces and workflows based on user needs.',
      'The work included reviewing core modules, identifying usability issues, '
          'and shaping responsive design improvements using modern UI/UX '
          'principles.',
    ],
    categories: const ['UI/UX', 'Internship'],
    outcomes: const [
      'Core modules dan workflows memiliki arah redesign yang lebih responsif.',
      'Usability issues dan gaps in functionality terdokumentasi sebagai dasar perbaikan.',
    ],
    learnings: const [
      'Melakukan review sistem berdasarkan kebutuhan pengguna.',
      'Menyelaraskan prinsip UI/UX dengan konteks sistem internal organisasi.',
    ],
    tags: const ['Jakarta Smart City', 'UI/UX', 'Responsive Design', 'Review'],
  ),
  PortfolioEntry(
    slug: 'mabim-fik-upnvj',
    kind: PortfolioEntryKind.volunteering,
    title: 'Mabim FIK UPNVJ 2022',
    titleEn: 'Mabim FIK UPNVJ 2022',
    subtitle: 'BEM FIK UPNVJ - Event Committee',
    period: 'Oktober 2022',
    summary:
        'Menjadi event committee untuk kegiatan yang melibatkan 150+ peserta, termasuk fun games dan pembagian job description staff.',
    summaryEn:
        'Served as an event committee member for an activity involving 150+ participants, including fun games and staff job description planning.',
    bullets: const [
      'Mengorganisasi fun games untuk menjaga antusiasme 150+ peserta.',
      'Mendistribusikan job descriptions secara merata antar staff untuk workflow yang efisien.',
    ],
    bulletsEn: const [
      'Organized fun games to maintain enjoyment and enthusiasm for 150+ participants.',
      'Distributed job descriptions among staff to support an efficient workflow.',
    ],
    detailParagraphs: const [
      'Dalam kegiatan Mabim FIK UPNVJ 2022, peran sebagai event committee '
          'berfokus pada kelancaran aktivitas peserta dan koordinasi internal '
          'antar staff.',
      'Pengalaman ini memperkuat kemampuan teamwork, komunikasi, adaptasi, dan '
          'pengelolaan tugas dalam konteks kegiatan dengan jumlah peserta yang '
          'besar.',
    ],
    detailParagraphsEn: const [
      'In Mabim FIK UPNVJ 2022, the event committee role focused on supporting participant activities and coordinating responsibilities among staff.',
      'This experience strengthened teamwork, communication, adaptation, and task coordination in a large participant setting.',
    ],
    tags: const ['Event Committee', 'Teamwork', '150+ peserta', 'Coordination'],
  ),
  PortfolioEntry(
    slug: 'skills',
    kind: PortfolioEntryKind.skill,
    title: 'Skills',
    titleEn: 'Skills',
    summary:
        'Teamwork, Adaptation, Problem Solving, Figma, serta bahasa pemrograman Python, HTML, CSS, JS, Dart, dan Flutter.',
    summaryEn:
        'Teamwork, adaptation, problem solving, Figma, and Python, HTML, CSS, JS, and Dart, with Flutter as a framework.',
    bullets: const [
      'Teamwork; Adaptation; Problem Solving; Figma.',
      'Programming Language: Python, HTML, CSS, JS, Dart; Flutter (framework).',
    ],
    bulletsEn: const [
      'Teamwork; Adaptation; Problem Solving; Figma.',
      'Programming languages: Python, HTML, CSS, JS, and Dart; Flutter framework.',
    ],
    detailParagraphs: const [
      'Skill utama mencakup kemampuan kerja tim, adaptasi, problem solving, '
          'dan penggunaan Figma untuk mendukung proses desain antarmuka.',
      'Pada sisi teknis, pengalaman belajar dan proyek mencakup Python, HTML, '
          'CSS, JavaScript, Dart, serta Flutter sebagai framework untuk '
          'pengembangan aplikasi.',
    ],
    detailParagraphsEn: const [
      'Core skills include teamwork, adaptation, problem solving, and Figma for supporting UI/UX design processes.',
      'Technical exposure includes Python, HTML, CSS, JavaScript, PHP, Dart, and Flutter for application development.',
    ],
    tags: const ['Teamwork', 'Problem Solving', 'Figma', 'Dart', 'Flutter'],
  ),
  PortfolioEntry(
    slug: 'interests',
    kind: PortfolioEntryKind.skill,
    title: 'Interest',
    titleEn: 'Interest',
    summary:
        'UI/UX Designer, Mobile Developer, Web Developer, Data Analyst, dan Database Management.',
    summaryEn:
        'UI/UX Designer, Mobile Developer, Web Developer, Data Analyst, and Database Management.',
    bullets: const [
      'UI/UX Designer; Mobile Developer; Web Developer.',
      'Data Analyst; Database Management.',
    ],
    bulletsEn: const [
      'UI/UX Designer; Mobile Developer; Web Developer.',
      'Data Analyst; Database Management.',
    ],
    detailParagraphs: const [
      'Area minat menggabungkan perancangan pengalaman pengguna, pengembangan '
          'aplikasi mobile dan web, serta pengelolaan dan analisis database.',
    ],
    detailParagraphsEn: const [
      'The interest areas combine user experience design, mobile and web '
          'development, and database management and analysis.',
    ],
    tags: const [
      'UI/UX',
      'Mobile',
      'Web',
      'Data Analyst',
      'Database Management',
    ],
  ),
  PortfolioEntry(
    slug: 'certification',
    kind: PortfolioEntryKind.certification,
    title: 'Certification',
    titleEn: 'Certification',
    summary:
        'Code Generations and Optimization, Generative AI, IBM Granite, dan Junior Web Programmer certificates.',
    summaryEn:
        'Code Generations and Optimization, Generative AI, IBM Granite, and Junior Web Programmer certificates.',
    bullets: const [
      'Code Generations and Optimization Certificate.',
      'Use Generative AI for Software Development Certificate.',
      'Code Generation and Optimization Using IBM Granite Certificate.',
      'IBM Granite Models for Software Development Certificate.',
      'Junior Web Programmer Certificate.',
    ],
    bulletsEn: const [
      'Code Generations and Optimization Certificate.',
      'Use Generative AI for Software Development Certificate.',
      'Code Generation and Optimization Using IBM Granite Certificate.',
      'IBM Granite Models for Software Development Certificate.',
      'Junior Web Programmer Certificate.',
    ],
    detailParagraphs: const [
      'Sertifikasi mencakup pengembangan web, optimasi kode, dan pemanfaatan '
          'generative AI serta IBM Granite untuk software development.',
    ],
    detailParagraphsEn: const [
      'The certifications cover web development, code optimization, and the use '
          'of generative AI and IBM Granite for software development.',
    ],
    tags: const ['Generative AI', 'IBM Granite', 'Web Development'],
  ),
  PortfolioEntry(
    slug: 'tools',
    kind: PortfolioEntryKind.tools,
    title: 'Tools',
    titleEn: 'Tools',
    summary:
        'VS Code, Figma, Microsoft Office, Google Workspace, dan AI Agent seperti Claude Code dan Codex.',
    summaryEn:
        'VS Code, Figma, Microsoft Office, Google Workspace, and AI agents such as Claude Code and Codex.',
    bullets: const [
      'VS Code, Figma.',
      'Microsoft Office: Word, PowerPoint.',
      'Google Workspace: Docs, Slides.',
      'AI Agent: Claude Code, Codex, dan tools sejenis.',
    ],
    bulletsEn: const [
      'VS Code, Figma.',
      'Microsoft Office: Word, PowerPoint.',
      'Google Workspace: Docs, Slides.',
      'AI agents: Claude Code, Codex, and similar tools.',
    ],
    detailParagraphs: const [
      'Tools yang digunakan mencakup VS Code untuk pengembangan, Figma untuk '
          'desain UI/UX, Microsoft Office dan Google Workspace untuk dokumentasi '
          'serta kolaborasi, dan AI Agent seperti Claude Code dan Codex.',
    ],
    detailParagraphsEn: const [
      'The tools include VS Code for development, Figma for UI/UX design, '
          'Microsoft Office and Google Workspace for documentation and '
          'collaboration, and AI agents such as Claude Code and Codex.',
    ],
    tags: const [
      'VS Code',
      'Figma',
      'Microsoft Office',
      'Google Workspace',
      'AI Agent',
    ],
  ),
  PortfolioEntry(
    slug: 'languages',
    kind: PortfolioEntryKind.language,
    title: 'Language',
    titleEn: 'Language',
    summary: 'Indonesia (Native) dan English (Basic).',
    summaryEn: 'Indonesian (Native) and English (Basic).',
    bullets: const ['Indonesia (Native).', 'English (Basic).'],
    bulletsEn: const ['Indonesian (Native).', 'English (Basic).'],
    detailParagraphs: const [
      'Kemampuan bahasa yang tercantum dalam CV adalah Bahasa Indonesia pada '
          'level native dan Bahasa Inggris pada level basic.',
    ],
    detailParagraphsEn: const [
      'The listed language skills are Indonesian at native level and English at basic level.',
    ],
    tags: const ['Indonesia', 'English'],
  ),
];

final portfolioEntryBySlug = {
  for (final entry in portfolioEntries) entry.slug: entry,
};
