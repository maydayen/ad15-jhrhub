-- =========================================================
-- Johor HR Knowledge Hub Database (Dual Language Version)
-- Project: AD15 Aespa
-- =========================================================

CREATE DATABASE IF NOT EXISTS johor_hr_knowledge_hub;
USE johor_hr_knowledge_hub;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS documentUpdateNotifications;
DROP TABLE IF EXISTS documentArchive;
DROP TABLE IF EXISTS documentUpdateRequests;
DROP TABLE IF EXISTS documentDownloads;
DROP TABLE IF EXISTS documentViews;
DROP TABLE IF EXISTS guestSearchLog;
DROP TABLE IF EXISTS documentAuditLog;
DROP TABLE IF EXISTS documentVersions;
DROP TABLE IF EXISTS documentDepartmentTags;
DROP TABLE IF EXISTS documentCategories;
DROP TABLE IF EXISTS aiClassificationSuggestions;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS documentUploadLogs;
DROP TABLE IF EXISTS searchResults;
DROP TABLE IF EXISTS searchSuggestions;
DROP TABLE IF EXISTS trendingDocuments;
DROP TABLE IF EXISTS searchHistory;
DROP TABLE IF EXISTS escalationRequests;
DROP TABLE IF EXISTS documentSummaries;
DROP TABLE IF EXISTS chatbotConversations;
DROP TABLE IF EXISTS faqs;
DROP TABLE IF EXISTS recommendationReports;
DROP TABLE IF EXISTS personalNotes;
DROP TABLE IF EXISTS savedDocuments;
DROP TABLE IF EXISTS userFeedback;
DROP TABLE IF EXISTS notificationPreferences;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS recommendations;
DROP TABLE IF EXISTS documents;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================
-- USERS TABLE
-- =========================================================
CREATE TABLE users (
  userId INT AUTO_INCREMENT PRIMARY KEY,
  fullName VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  department VARCHAR(100),
  role VARCHAR(50) DEFAULT 'registered_user',
  designation VARCHAR(100),
  status VARCHAR(50) DEFAULT 'Active',
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================================
-- DOCUMENTS TABLE (Dual Language)
-- =========================================================
CREATE TABLE documents (
  documentId INT AUTO_INCREMENT PRIMARY KEY,
  referenceNo VARCHAR(100) UNIQUE NOT NULL,
  title VARCHAR(255) NOT NULL,
  category VARCHAR(100) NOT NULL,
  type VARCHAR(50),
  status VARCHAR(50) DEFAULT 'Published',
  access VARCHAR(50) DEFAULT 'Public',
  effectiveDate VARCHAR(50),
  version VARCHAR(20) DEFAULT '1.0',
  reason_en VARCHAR(500),
  reason_ms VARCHAR(500),
  summary_en TEXT,
  summary_ms TEXT,
  fileName VARCHAR(255),
  filePath VARCHAR(500),
  totalViews INT DEFAULT 0,
  totalDownloads INT DEFAULT 0,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================================
-- RECOMMENDATIONS TABLE
-- =========================================================
CREATE TABLE recommendations (
  recommendationId INT AUTO_INCREMENT PRIMARY KEY,
  userId INT,
  documentId INT NOT NULL,
  type VARCHAR(50) DEFAULT 'personalized',
  reason VARCHAR(500),
  score DECIMAL(5,2) DEFAULT 0.00,
  status VARCHAR(50) DEFAULT 'Active',
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_recommendation_user FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE SET NULL,
  CONSTRAINT fk_recommendation_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE CASCADE
);

CREATE TABLE recommendationReports (
  reportId INT AUTO_INCREMENT PRIMARY KEY,
  recommendationId INT NOT NULL,
  userId INT NOT NULL,
  adminId INT NULL,
  reportReason VARCHAR(100) NOT NULL,
  reportDescription VARCHAR(1000),
  reportStatus VARCHAR(50) DEFAULT 'Pending',
  submittedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  reviewedAt DATETIME NULL,
  CONSTRAINT fk_report_recommendation FOREIGN KEY (recommendationId) REFERENCES recommendations(recommendationId) ON DELETE CASCADE,
  CONSTRAINT fk_report_user FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE,
  CONSTRAINT fk_report_admin FOREIGN KEY (adminId) REFERENCES users(userId) ON DELETE SET NULL
);

-- =========================================================
-- FAQS TABLE (Dual Language)
-- =========================================================
CREATE TABLE faqs (
  faqId INT AUTO_INCREMENT PRIMARY KEY,
  question_en VARCHAR(500) NOT NULL,
  question_ms VARCHAR(500) NOT NULL,
  answer_en VARCHAR(1000) NOT NULL,
  answer_ms VARCHAR(1000) NOT NULL,
  category VARCHAR(100) DEFAULT 'General',
  status VARCHAR(50) DEFAULT 'Published',
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE chatbotConversations (
  conversationId INT AUTO_INCREMENT PRIMARY KEY,
  userId INT,
  questionText VARCHAR(1000) NOT NULL,
  responseText VARCHAR(2000),
  relatedDocumentId INT NULL,
  confidenceScore DECIMAL(5,2) DEFAULT 0.00,
  ratingValue INT NULL,
  ratingComment VARCHAR(500) NULL,
  conversationStatus VARCHAR(50) DEFAULT 'Answered',
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_chatbot_user FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE SET NULL,
  CONSTRAINT fk_chatbot_document FOREIGN KEY (relatedDocumentId) REFERENCES documents(documentId) ON DELETE SET NULL
);

CREATE TABLE documentSummaries (
  summaryId INT AUTO_INCREMENT PRIMARY KEY,
  documentId INT NOT NULL,
  userId INT,
  summaryText VARCHAR(2000) NOT NULL,
  summaryStatus VARCHAR(50) DEFAULT 'Generated',
  generatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_summary_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE CASCADE,
  CONSTRAINT fk_summary_user FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE SET NULL
);

CREATE TABLE escalationRequests (
  escalationId INT AUTO_INCREMENT PRIMARY KEY,
  conversationId INT NULL,
  userId INT,
  hrOfficerId INT NULL,
  escalationQuestion VARCHAR(1000) NOT NULL,
  escalationDescription VARCHAR(1000),
  escalationStatus VARCHAR(50) DEFAULT 'Pending',
  submittedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  resolvedAt DATETIME NULL,
  CONSTRAINT fk_escalation_conversation FOREIGN KEY (conversationId) REFERENCES chatbotConversations(conversationId) ON DELETE SET NULL,
  CONSTRAINT fk_escalation_user FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE SET NULL,
  CONSTRAINT fk_escalation_hr_officer FOREIGN KEY (hrOfficerId) REFERENCES users(userId) ON DELETE SET NULL
);

CREATE TABLE notifications (
  notificationId INT AUTO_INCREMENT PRIMARY KEY,
  userId INT,
  documentId INT,
  title VARCHAR(150) NOT NULL,
  message VARCHAR(1000) NOT NULL,
  type VARCHAR(50) DEFAULT 'policy_update',
  isRead TINYINT(1) DEFAULT 0,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  readAt DATETIME NULL,
  CONSTRAINT fk_notification_user FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE SET NULL,
  CONSTRAINT fk_notification_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE SET NULL
);

CREATE TABLE notificationPreferences (
  preferenceId INT AUTO_INCREMENT PRIMARY KEY,
  userId INT NOT NULL,
  policyUpdateEnabled TINYINT(1) DEFAULT 1,
  savedUpdateEnabled TINYINT(1) DEFAULT 1,
  notificationFrequency VARCHAR(50) DEFAULT 'Daily',
  deliveryChannel VARCHAR(50) DEFAULT 'In-System',
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_notification_preference_user FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE,
  CONSTRAINT unique_notification_preference_user UNIQUE (userId)
);

CREATE TABLE userFeedback (
  feedbackId INT AUTO_INCREMENT PRIMARY KEY,
  userId INT NOT NULL,
  adminId INT NULL,
  feedbackCategory VARCHAR(100) NOT NULL,
  feedbackContent VARCHAR(1000) NOT NULL,
  feedbackStatus VARCHAR(50) DEFAULT 'Pending',
  submittedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  reviewedAt DATETIME NULL,
  CONSTRAINT fk_feedback_user FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE,
  CONSTRAINT fk_feedback_admin FOREIGN KEY (adminId) REFERENCES users(userId) ON DELETE SET NULL
);

CREATE TABLE searchHistory (
  searchId INT AUTO_INCREMENT PRIMARY KEY,
  userId INT,
  searchQuery VARCHAR(255) NOT NULL,
  searchType VARCHAR(50) DEFAULT 'Semantic Search',
  resultCount INT DEFAULT 0,
  searchedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_search_history_user FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE SET NULL
);

CREATE TABLE searchResults (
  resultId INT AUTO_INCREMENT PRIMARY KEY,
  searchId INT NOT NULL,
  documentId INT NOT NULL,
  relevanceScore DECIMAL(5,2) DEFAULT 0.00,
  resultRank INT DEFAULT 1,
  matchedContent VARCHAR(1000),
  matchType VARCHAR(50) DEFAULT 'keyword',
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_search_result_history FOREIGN KEY (searchId) REFERENCES searchHistory(searchId) ON DELETE CASCADE,
  CONSTRAINT fk_search_result_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE CASCADE
);

-- =========================================================
-- SEARCH SUGGESTIONS TABLE (Dual Language)
-- =========================================================
CREATE TABLE searchSuggestions (
  suggestionId INT AUTO_INCREMENT PRIMARY KEY,
  searchId INT NULL,
  suggestionText_en VARCHAR(255) NOT NULL,
  suggestionText_ms VARCHAR(255) NOT NULL,
  suggestionType VARCHAR(50) DEFAULT 'popular_query',
  usageCount INT DEFAULT 0,
  isActive TINYINT(1) DEFAULT 1,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_search_suggestion_history FOREIGN KEY (searchId) REFERENCES searchHistory(searchId) ON DELETE SET NULL
);

CREATE TABLE trendingDocuments (
  trendingId INT AUTO_INCREMENT PRIMARY KEY,
  documentId INT NOT NULL,
  viewCount INT DEFAULT 0,
  downloadCount INT DEFAULT 0,
  searchCount INT DEFAULT 0,
  trendingScore DECIMAL(5,2) DEFAULT 0.00,
  calculatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_trending_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE CASCADE
);

CREATE TABLE savedDocuments (
  savedId INT AUTO_INCREMENT PRIMARY KEY,
  userId INT NOT NULL,
  documentId INT NOT NULL,
  savedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_saved_user FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE,
  CONSTRAINT fk_saved_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE CASCADE,
  CONSTRAINT unique_saved_document UNIQUE (userId, documentId)
);

CREATE TABLE personalNotes (
  noteId INT AUTO_INCREMENT PRIMARY KEY,
  userId INT NOT NULL,
  documentId INT NOT NULL,
  noteContent VARCHAR(1000) NOT NULL,
  noteStatus VARCHAR(50) DEFAULT 'Active',
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_note_user FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE,
  CONSTRAINT fk_note_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE CASCADE
);

CREATE TABLE documentUploadLogs (
  logId INT AUTO_INCREMENT PRIMARY KEY,
  documentId INT NULL,
  uploadedBy INT NOT NULL,
  uploadStatus VARCHAR(50) DEFAULT 'pending_review',
  failureReason TEXT NULL,
  filePath VARCHAR(500) NOT NULL,
  fileSizeKb INT NOT NULL,
  uploadedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_uploadlog_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE SET NULL,
  CONSTRAINT fk_uploadlog_user FOREIGN KEY (uploadedBy) REFERENCES users(userId) ON DELETE CASCADE
);

-- =========================================================
-- CATEGORIES TABLE (Dual Language Descriptions)
-- =========================================================
CREATE TABLE categories (
  categoryId INT AUTO_INCREMENT PRIMARY KEY,
  categoryName VARCHAR(100) UNIQUE NOT NULL,
  categoryCode VARCHAR(20) UNIQUE NOT NULL,
  description_en TEXT,
  description_ms TEXT,
  isActive TINYINT(1) DEFAULT 1 NOT NULL,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE aiClassificationSuggestions (
  suggestionId INT AUTO_INCREMENT PRIMARY KEY,
  documentId INT NOT NULL,
  suggestedCategory VARCHAR(100) NOT NULL,
  suggestedDepartmentTag VARCHAR(100),
  confidenceScore DECIMAL(5,2) DEFAULT 0.00,
  suggestionRank INT NOT NULL,
  reviewStatus VARCHAR(50) DEFAULT 'pending',
  modifiedCategory VARCHAR(100) NULL,
  modifiedDepartmentTag VARCHAR(100) NULL,
  reviewedBy INT NULL,
  reviewedAt DATETIME NULL,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_aisugg_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE CASCADE,
  CONSTRAINT fk_aisugg_reviewer FOREIGN KEY (reviewedBy) REFERENCES users(userId) ON DELETE SET NULL
);

CREATE TABLE documentCategories (
  docCategoryId INT AUTO_INCREMENT PRIMARY KEY,
  documentId INT NOT NULL,
  categoryId INT NOT NULL,
  isPrimary TINYINT(1) DEFAULT 0 NOT NULL,
  assignedBy INT NOT NULL,
  assignedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_doccategory_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE CASCADE,
  CONSTRAINT fk_doccategory_category FOREIGN KEY (categoryId) REFERENCES categories(categoryId) ON DELETE CASCADE,
  CONSTRAINT fk_doccategory_user FOREIGN KEY (assignedBy) REFERENCES users(userId) ON DELETE CASCADE
);

CREATE TABLE documentDepartmentTags (
  tagId INT AUTO_INCREMENT PRIMARY KEY,
  documentId INT NOT NULL,
  departmentName VARCHAR(100) NOT NULL,
  isPrimary TINYINT(1) DEFAULT 0 NOT NULL,
  assignedBy INT NOT NULL,
  assignedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_deptag_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE CASCADE,
  CONSTRAINT fk_deptag_user FOREIGN KEY (assignedBy) REFERENCES users(userId) ON DELETE CASCADE
);

CREATE TABLE documentVersions (
  versionId INT AUTO_INCREMENT PRIMARY KEY,
  documentId INT NOT NULL,
  versionNumber VARCHAR(20) NOT NULL,
  filePath VARCHAR(500) NOT NULL,
  fileName VARCHAR(255) NOT NULL,
  fileSizeKb INT NOT NULL,
  changeSummary TEXT NULL,
  uploadedBy INT NOT NULL,
  isCurrent TINYINT(1) DEFAULT 0 NOT NULL,
  publishedAt DATETIME NULL,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_docversion_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE CASCADE,
  CONSTRAINT fk_docversion_user FOREIGN KEY (uploadedBy) REFERENCES users(userId) ON DELETE CASCADE
);

CREATE TABLE documentAuditLog (
  auditId INT AUTO_INCREMENT PRIMARY KEY,
  documentId INT NOT NULL,
  actionType VARCHAR(50) NOT NULL,
  performedBy INT NOT NULL,
  previousStatus VARCHAR(50) NULL,
  newStatus VARCHAR(50) NULL,
  actionDetails TEXT NULL,
  ipAddress VARCHAR(50) NULL,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_audit_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE CASCADE,
  CONSTRAINT fk_audit_user FOREIGN KEY (performedBy) REFERENCES users(userId) ON DELETE CASCADE
);

CREATE TABLE guestSearchLog (
  guestSearchId INT AUTO_INCREMENT PRIMARY KEY,
  searchQuery VARCHAR(255) NOT NULL,
  filterCategory VARCHAR(100) NULL,
  filterDepartment VARCHAR(100) NULL,
  filterDocType VARCHAR(30) NULL,
  resultCount INT DEFAULT 0 NOT NULL,
  searchedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE documentViews (
  viewId INT AUTO_INCREMENT PRIMARY KEY,
  documentId INT NOT NULL,
  userId INT NULL,
  viewerRole VARCHAR(50) NOT NULL DEFAULT 'guest',
  viewedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_docview_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE CASCADE,
  CONSTRAINT fk_docview_user FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE SET NULL
);

CREATE TABLE documentDownloads (
  downloadId INT AUTO_INCREMENT PRIMARY KEY,
  documentId INT NOT NULL,
  userId INT NOT NULL,
  versionId INT NULL,
  downloadedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_download_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE CASCADE,
  CONSTRAINT fk_download_user FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE,
  CONSTRAINT fk_download_version FOREIGN KEY (versionId) REFERENCES documentVersions(versionId) ON DELETE SET NULL
);

CREATE TABLE documentUpdateRequests (
  updateRequestId INT AUTO_INCREMENT PRIMARY KEY,
  documentId INT NOT NULL,
  requestedBy INT NOT NULL,
  updateType VARCHAR(50) NOT NULL,
  updateReason TEXT NOT NULL,
  newFilePath VARCHAR(500) NOT NULL,
  newFileName VARCHAR(255) NOT NULL,
  newFileSizeKb INT NOT NULL,
  newEffectiveDate DATE NULL,
  reviewStatus VARCHAR(50) DEFAULT 'pending',
  reviewedBy INT NULL,
  reviewedAt DATETIME NULL,
  rejectionReason TEXT NULL,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_updatereq_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE CASCADE,
  CONSTRAINT fk_updatereq_requester FOREIGN KEY (requestedBy) REFERENCES users(userId) ON DELETE CASCADE,
  CONSTRAINT fk_updatereq_reviewer FOREIGN KEY (reviewedBy) REFERENCES users(userId) ON DELETE SET NULL
);

CREATE TABLE documentArchive (
  archiveId INT AUTO_INCREMENT PRIMARY KEY,
  documentId INT NOT NULL,
  archivedBy INT NOT NULL,
  archiveReason VARCHAR(50) NOT NULL,
  reasonDetails TEXT NULL,
  predecessorDocumentId INT NULL,
  successorDocumentId INT NULL,
  predecessorReference VARCHAR(100) NULL,
  successorReference VARCHAR(100) NULL,
  archivedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_archive_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE CASCADE,
  CONSTRAINT fk_archive_user FOREIGN KEY (archivedBy) REFERENCES users(userId) ON DELETE CASCADE
);

CREATE TABLE documentUpdateNotifications (
  updateNotificationId INT AUTO_INCREMENT PRIMARY KEY,
  documentId INT NOT NULL,
  userId INT NOT NULL,
  notificationType VARCHAR(50) NOT NULL,
  notificationMessage TEXT NOT NULL,
  newVersionId INT NULL,
  isRead TINYINT(1) DEFAULT 0 NOT NULL,
  readAt DATETIME NULL,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_updnotif_document FOREIGN KEY (documentId) REFERENCES documents(documentId) ON DELETE CASCADE,
  CONSTRAINT fk_updnotif_user FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE,
  CONSTRAINT fk_updnotif_version FOREIGN KEY (newVersionId) REFERENCES documentVersions(versionId) ON DELETE SET NULL
);

-- =========================================================
-- SAMPLE DATA INSERTS
-- =========================================================

INSERT INTO categories (categoryName, categoryCode, description_en, description_ms, isActive) VALUES
('Leave Policy', 'LEAVE', 'Policies related to annual leave, sick leave and special leave', 'Polisi berkaitan cuti tahunan, cuti sakit dan cuti khas', 1),
('Promotion', 'PROMO', 'Guidelines and circulars related to staff promotion', 'Garis panduan dan pekeliling berkaitan kenaikan pangkat kakitangan', 1),
('Discipline', 'DISC', 'Disciplinary procedures and tatatertib guidelines', 'Prosedur tatatertib dan garis panduan disiplin', 1),
('Salary', 'SAL', 'Salary scales, allowances and pay-related policies', 'Skala gaji, elaun dan polisi berkaitan pembayaran', 1),
('Staff Benefits', 'BEN', 'Benefits including TASKA subsidy, loans and welfare', 'Faedah termasuk subsidi TASKA, pinjaman dan kebajikan', 1),
('Overseas Travel', 'TRAVEL', 'SPKN and overseas travel application procedures', 'Prosedur permohonan SPKN dan perjalanan ke luar negara', 1),
('Contract Service', 'CONTRACT', 'COS and CFS contract officer management guidelines', 'Garis panduan pengurusan pegawai kontrak COS dan CFS', 1),
('Promotion and Discipline', 'PROMODISC', 'Combined promotion and disciplinary reference documents', 'Dokumen rujukan gabungan untuk kenaikan pangkat dan tatatertib', 1);

-- We only have the Admin user now
INSERT INTO users
(fullName, email, password, department, role, designation, status)
VALUES
(
  'Admin User',
  'admin@johorhr.gov.my',
  'admin123',
  'Human Resource',
  'administrator',
  'System Administrator',
  'Active'
);

INSERT INTO notificationPreferences
(userId, policyUpdateEnabled, savedUpdateEnabled, notificationFrequency, deliveryChannel)
VALUES
(1, 1, 1, 'Daily', 'In-System');

INSERT INTO documents
(referenceNo, title, category, type, status, access, effectiveDate, version, reason_en, reason_ms, summary_en, summary_ms, fileName, filePath, totalViews, totalDownloads)
VALUES
(
  'JHR-TASKA-FORM-2025',
  'TASKA Subsidy Application Form',
  'Borang Permohonan Subsidi TASKA',
  'Staff Benefits',
  'Form',
  'Published',
  'Public',
  '16 May 2025',
  '1.0',
  'Related to childcare subsidy application for eligible public officers.',
  'Berkaitan dengan permohonan subsidi penjagaan kanak-kanak untuk pegawai awam yang layak.',
  'Application form for claiming childcare fee subsidy at workplace TASKA for public sector officers. It includes applicant details, spouse details, monthly income information, child information, TASKA confirmation and supporting document checklist.',
  'Borang permohonan untuk menuntut subsidi yuran penjagaan kanak-kanak di TASKA tempat kerja. Ia merangkumi butiran pemohon, maklumat pasangan, pendapatan bulanan, dan pengesahan TASKA.',
  'Borang.Subsidi TASKA.pdf',
  '/uploads/documents/Borang.Subsidi TASKA.pdf',
  42,
  15
),
(
  'JHR-TASKA-GUIDE-2025',
  'TASKA Subsidy Application Guideline',
  'Garis Panduan Permohonan Subsidi TASKA',
  'Staff Benefits',
  'Guideline',
  'Published',
  'Public',
  '2025',
  '1.0',
  'Useful for officers searching about TASKA subsidy eligibility and application requirements.',
  'Berguna untuk pegawai yang mencari maklumat tentang kelayakan dan syarat permohonan TASKA.',
  'Guideline explaining the implementation of childcare fee subsidy at workplace TASKA. It covers household income eligibility, maximum subsidy amount, child age requirement, supporting documents, yearly resubmission and responsibilities of department heads.',
  'Garis panduan yang menerangkan pelaksanaan subsidi yuran TASKA. Ia merangkumi kelayakan pendapatan isi rumah, jumlah maksimum subsidi, syarat umur anak, dan dokumen sokongan.',
  'Garis Panduan Permohonan Subsidi TASKA.pdf',
  '/uploads/documents/Garis Panduan Permohonan Subsidi TASKA.pdf',
  65,
  24
),
(
  'JHR-PANGKAT-TBK-2025',
  'TBK Promotion Application Guideline',
  'Garis Panduan Permohonan Kenaikan Pangkat Secara TBK',
  'Promotion',
  'Guideline',
  'Published',
  'Registered',
  '2025',
  '1.0',
  'Recommended for users searching about promotion, TBK1, TBK2 or career advancement.',
  'Disyorkan untuk carian berkaitan kenaikan pangkat, TBK1, TBK2 atau kemajuan kerjaya.',
  'Guideline for time-based promotion implementation for Johor public service officers. It explains TBK1 and TBK2, 13-year service requirement, performance condition, affected officer categories, submission period and promotion date determination.',
  'Garis panduan untuk pelaksanaan kenaikan pangkat berasaskan masa (TBK) bagi pegawai perkhidmatan awam Johor. Menerangkan syarat perkhidmatan 13 tahun dan penentuan tarikh kenaikan pangkat.',
  'GARIS PANDUAN PERMOHONAN KENAIKAN PANGKAT SECARA TBK.pdf',
  '/uploads/documents/GARIS PANDUAN PERMOHONAN KENAIKAN PANGKAT SECARA TBK.pdf',
  88,
  37
),
(
  'JHR-SPKN-2025',
  'SPKN Guideline',
  'Garis Panduan SPKN',
  'Overseas Travel',
  'Guideline',
  'Published',
  'Registered',
  '29 Dec 2025',
  '1.0',
  'Related to overseas travel application and SPKN procedure.',
  'Berkaitan dengan permohonan perjalanan ke luar negara dan prosedur SPKN.',
  'Guideline for managing overseas travel applications for Johor public officers through the SPKN system. It covers official travel, personal travel, hajj and umrah applications, supporting documents, department approval and submission timeline.',
  'Garis panduan untuk menguruskan permohonan perjalanan ke luar negara bagi pegawai awam Johor melalui sistem SPKN. Merangkumi urusan rasmi, peribadi, haji dan umrah.',
  'Garis Panduan SPKN 29122025.pdf',
  '/uploads/documents/Garis Panduan SPKN 29122025.pdf',
  51,
  12
),
(
  'JHR-COS-CFS-2024',
  'Management Guideline for COS and CFS Contract Officers',
  'Garis Panduan Pengurusan Pegawai Lantikan Kontrak COS dan CFS',
  'Contract Service',
  'Guideline',
  'Published',
  'Registered',
  '1 Dec 2024',
  '1.0',
  'Useful for users searching about contract officer management under SSPA.',
  'Berguna untuk pengurusan pegawai kontrak di bawah SSPA.',
  'Guideline for managing contract officers under Contract of Service and Contract for Service in Johor public service. It covers implementation of SSPA, contract officer categories, salary adjustment and appointment management.',
  'Garis panduan pengurusan pegawai kontrak di bawah Contract of Service (COS) dan Contract for Service (CFS) dalam perkhidmatan awam Johor.',
  'Lampiran 1.Garis PanduanCOS.CFS.pdf',
  '/uploads/documents/Lampiran 1.Garis PanduanCOS.CFS.pdf',
  34,
  9
),
(
  'JHR-PANGKAT-TATATERTIB-2025',
  'List of Guidelines for Promotion and Disciplinary Section',
  'Senarai Garis Panduan Seksyen Naik Pangkat dan Tatatertib',
  'Promotion and Discipline',
  'Reference Document',
  'Published',
  'Registered',
  '2025',
  '1.0',
  'Related to promotion and disciplinary guideline reference.',
  'Berkaitan dengan rujukan garis panduan kenaikan pangkat dan tatatertib.',
  'Scanned reference document related to promotion and disciplinary section guidelines. This document may require OCR before full-text search can work accurately.',
  'Dokumen rujukan yang diimbas (scanned) berkaitan garis panduan seksyen kenaikan pangkat dan tatatertib. Dokumen ini mungkin memerlukan OCR untuk carian teks penuh yang tepat.',
  'Senarai garis panduan sekyen Naik Pangkat Tatatertib.pdf',
  '/uploads/documents/Senarai garis panduan sekyen Naik Pangkat Tatatertib.pdf',
  23,
  6
);

INSERT INTO searchSuggestions
(suggestionText_en, suggestionText_ms, suggestionType, usageCount, isActive)
VALUES
('TASKA subsidy application', 'Permohonan subsidi TASKA', 'popular_query', 18, 1),
('promotion TBK guideline', 'Garis panduan TBK pangkat', 'popular_query', 25, 1),
('SPKN overseas travel', 'Perjalanan luar negara SPKN', 'popular_query', 14, 1),
('contract service COS CFS', 'Perkhidmatan kontrak COS CFS', 'popular_query', 9, 1),
('promotion and discipline', 'Kenaikan pangkat dan tatatertib', 'popular_query', 11, 1);

INSERT INTO trendingDocuments
(documentId, viewCount, downloadCount, searchCount, trendingScore)
VALUES
(3, 88, 37, 30, 95.50),
(2, 65, 24, 22, 89.00),
(4, 51, 12, 18, 78.50),
(1, 42, 15, 15, 72.00),
(5, 34, 9, 10, 66.50);

INSERT INTO faqs
(question_en, question_ms, answer_en, answer_ms, category, status)
VALUES
(
  'What information must be prepared before submitting the TASKA subsidy application form?',
  'Apakah maklumat yang perlu disediakan sebelum menghantar borang permohonan subsidi TASKA?',
  'Before submitting the TASKA subsidy application, the applicant should prepare officer information, spouse information, household income details, child information, TASKA confirmation, and required supporting documents.',
  'Sebelum menghantar permohonan subsidi TASKA, pemohon perlu menyediakan maklumat pegawai, maklumat pasangan, butiran pendapatan isi rumah, pengesahan TASKA, dan dokumen sokongan yang diperlukan.',
  'Staff Benefits',
  'Published'
),
(
  'What is the difference between the TASKA application form and the TASKA guideline?',
  'Apakah perbezaan antara borang permohonan TASKA dan garis panduan TASKA?',
  'The Borang Permohonan Subsidi TASKA is the form used by officers to apply for childcare fee subsidy, while the Garis Panduan Permohonan Subsidi TASKA explains the application rules, eligibility, supporting documents, and subsidy implementation.',
  'Borang Permohonan Subsidi TASKA digunakan oleh pegawai untuk memohon subsidi yuran, manakala Garis Panduan Permohonan Subsidi TASKA menerangkan peraturan permohonan, kelayakan, dan pelaksanaan subsidi.',
  'Staff Benefits',
  'Published'
),
(
  'What are the main conditions explained in the TBK promotion guideline?',
  'Apakah syarat utama yang diterangkan dalam garis panduan kenaikan pangkat TBK?',
  'The TBK promotion guideline explains time-based promotion conditions such as TBK1 and TBK2, service period requirement, officer eligibility, performance condition, and promotion date determination.',
  'Garis panduan kenaikan pangkat TBK menerangkan syarat kenaikan pangkat berasaskan masa seperti TBK1 dan TBK2, tempoh perkhidmatan, kelayakan pegawai, syarat prestasi, dan penentuan tarikh kenaikan pangkat.',
  'Promotion',
  'Published'
),
(
  'What type of overseas travel applications are covered under the SPKN guideline?',
  'Apakah jenis permohonan perjalanan luar negara yang dilindungi di bawah garis panduan SPKN?',
  'The SPKN guideline covers several types of overseas travel applications, including official travel, personal travel, hajj, and umrah applications. It also explains supporting documents and department approval.',
  'Garis panduan SPKN meliputi beberapa jenis permohonan perjalanan luar negara, termasuk urusan rasmi, peribadi, haji, dan umrah. Ia juga menerangkan dokumen sokongan dan kelulusan jabatan.',
  'Overseas Travel',
  'Published'
),
(
  'What does the COS and CFS guideline explain about contract officers?',
  'Apakah yang diterangkan oleh garis panduan COS dan CFS mengenai pegawai kontrak?',
  'The COS and CFS guideline explains the management of contract officers under Contract of Service and Contract for Service. It covers contract officer categories, appointment management, salary adjustment, and implementation matters under SSPA.',
  'Garis panduan COS dan CFS menerangkan pengurusan pegawai kontrak di bawah Contract of Service dan Contract for Service. Ia merangkumi kategori pegawai kontrak, pelarasan gaji, dan pelaksanaan SSPA.',
  'Contract Service',
  'Published'
),
(
  'Why does the promotion and discipline reference document need special handling in the system?',
  'Mengapakah dokumen rujukan kenaikan pangkat dan tatatertib memerlukan pengendalian khas?',
  'Since the document is scanned, the system may need OCR before the full text can be searched accurately. Without OCR, the system can only rely on manually entered title, category, and summary information.',
  'Oleh kerana dokumen tersebut diimbas (scanned), sistem mungkin memerlukan OCR sebelum teks penuh boleh dicari dengan tepat. Tanpa OCR, sistem hanya boleh bergantung pada tajuk dan ringkasan yang dimasukkan secara manual.',
  'Promotion and Discipline',
  'Published'
);

-- Assigned dummy data to userId 1 (Admin User)
INSERT INTO recommendations
(userId, documentId, type, reason, score, status)
VALUES
(1, 2, 'personalized', 'Recommended because you viewed staff benefit and TASKA-related documents.', 92.50, 'Active'),
(1, 3, 'related_document', 'Recommended because this document is related to promotion and career advancement policies.', 88.00, 'Active'),
(1, 4, 'personalized', 'Recommended because officers in your department frequently access overseas travel guidelines.', 81.75, 'Active');

INSERT INTO notifications
(userId, documentId, title, message, type, isRead)
VALUES
(1, 1, 'New TASKA subsidy form available', 'The Borang Permohonan Subsidi TASKA document is now available in the system.', 'policy_update', 0),
(1, 3, 'Smart Alert: Promotion guideline updated', 'A time-based promotion guideline has been added for public service officers.', 'smart_alert', 0),
(1, 3, 'Smart Alert: Promotion guideline may be relevant', 'Based on recent promotion-related searches, the TBK promotion guideline may be useful for your reference.', 'smart_alert', 0),
(1, 4, 'Smart Alert: SPKN travel guideline detected', 'The SPKN overseas travel guideline is frequently accessed and may be relevant for officers preparing overseas travel applications.', 'smart_alert', 0),
(1, 4, 'SPKN guideline available', 'The SPKN overseas travel guideline is available for registered users.', 'policy_update', 1);

INSERT INTO savedDocuments (userId, documentId) VALUES (1, 2), (1, 3), (1, 4);

INSERT INTO personalNotes (userId, documentId, noteContent, noteStatus)
VALUES
(1, 2, 'Check TASKA subsidy eligibility before submitting monthly claim.', 'Active'),
(1, 3, 'Important for officers who have completed 13 years of service.', 'Active');