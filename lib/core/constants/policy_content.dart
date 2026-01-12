/// MSME Pathways - Policy Content Constants
/// 
/// Centralized Terms of Service and Privacy Policy content.
/// 
/// [CUSTOMIZE] markers indicate sections that require legal review
/// before production deployment.
library;

import '../../data/models/policy_section_model.dart';

/// Policy content constants for MSME Pathways.
/// 
/// Contains all text content for Terms of Service and Privacy Policy.
/// Designed for easy updates and localization.
abstract final class PolicyContent {
  // ============================================================
  // VERSION INFORMATION
  // ============================================================
  
  /// Current policy version - update when content changes.
  /// [CUSTOMIZE] Set appropriate version number.
  static const String policyVersion = '1.0.0';
  
  /// Last updated date for policies.
  /// [CUSTOMIZE] Update when policy content is modified.
  static final DateTime lastUpdated = DateTime(2026, 1, 1);
  
  /// Effective date text for display.
  static const String effectiveDate = 'January 1, 2026';

  // ============================================================
  // CONTACT INFORMATION
  // ============================================================
  
  /// [CUSTOMIZE] Company name for legal documents.
  static const String companyName = 'MSME Pathways Inc.';
  
  /// [CUSTOMIZE] Support email address.
  static const String supportEmail = 'support@msmepathways.ph';
  
  /// [CUSTOMIZE] Data Protection Officer email.
  static const String dpoEmail = 'dpo@msmepathways.ph';
  
  /// [CUSTOMIZE] Company address.
  static const String companyAddress = 
      '[CUSTOMIZE] Company Address, City, Philippines';
  
  /// [CUSTOMIZE] Website URL.
  static const String websiteUrl = 'https://msmepathways.ph';

  // ============================================================
  // TERMS OF SERVICE SECTIONS
  // ============================================================
  
  /// Complete Terms of Service content organized by section.
  static const List<PolicySectionModel> termsOfServiceSections = [
    // Section 1: Acceptance of Terms
    PolicySectionModel(
      id: 'tos_1',
      title: '1. Acceptance of Terms',
      content: '''By downloading, installing, or using the MSME Pathways mobile application ("App"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree to these Terms, please do not use the App.

These Terms constitute a legally binding agreement between you and $companyName ("we," "us," or "our"). We reserve the right to modify these Terms at any time, and such modifications will be effective immediately upon posting.

[CUSTOMIZE] Review with legal counsel for jurisdiction-specific requirements.''',
    ),
    
    // Section 2: Description of Service
    PolicySectionModel(
      id: 'tos_2',
      title: '2. Description of Service',
      content: '''MSME Pathways is an AI-powered financial inclusion platform designed to assist Filipino microentrepreneurs ("MSMEs") in accessing formal financial services.

Our services include:
• AI-assisted loan pre-qualification guidance
• Financial literacy education modules
• Alternative credit assessment tools
• Personalized recommendations for loan products
• Connection to partner lending institutions

IMPORTANT DISCLAIMER: MSME Pathways is an informational and educational platform only. We do NOT provide loans directly, make lending decisions, or guarantee loan approval from any financial institution.

[CUSTOMIZE] Update service descriptions as features evolve.''',
    ),
    
    // Section 3: User Eligibility
    PolicySectionModel(
      id: 'tos_3',
      title: '3. User Eligibility and Account Registration',
      content: '''To use MSME Pathways, you must:
• Be at least 18 years of age
• Be a legal resident of the Philippines
• Own or operate a micro, small, or medium enterprise
• Have a valid mobile phone number
• Provide accurate and complete registration information

You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.

[CUSTOMIZE] Verify age and residency requirements with legal team.''',
    ),
    
    // Section 4: AI-Powered Features
    PolicySectionModel(
      id: 'tos_4',
      title: '4. AI-Powered Features and Limitations',
      content: '''Our App uses artificial intelligence and machine learning technologies to provide personalized guidance. You acknowledge and understand that:

1. AI-Generated Recommendations: Our AI assistant provides suggestions based on the information you provide. These are educational recommendations, not financial advice.

2. Accuracy Limitations: While we strive for accuracy, AI-generated content may contain errors or may not account for all factors relevant to your situation.

3. Not a Substitute for Professional Advice: Our AI features do not replace guidance from qualified financial advisors, accountants, or legal professionals.

4. Continuous Improvement: Our AI models are regularly updated and improved, which may result in different recommendations over time.

5. Human Oversight: Critical decisions should be reviewed by human professionals before taking action.

[CUSTOMIZE] Review AI disclosure requirements under applicable regulations.''',
    ),
    
    // Section 5: Loan Information Disclaimers
    PolicySectionModel(
      id: 'tos_5',
      title: '5. Loan Information and Disclaimers',
      content: '''IMPORTANT DISCLAIMERS:

1. No Guarantee of Approval: Pre-qualification through our App does NOT guarantee loan approval from any lending institution.

2. Lender Independence: All loan decisions are made solely by our partner lenders based on their own criteria. We have no control over lending decisions.

3. Interest Rates and Terms: All interest rates, fees, and loan terms are set by individual lenders and may vary based on your profile and market conditions.

4. Alternative Credit Scoring: Our alternative credit assessment is supplementary information only. Lenders may use additional criteria for their decisions.

5. No Financial Advice: Information provided through the App is for educational purposes only and should not be considered financial, legal, or tax advice.

Bangko Sentral ng Pilipinas (BSP) Notice: [CUSTOMIZE] Insert applicable BSP disclosure requirements.''',
    ),
    
    // Section 6: Data Collection
    PolicySectionModel(
      id: 'tos_6',
      title: '6. Data Collection and Usage',
      content: '''By using our App, you consent to the collection and processing of your data as described in our Privacy Policy.

Data we may collect includes:
• Personal identification information
• Business information
• Financial data you choose to provide
• Device information and usage data
• Alternative data for credit assessment (with your explicit consent)

Your data is processed in accordance with the Philippine Data Privacy Act of 2012 (Republic Act No. 10173).

For complete details, please review our Privacy Policy.''',
    ),
    
    // Section 7: User Responsibilities
    PolicySectionModel(
      id: 'tos_7',
      title: '7. User Responsibilities',
      content: '''As a user of MSME Pathways, you agree to:

1. Provide accurate, current, and complete information
2. Update your information promptly when changes occur
3. Not misrepresent your identity or business
4. Use the App only for lawful purposes
5. Not attempt to circumvent or manipulate our systems
6. Protect your account credentials from unauthorized access
7. Notify us immediately of any security breaches
8. Comply with all applicable laws and regulations

Failure to comply with these responsibilities may result in account suspension or termination.''',
    ),
    
    // Section 8: Prohibited Activities
    PolicySectionModel(
      id: 'tos_8',
      title: '8. Prohibited Activities',
      content: '''You may NOT use MSME Pathways to:

• Submit false, misleading, or fraudulent information
• Impersonate another person or entity
• Engage in money laundering or terrorist financing
• Violate any applicable laws or regulations
• Attempt to gain unauthorized access to our systems
• Reverse engineer or decompile the App
• Use automated systems to access the App without permission
• Harass, threaten, or harm other users or our staff
• Distribute malware or viruses
• Engage in any activity that disrupts our services

Violations may result in immediate termination and reporting to authorities.''',
    ),
    
    // Section 9: Intellectual Property
    PolicySectionModel(
      id: 'tos_9',
      title: '9. Intellectual Property Rights',
      content: '''All content, features, and functionality of MSME Pathways are owned by $companyName and are protected by Philippine and international intellectual property laws.

This includes:
• App design and user interface
• Logos, trademarks, and branding
• AI algorithms and models
• Educational content and materials
• Software code and architecture

You may not copy, modify, distribute, or create derivative works without our express written permission.

You retain ownership of the data you submit, subject to the license granted in these Terms for us to provide our services.''',
    ),
    
    // Section 10: Limitation of Liability
    PolicySectionModel(
      id: 'tos_10',
      title: '10. Limitation of Liability',
      content: '''TO THE MAXIMUM EXTENT PERMITTED BY LAW:

1. MSME Pathways is provided "AS IS" without warranties of any kind, express or implied.

2. We do not warrant that the App will be uninterrupted, error-free, or completely secure.

3. We are not liable for any decisions made based on information provided through the App.

4. We are not responsible for actions taken by third-party lenders or partners.

5. Our total liability shall not exceed the amount you paid for our services (if any) in the 12 months preceding the claim.

6. We are not liable for indirect, incidental, consequential, or punitive damages.

[CUSTOMIZE] Review liability limitations with legal counsel.''',
    ),
    
    // Section 11: Service Modifications
    PolicySectionModel(
      id: 'tos_11',
      title: '11. Service Modifications',
      content: '''We reserve the right to:

• Modify, suspend, or discontinue any part of our services at any time
• Update these Terms with reasonable notice
• Change our fee structure (if applicable) with advance notice
• Add or remove features from the App
• Update our AI models and algorithms

We will make reasonable efforts to notify you of significant changes through the App or via email.

Continued use of the App after changes constitutes acceptance of the modified Terms.''',
    ),
    
    // Section 12: Termination
    PolicySectionModel(
      id: 'tos_12',
      title: '12. Termination of Service',
      content: '''Account Termination:
• You may terminate your account at any time through the App settings
• We may suspend or terminate your account for violations of these Terms
• We may terminate inactive accounts after 12 months of inactivity

Effects of Termination:
• Access to the App will be revoked
• Your data will be handled according to our Privacy Policy
• Certain provisions of these Terms will survive termination
• You may request deletion of your personal data, subject to legal retention requirements

[CUSTOMIZE] Specify data retention periods after termination.''',
    ),
    
    // Section 13: Governing Law
    PolicySectionModel(
      id: 'tos_13',
      title: '13. Governing Law',
      content: '''These Terms shall be governed by and construed in accordance with the laws of the Republic of the Philippines.

Dispute Resolution:
Any disputes arising from these Terms or your use of the App shall be resolved through:

1. Good faith negotiation between the parties
2. Mediation through an accredited mediator
3. If unresolved, arbitration in accordance with Philippine arbitration laws
4. The courts of [CUSTOMIZE: Specify city], Philippines shall have jurisdiction

Class Action Waiver: You agree to resolve disputes with us on an individual basis and waive any right to participate in class action lawsuits.

[CUSTOMIZE] Review dispute resolution procedures with legal team.''',
    ),
    
    // Section 14: Contact Information
    PolicySectionModel(
      id: 'tos_14',
      title: '14. Contact Information',
      content: '''For questions about these Terms of Service:

$companyName
$companyAddress

Email: $supportEmail
Website: $websiteUrl

Data Protection Officer: $dpoEmail

For urgent matters relating to fraud or security, please contact us immediately at $supportEmail.

[CUSTOMIZE] Verify all contact information is accurate and monitored.''',
    ),
  ];

  // ============================================================
  // PRIVACY POLICY SECTIONS
  // ============================================================
  
  /// Complete Privacy Policy content organized by section.
  static const List<PolicySectionModel> privacyPolicySections = [
    // Section 1: Information We Collect
    PolicySectionModel(
      id: 'pp_1',
      title: '1. Information We Collect',
      content: '''We collect the following categories of information:

PERSONAL INFORMATION:
• Full name and contact details
• Date of birth and gender
• Government-issued ID numbers (for verification)
• Residential address
• Email address and phone number

FINANCIAL INFORMATION:
• Business revenue and expenses
• Existing loans and credit history (if available)
• Bank account details (for verification only)
• Income sources and documentation

ALTERNATIVE DATA (with your explicit consent):
• Mobile phone usage patterns
• Digital transaction history
• Social connections (anonymized)
• Utility payment history

DEVICE INFORMATION:
• Device type and operating system
• Unique device identifiers
• IP address and location data
• App usage statistics

[CUSTOMIZE] Ensure all data collection is compliant with RA 10173.''',
      subsections: [
        PolicySubsection(
          title: 'Personal Information',
          content: 'Basic identifying information needed for account creation and verification.',
        ),
        PolicySubsection(
          title: 'Financial Information',
          content: 'Business and financial data used for credit assessment.',
        ),
        PolicySubsection(
          title: 'Alternative Data',
          content: 'Non-traditional data sources that may help assess creditworthiness.',
        ),
      ],
    ),
    
    // Section 2: How We Use Your Information
    PolicySectionModel(
      id: 'pp_2',
      title: '2. How We Use Your Information',
      content: '''We use your information for the following purposes:

SERVICE DELIVERY:
• Creating and managing your account
• Providing personalized loan pre-qualification guidance
• Generating alternative credit assessments
• Delivering financial education content
• Connecting you with suitable lending partners

IMPROVEMENT AND DEVELOPMENT:
• Analyzing usage patterns to improve our services
• Training and refining our AI models
• Developing new features and products
• Conducting research (using anonymized data only)

LEGAL AND COMPLIANCE:
• Complying with regulatory requirements
• Preventing fraud and ensuring security
• Responding to legal requests
• Enforcing our Terms of Service

COMMUNICATION:
• Sending service-related notifications
• Providing customer support
• Sharing updates about policy changes
• Marketing communications (with your consent)

All data processing has a lawful basis under the Philippine Data Privacy Act.''',
    ),
    
    // Section 3: AI and Machine Learning
    PolicySectionModel(
      id: 'pp_3',
      title: '3. AI and Machine Learning Disclosure',
      content: '''MSME Pathways uses artificial intelligence and machine learning in the following ways:

CREDIT ASSESSMENT:
Our AI analyzes various data points to generate an alternative credit score. This is SUPPLEMENTARY INFORMATION only and does not replace traditional credit evaluation by lenders.

PERSONALIZED RECOMMENDATIONS:
Our AI assistant provides customized guidance based on your profile and goals.

HOW OUR AI WORKS:
1. Data Collection: We gather information you provide and data you consent to share
2. Pattern Analysis: Our models identify patterns associated with creditworthiness
3. Scoring: A numerical score is generated based on the analysis
4. Recommendations: Personalized suggestions are created for your situation

TRANSPARENCY COMMITMENTS:
• We explain the factors that influence your assessment
• You can request information about how decisions affecting you were made
• Our AI undergoes regular bias audits
• Human oversight is maintained for significant decisions

LIMITATIONS:
• AI-generated scores are probabilistic, not deterministic
• Models may not capture all relevant factors
• Results may vary as models are updated

[CUSTOMIZE] Ensure AI disclosures meet regulatory requirements.''',
    ),
    
    // Section 4: Data Sharing
    PolicySectionModel(
      id: 'pp_4',
      title: '4. Data Sharing and Third Parties',
      content: '''We may share your information with:

PARTNER LENDING INSTITUTIONS:
When you choose to apply for a loan, we share relevant information with our partner lenders to facilitate your application. This includes your profile data and alternative credit assessment.

SERVICE PROVIDERS:
We work with trusted third parties who help us operate our platform:
• Cloud hosting providers
• Analytics services
• Customer support tools
• Identity verification services

All service providers are contractually bound to protect your data.

LEGAL REQUIREMENTS:
We may disclose information when required by:
• Court orders or legal processes
• Government regulatory agencies
• Law enforcement authorities
• To protect our legal rights

WE DO NOT:
• Sell your personal data to third parties
• Share data for unrelated marketing purposes
• Provide data to unauthorized parties

DATA SHARING CONTROLS:
You can manage your data sharing preferences in the App settings. Limiting data sharing may affect the services we can provide.

[CUSTOMIZE] List specific partner categories and update as partnerships change.''',
    ),
    
    // Section 5: Data Security
    PolicySectionModel(
      id: 'pp_5',
      title: '5. Data Security Measures',
      content: '''We implement comprehensive security measures to protect your data:

TECHNICAL SAFEGUARDS:
• Encryption of data in transit and at rest
• Secure authentication protocols
• Regular security audits and penetration testing
• Firewall and intrusion detection systems
• Secure development practices

ORGANIZATIONAL MEASURES:
• Employee background checks
• Access controls and logging
• Regular security training
• Incident response procedures
• Data handling policies

PHYSICAL SECURITY:
• Secure data center facilities
• Access monitoring and controls
• Environmental protections

BREACH NOTIFICATION:
In the event of a data breach that may affect your personal information, we will:
1. Notify affected users within 72 hours
2. Report to the National Privacy Commission as required
3. Implement remediation measures
4. Provide guidance on protective steps

While we take extensive precautions, no system is completely secure. We encourage you to protect your account credentials and report any suspicious activity.

[CUSTOMIZE] Update security measures as technology evolves.''',
    ),
    
    // Section 6: Data Retention
    PolicySectionModel(
      id: 'pp_6',
      title: '6. Data Retention',
      content: '''We retain your data based on the following criteria:

ACTIVE ACCOUNTS:
Data is retained as long as your account is active and needed to provide services.

AFTER ACCOUNT CLOSURE:
• Transaction records: 10 years (as required by law)
• Identity verification data: 5 years
• Usage logs: 2 years
• Marketing preferences: Deleted upon request

LEGAL REQUIREMENTS:
Certain data may be retained longer to comply with:
• Anti-Money Laundering regulations
• Tax requirements
• Legal proceedings
• Regulatory audits

ANONYMIZED DATA:
Anonymized and aggregated data may be retained indefinitely for research and improvement purposes.

DATA DELETION:
You may request deletion of your personal data, subject to legal retention requirements. We will respond to deletion requests within 30 days.

[CUSTOMIZE] Verify retention periods comply with Philippine regulations.''',
    ),
    
    // Section 7: Your Privacy Rights
    PolicySectionModel(
      id: 'pp_7',
      title: '7. Your Privacy Rights',
      content: '''Under the Philippine Data Privacy Act (RA 10173), you have the following rights:

RIGHT TO BE INFORMED:
You have the right to know how your data is collected, used, and protected.

RIGHT TO ACCESS:
You can request a copy of your personal data in our possession.

RIGHT TO CORRECTION:
You can request correction of inaccurate or incomplete information.

RIGHT TO ERASURE (Right to be Forgotten):
You can request deletion of your personal data, subject to legal exceptions.

RIGHT TO DATA PORTABILITY:
You can request your data in a structured, commonly used format.

RIGHT TO OBJECT:
You can object to processing based on legitimate interests or direct marketing.

RIGHT TO LODGE A COMPLAINT:
You can file a complaint with the National Privacy Commission.

HOW TO EXERCISE YOUR RIGHTS:
1. Access your privacy settings in the App
2. Email our Data Protection Officer at $dpoEmail
3. Submit a written request to our office

We will respond to your requests within 15 business days, or 30 days for complex requests.

[CUSTOMIZE] Ensure rights descriptions align with current regulations.''',
    ),
    
    // Section 8: Cookies and Tracking
    PolicySectionModel(
      id: 'pp_8',
      title: '8. Cookies and Tracking',
      content: '''Our App and website use the following technologies:

ESSENTIAL COOKIES/TOKENS:
Required for the App to function properly:
• Authentication tokens
• Session management
• Security features

ANALYTICS:
Help us understand how users interact with our App:
• Usage patterns
• Feature popularity
• Error tracking

PREFERENCE STORAGE:
Remember your settings and preferences:
• Language selection
• Notification preferences
• Display settings

YOUR CHOICES:
• You can manage cookie preferences in device settings
• Essential functions may be limited if you disable certain features
• You can opt out of analytics in the App settings

WE DO NOT:
• Use cookies for third-party advertising
• Track your activity across other apps or websites
• Sell cookie data to third parties

[CUSTOMIZE] Update as tracking technologies change.''',
    ),
    
    // Section 9: Children's Privacy
    PolicySectionModel(
      id: 'pp_9',
      title: "9. Children's Privacy",
      content: '''MSME Pathways is not intended for users under 18 years of age.

We do not knowingly collect personal information from children under 18. If we become aware that we have collected data from a child under 18, we will:

1. Immediately delete the information
2. Terminate the associated account
3. Take steps to prevent future collection

If you believe a child under 18 has provided us with personal information, please contact us immediately at $supportEmail.

Parents and guardians are encouraged to monitor their children's online activities and teach safe internet practices.

[CUSTOMIZE] Verify age threshold complies with local requirements.''',
    ),
    
    // Section 10: International Data Transfers
    PolicySectionModel(
      id: 'pp_10',
      title: '10. International Data Transfers',
      content: '''Your data is primarily stored and processed in the Philippines.

WHEN DATA MAY BE TRANSFERRED:
• Cloud services with servers in other countries
• International service providers
• Cross-border regulatory requirements

SAFEGUARDS:
When transferring data internationally, we ensure:
• Recipient countries have adequate data protection laws
• Standard contractual clauses are in place
• Additional security measures are implemented
• Compliance with Philippine data export requirements

COUNTRIES WHERE DATA MAY BE PROCESSED:
[CUSTOMIZE] List specific countries where data processors operate.

We evaluate all international transfers to ensure your data receives equivalent protection regardless of location.''',
    ),
    
    // Section 11: Policy Changes
    PolicySectionModel(
      id: 'pp_11',
      title: '11. Changes to Privacy Policy',
      content: '''We may update this Privacy Policy from time to time.

HOW WE NOTIFY YOU:
• In-app notifications for significant changes
• Email notifications to registered users
• Updated "Last Modified" date on this policy
• Grace period before new terms take effect

YOUR CHOICES:
• Continue using the App to accept changes
• Contact us with questions or concerns
• Delete your account if you disagree with changes

REVIEW REGULARLY:
We encourage you to review this Privacy Policy periodically to stay informed about how we protect your data.

MATERIAL CHANGES:
For significant changes that affect how your data is used, we will seek your explicit consent before implementation.

[CUSTOMIZE] Define notification periods and procedures.''',
    ),
    
    // Section 12: Contact Us
    PolicySectionModel(
      id: 'pp_12',
      title: '12. Contact Us',
      content: '''For privacy-related questions or to exercise your rights:

DATA PROTECTION OFFICER:
Email: $dpoEmail
Phone: [CUSTOMIZE: Add phone number]

GENERAL INQUIRIES:
Email: $supportEmail
Website: $websiteUrl/privacy

MAILING ADDRESS:
$companyName
Attention: Privacy Team
$companyAddress

NATIONAL PRIVACY COMMISSION:
For complaints or concerns not resolved by us:
Website: https://privacy.gov.ph
Hotline: 8234-2228

RESPONSE TIMES:
• Simple requests: 15 business days
• Complex requests: 30 business days
• Urgent security matters: Within 24 hours

[CUSTOMIZE] Verify all contact information is accurate and monitored.

Last Updated: $effectiveDate
Policy Version: $policyVersion''',
    ),
  ];
}
