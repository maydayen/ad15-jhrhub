<template>
  <div class="app-shell">
    <aside class="sidebar">
      <div class="brand">
        <div class="logo-mark">J</div>
        <div>
          <h1>Johor HR</h1>
          <p>Knowledge Hub</p>
        </div>
      </div>

      <div class="session-card">
        <span>{{ t('currentAccess') }}</span>
        <strong>{{ session }}</strong>
        <small>{{ sessionText }}</small>
      </div>

      <nav class="nav-list">
        <button
          v-for="item in visibleNavItems"
          :key="item.id"
          :class="{ active: screen === item.id }"
          @click="screen = item.id"
        >
          <span>{{ t(item.labelKey) }}</span>
        </button>
      </nav>

      <button
        v-if="session === 'Admin'"
        class="ghost-button"
        @click="logoutPrototype"
      >
        {{ t('logout') }}
      </button>
    </aside>

    <main class="main-panel">
      <header class="topbar">
        <div>
          <p class="eyebrow">Johor HR Knowledge Hub</p>
          <h2>{{ currentPageTitle }}</h2>
        </div>

        <div class="top-actions">
          <button @click="toggleLanguage">
            {{ language === 'en' ? 'BM' : 'EN' }}
          </button>

          <button class="primary" @click="screen = 'auth'; authMode = 'admin'">
            {{ t('adminLogin') }}
          </button>
        </div>
      </header>

      <div v-if="toast" :class="['toast', toastType]">
        <span>{{ t('systemMessage') }}</span>
        <p>{{ toast }}</p>
        <button @click="toast = ''">×</button>
      </div>

      <!-- PUBLIC PORTAL -->
      <section v-if="screen === 'public'" class="grid-two">
        <div class="hero-card">
          <p class="eyebrow">{{ t('guestAccess') }}</p>
          <h3>{{ t('publicTitle') }}</h3>
          <p>{{ t('publicDesc') }}</p>

          <div class="search-box">
            <input
              v-model="query"
              :placeholder="t('searchPlaceholder')"
            />

            <select v-model="category">
              <option v-for="item in categories" :key="item" :value="item">
                {{ item === 'All' ? (language === 'en' ? 'All' : 'Semua') : tv(item) }}
              </option>
            </select>
          </div>

          <div class="category-row">
            <button
              v-for="item in categories"
              :key="item"
              :class="category === item ? 'chip selected' : 'chip'"
              @click="category = item"
            >
              {{ item === 'All' ? (language === 'en' ? 'All' : 'Semua') : tv(item) }}
            </button>
          </div>
        </div>

        <div class="detail-card">
          <div class="detail-header">
            <span :class="selectedDoc.access === 'Public' ? 'badge green' : 'badge amber'">
              {{ selectedDoc.access }}
            </span>
            <span>{{ selectedDoc.effectiveDate }}</span>
          </div>

          <h3>{{ selectedDoc.title }}</h3>
          <p>{{ language === 'en' ? selectedDoc.summary_en : selectedDoc.summary_ms }}</p>

          <dl>
            <div>
              <dt>{{ t('reference') }}</dt>
              <dd>{{ selectedDoc.referenceNo }}</dd>
            </div>
            <div>
              <dt>{{ t('category') }}</dt>
              <dd>{{ tv(selectedDoc.category) }}</dd>
            </div>
            <div>
              <dt>{{ t('type') }}</dt>
              <dd>{{ tv(selectedDoc.type) }}</dd>
            </div>
            <div>
              <dt>{{ t('status') }}</dt>
              <dd>{{ tv(selectedDoc.status) }}</dd>
            </div>
          </dl>

          <button
            class="primary full"
            @click="openDocumentDetails(selectedDoc)"
          >
            {{ t('openPublicDetails') }}
          </button>

        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">{{ t('searchResults') }}</p>
              <h3>{{ filteredDocs.length }} {{ t('documentsFound') }}</h3>
            </div>

          </div>

          <div class="doc-grid">
            <button
              v-for="doc in filteredDocs"
              :key="doc.documentId"
              class="doc-card"
              @click="selectedDoc = doc"
            >
              <span :class="doc.access === 'Public' ? 'status-pill green' : 'status-pill amber'">
                {{ doc.access }}
              </span>

              <h4>{{ doc.title }}</h4>
              <p>{{ doc.referenceNo }}</p>

              <div>
                <span>{{ tv(doc.category) }}</span>
                <span>{{ tv(doc.type) }}</span>
              </div>
            </button>

            <div v-if="filteredDocs.length === 0" class="empty-state">
              {{ t('noMatchingDocuments') }}
            </div>
          </div>
        </div>
        <div
          v-if="publicDetailsModalOpen"
          class="modal-overlay"
          @click.self="publicDetailsModalOpen = false"
        >
    <div class="modal-card public-detail-modal">
      <div class="section-title">
        <div>
          <p class="eyebrow">{{ t('publicDocumentDetails') }}</p>
          <h3>{{ selectedDoc.title }}</h3>
        </div>

        <button @click="publicDetailsModalOpen = false">
          {{ t('close') }}
        </button>
      </div>

      <div class="public-detail-header">
        <span class="status-pill green">{{ selectedDoc.access }}</span>
        <span class="status-pill">{{ selectedDoc.status }}</span>
              <span class="status-pill">{{ t('version') }} {{ selectedDoc.version }}</span>
            </div>

            <dl>
              <div>
                <dt>{{ t('referenceNumber') }}</dt>
                <dd>{{ selectedDoc.referenceNo }}</dd>
              </div>
              <div>
                <dt>{{ t('category') }}</dt>
                <dd>{{ selectedDoc.category }}</dd>
              </div>
              <div>
                <dt>{{ t('documentType') }}</dt>
                <dd>{{ selectedDoc.type }}</dd>
              </div>
              <div>
                <dt>{{ t('effectiveDate') }}</dt>
                <dd>{{ selectedDoc.effectiveDate }}</dd>
              </div>
              <div>
                <dt>{{ t('issuingDepartment') }}</dt>
                <dd>Johor Human Resource Management Division</dd>
              </div>
              <div>
                <dt>{{ t('documentPurpose') }}</dt>
                <dd>Provides official guidance for HR-related procedures.</dd>
              </div>
            </dl>

            <div class="public-summary-box">
              <h4>{{ t('documentSummary') }}</h4>
              <p>{{ language === 'en' ? selectedDoc.summary_en : selectedDoc.summary_ms }}</p>
            </div>

            <div class="button-row">
              <button class="primary" @click="publicDetailsModalOpen = false">
                {{ t('backToPublicPortal') }}
              </button>

            </div>
          </div>
        </div>
      </section>

      <!-- LOGIN / REGISTER -->
      <section v-if="screen === 'auth'" class="auth-layout">
        <div class="auth-info">
          <p class="eyebrow">{{ t('registrationLogin') }}</p>
          <h3>{{ t('authTitle') }}</h3>
          <p>{{ t('authDesc') }}</p>

          <div class="metric-row">
            <div>
              <strong>JWT</strong>
              <span>{{ t('sessionControl') }}</span>
            </div>
            <div>
              <strong>MFA</strong>
              <span>{{ t('extraProtection') }}</span>
            </div>
            <div>
              <strong>Lock</strong>
              <span>{{ t('failedLoginHandling') }}</span>
            </div>
          </div>
        </div>

        <div class="auth-card">

          <div v-if="authMode === 'login'" class="form-panel">
            <h3>{{ t('userLoginAccount') }}</h3>
            <p>{{ t('userLoginDesc') }}</p>

            <InputField
              v-model="loginForm.email"
              :label="t('governmentEmail')"
              placeholder="user@johor.gov.my"
            />

            <InputField
              v-model="loginForm.password"
              :label="t('password')"
              :placeholder="t('enterPassword')"
              type="password"
            />

            <InputField
              v-model="loginForm.mfa"
              :label="t('mfaCode')"
              :placeholder="t('mfaPlaceholder')"
            />

            <div
              v-if="loginForm.email"
              class="lock-status-box"
              :class="{ locked: isPrototypeLocked(loginForm.email) }"
            >
              <strong>{{ t('failedLoginProtection') }}</strong>

              <p v-if="isPrototypeLocked(loginForm.email)">
                {{ t('accountLockedAfterAttempts') }}
              </p>

              <p v-else>
                {{ t('failedAttempts') }}:
                {{ getFailedAttempts(loginForm.email) }} / {{ MAX_LOGIN_ATTEMPTS }}
              </p>

              <small v-if="loginLockMessage">
                {{ loginLockMessage }}
              </small>
            </div>

            <button class="primary full" @click="userLogin">
              {{ t('userLogin') }}
            </button>

            <button
              class="link-button"
              @click="resetAccountType = 'user'; resetModalOpen = true"
            >
              {{ t('forgotPassword') }}
            </button>
          </div>

          <div v-if="authMode === 'register'" class="form-panel">
            <h3>{{ t('registerAccount') }}</h3>
            <p>{{ t('registerDesc') }}</p>

            <InputField
              v-model="registerForm.name"
              :label="t('fullName')"
              :placeholder="t('enterFullName')"
            />

            <InputField
              v-model="registerForm.email"
              :label="t('governmentEmail')"
              placeholder="user@johor.gov.my"
            />

            <InputField
              v-model="registerForm.department"
              :label="t('department')"
              :placeholder="t('enterDepartment')"
            />

            <InputField
              v-model="registerForm.designation"
              :label="t('designation')"
              :placeholder="t('enterDesignation')"
            />

            <InputField
              v-model="registerForm.password"
              :label="t('password')"
              :placeholder="t('passwordPlaceholder')"
              type="password"
            />

            <button class="primary full" @click="registerUser">
              {{ t('submitRegistration') }}
            </button>
          </div>

          <div v-if="authMode === 'admin'" class="form-panel">
            <h3>{{ t('adminLoginAccount') }}</h3>
            <p>{{ t('adminLoginDesc') }}</p>

            <InputField
              v-model="adminLoginForm.email"
              :label="t('adminEmail')"
              placeholder="admin@johor.gov.my"
            />

            <InputField
              v-model="adminLoginForm.password"
              :label="t('password')"
              :placeholder="t('enterPassword')"
              type="password"
            />

            <InputField
              v-model="adminLoginForm.mfa"
              :label="t('mfaCode')"
              :placeholder="t('mfaPlaceholder')"
            />

            <button class="primary full" @click="adminLogin">
              {{ t('adminLogin') }}
            </button>
            <button
              class="link-button"
              @click="resetAccountType = 'admin'; resetModalOpen = true"
            >
              {{ t('forgotPassword') }}
            </button>
          </div>
                </div>

        <div v-if="resetModalOpen" class="modal-overlay" @click.self="resetModalOpen = false">
          <div class="modal-card reset-form-card">
            <div class="section-title">
              <div>
                <p class="eyebrow"> {{ t('accountRecovery') }}</p>
                <h3>
                  {{ resetAccountType === 'admin' ? t('resetAdminPassword') : t('resetUserPassword') }}
                </h3>
              </div>

              <button @click="resetModalOpen = false">
                {{ t('cancel') }}
              </button>
            </div>

            <p class="muted">
              {{
                resetAccountType === 'admin'
                  ? t('resetAdminDesc')
                  : t('resetUserDesc')
              }}
            </p>

            <InputField
              v-model="resetForm.email"
              :label="resetAccountType === 'admin' ? t('adminEmail') : t('governmentEmail')"
              :placeholder="resetAccountType === 'admin' ? t('enterAdminEmail') : t('enterGovernmentEmail')"
            />

            <button class="primary full" @click="sendResetLink">
              {{ t('sendResetLink') }}
            </button>

            <InputField
              v-model="resetForm.code"
              :label="t('verificationCode')"
              :placeholder="t('enterCode')"
            />

            <InputField
              v-model="resetForm.newPassword"
              :label="t('newPassword')"
              :placeholder="t('enterNewPassword')"
              type="password"
            />

            <button class="secondary full" @click="updatePassword">
              {{ t('updatePassword') }}
            </button>
          </div>
        </div>
      </section>

      <!-- PROFILE -->
      <section v-if="screen === 'profile'" class="grid-two">
        <div class="profile-card">
          <div class="avatar">NA</div>
          <h3>{{ profileForm.name }}</h3>
          <p>{{ profileForm.email }}</p>
            <span class="status-pill green">{{ t('administrator') }}</span>
          <dl>
            <div>
              <dt>{{ t('department') }}</dt>
              <dd>{{ profileForm.department }}</dd>
            </div>
            <div>
              <dt>{{ t('designation') }}</dt>
              <dd>{{ profileForm.designation }}</dd>
            </div>
            <div>
              <dt>{{ t('notification') }}</dt>
              <dd>{{ notificationFrequency }}</dd>
            </div>
          </dl>
        </div>

        <div class="detail-card">
          <p class="eyebrow">{{ t('adminProfile') }}</p>
          <h3>{{ t('manageAdminProfile') }}</h3>

          <InputField
            v-model="profileForm.name"
            :label="t('fullName')"
            :placeholder="t('fullNamePlaceholder')"
          />

          <InputField
            v-model="profileForm.email"
            :label="t('email')"
            :placeholder="t('emailPlaceholder')"
            placeholder="aina@johor.gov.my"
          />

          <InputField
            v-model="profileForm.department"
            :label="t('department')"
            :placeholder="t('departmentPlaceholder')"
          />

          <InputField
            v-model="profileForm.designation"
            :label="t('designation')"
            :placeholder="t('designationPlaceholder')"
          />

          <label class="input-group">
            <span>{{ t('notificationPreference') }}</span>
            <select v-model="notificationFrequency">
              <option>{{ t('instant') }}</option>
              <option>{{ t('daily') }}</option>
              <option>{{ t('weekly') }}</option>
            </select>
          </label>

          <button class="primary full" @click="saveProfile">
            {{ t('saveProfile') }}
          </button>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <h3>{{ t('accountSecurity') }}</h3>
            <span :class="mfaEnabled ? 'status-pill green' : 'status-pill amber'">
              {{ mfaEnabled ? t('mfaEnabled') : t('mfaDisabled') }}
            </span>
          </div>

          <div class="settings-grid">
            <SettingCard
              :title="t('changePassword')"
              :desc="t('updatePassword')"
              :action="t('change')"
              @click="changePasswordModalOpen = true"
            />

            <SettingCard
              :title="t('enableMfa')"
              :desc="t('useVerificationCode')"
              :action="mfaEnabled ? t('disable') : t('enable')"
              @click="toggleMfa"
            />

          </div>
        </div>

        <div
          v-if="deactivationModalOpen"
          class="modal-overlay"
          @click.self="deactivationModalOpen = false"
        >
          <div class="modal-card deactivation-form-card">
            <div class="section-title">
              <div>
                <p class="eyebrow">{{ t('accountDeactivation') }}</p>
                <h3>{{ t('requestAccountDeactivation') }}</h3>
              </div>

              <button @click="cancelDeactivationRequest">
                {{ t('cancel') }}
              </button>
            </div>

            <p class="muted">
              {{ t('deactivationDesc') }}
            </p>

            <label class="input-group">
              <span>{{ t('reasonForDeactivation') }}</span>
              <textarea
                v-model="deactivationForm.reason"
                class="feedback-textarea"
                :placeholder="t('deactivationPlaceholder')"
              ></textarea>
            </label>

            <InputField
              v-model="deactivationForm.confirmText"
              :label="t('typeDeactivate')"
              placeholder="DEACTIVATE"
            />

            <button class="primary full danger-button" @click="submitDeactivationRequest">
              {{ t('submitDeactivation') }}
            </button>
          </div>
        </div>
      </section>

      <div
        v-if="changePasswordModalOpen"
        class="modal-overlay"
        @click.self="cancelChangePassword"
      >
        <div class="modal-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">{{ t('accountSecurity') }}</p>
              <h3>{{ t('changePassword') }}</h3>
            </div>

            <button @click="cancelChangePassword">
              {{ t('cancel') }}
            </button>
          </div>

          <InputField
            v-model="changePasswordForm.currentPassword"
            :label="t('currentPassword')"
            :placeholder="t('enterCurrentPassword')"
            type="password"
          />

          <InputField
            v-model="changePasswordForm.newPassword"
            :label="t('newPassword')"
            :placeholder="t('enterNewPassword')"
            type="password"
          />

          <InputField
            v-model="changePasswordForm.confirmPassword"
            :label="t('confirmNewPassword')"
            :placeholder="t('reenterNewPassword')"
            type="password"
          />

          <button class="primary full" @click="submitChangePassword">
            {{ t('updatePassword') }}
          </button>
        </div>
      </div>

      <!-- DOCUMENT MANAGEMENT -->
      <section v-if="screen === 'documents'" class="dashboard-grid">

        <!-- Welcome banner -->
        <div class="welcome-card">
          <p class="eyebrow"> {{ t('documentManagement') }}</p>
          <h3>{{ t('documentManagementTitle') }}</h3>
          <h3>{{ t('administrators') }}</h3>
          <p>{{ t('adminsDocumentDesc') }}</p>
          <h2>{{ t('guestUser') }}</h2>
          <p>{{ t('guestUserDocumentDesc') }}</p>
        </div>

        <div
            v-if="session === 'Admin'"
            class="stats-grid"
          >
                  <StatCard :label="t('totalDocuments')" :value="String(documents.length)" :note="t('repositoryRecords')" />
                  <StatCard :label="t('pendingReview')" :value="String(pendingClassificationCount)" :note="t('aiClassificationQueue')" />
                  <StatCard :label="t('archived')" :value="String(archivedCount)" :note="t('oldCircularVersions')" />

                  <StatCard
                    :label="t('published')"
                    :value="String(documents.filter(d => d.status === 'Published').length)"
                    :note="t('availableDocuments')"
                  />

                  <StatCard
                    :label="t('restricted')"
                    :value="String(documents.filter(d => d.access === 'Restricted').length)"
                    :note="t('protectedDocuments')"
                  />
        </div>


        <!-- ─── MODULE 4.1 DOCUMENT UPLOAD ─── -->
        <div v-if="session === 'Admin'"
        class="wide-card">

          <div class="section-title">
            <div>
              <p class="eyebrow">{{ t('documentUpload') }}</p>
              <h3>{{ t('uploadHrDocument') }}</h3>
            </div>
            <div style="display:flex;gap:10px;">
              <button
                class="primary"
                @click="uploadDocument"
                :disabled="session !== 'Admin'"
              >
                {{ t('uploadSubmitReview') }}
              </button>

              <button
                @click="saveDocumentAsDraft"
                :disabled="session !== 'Admin'"
                >
                {{ t('saveAsDraft') }}
            </button>

            </div>
          </div>

          <!-- Row 1: core metadata -->
          <div class="form-grid">
            <InputField
              v-model="uploadForm.title"
              :label="t('documentTitle')"
              placeholder="Cuti Sakit Pegawai Kerajaan Johor"
            />
            <InputField
              v-model="uploadForm.referenceNo"
              :label="t('officialReferenceNumber')"
              placeholder="JHR/CUTI/2026/01"
            />
            <InputField
              v-model="uploadForm.issuingAuthority"
              :label="t('issuingAuthority')"
              placeholder="Human Resource Management Division"
            />
            <InputField
              v-model="uploadForm.effectiveDate"
              :label="t('effectiveDate') + ' *'"
              placeholder="2026-01-12"
            />
            <InputField
              v-model="uploadForm.expiryDate"
              :label="t('expiryDate')"
              placeholder="2028-01-12 (optional)"
            />
            <label class="input-group">
              <span>{{ t('departmentTag') }}</span>
              <select v-model="uploadForm.departmentTag">
                <option value="">{{ t('selectDepartment') }}</option>
                <option>Human Resource Management Division</option>
                <option>Finance Division</option>
                <option>Administration Division</option>
                <option>Legal Division</option>
                <option>Public Works Department</option>
                <option>Education Department</option>
                <option>Health Department</option>
              </select>
            </label>
          </div>

          <!-- Row 2: type / category / access / language -->
          <div class="form-grid">
            <label class="input-group">
              <span>{{ t('documentType') }} *</span>
              <select v-model="uploadForm.type">
                <option value="Circular">{{ tv('Circular') }}</option>
                <option value="Guideline">{{ tv('Guideline') }}</option>
                <option value="Policy">{{ tv('Policy') }}</option>
                <option value="Memo">{{ tv('Memo') }}</option>
                <option value="Form">{{ tv('Form') }}</option>
                <option value="Reference Document">{{ tv('Reference Document') }}</option>
                <option value="Administrative Decision">{{ tv('Administrative Decision') }}</option>
              </select>
            </label>
            <label class="input-group">
              <span>{{ t('category') }} *</span>
              <select v-model="uploadForm.category">
                <option value="Leave Policy">{{ tv('Leave Policy') }}</option>
                <option value="Promotion">{{ tv('Promotion') }}</option>
                <option value="Discipline">{{ tv('Discipline') }}</option>
                <option value="Salary">{{ tv('Salary') }}</option>
                <option value="Staff Benefits">{{ tv('Staff Benefits') }}</option>
                <option value="Overseas Travel">{{ tv('Overseas Travel') }}</option>
                <option value="Contract Service">{{ tv('Contract Service') }}</option>
                <option value="Promotion and Discipline">{{ tv('Promotion and Discipline') }}</option>
              </select>
            </label>
            <label class="input-group">
              <span>{{ t('accessLevel') }} *</span>
              <select v-model="uploadForm.access">
                <option value="Public">{{ tv('Public') }}</option>
                <option value="Registered">{{ tv('Registered') }}</option>
                <option value="Restricted">{{ tv('Restricted') }}</option>
              </select>
            </label>
            <label class="input-group">
              <span>{{ t('language') }} *</span>
              <select v-model="uploadForm.language">
                <option value="BM">{{ tv('Bahasa Malaysia') }}</option>
                <option value="EN">{{ tv('English') }}</option>
                <option value="BOTH">{{ tv('Both (BM & EN)') }}</option>
              </select>
            </label>
          </div>

          <!-- File picker -->
          <label class="input-group" style="margin-bottom:16px;">
            <span>{{ t('pdfFile') }} *</span>
            <div class="file-upload-box" @click="triggerFileInput" @dragover.prevent @drop.prevent="handleFileDrop">
              <input
                ref="fileInputRef"
                type="file"
                accept=".pdf"
                style="display:none;"
                @change="handleFileSelect"
              />
              <div v-if="!uploadForm.fileName" class="file-upload-placeholder">
                <strong>{{t('choosePdfFile')}}</strong>
                <span>{{ t('dragDropPdf') }}</span>
              </div>
              <div v-else class="file-upload-selected">
                <span class="status-pill green">✓ {{ t('fileSelected') }}</span>
                <strong>{{ uploadForm.fileName }}</strong>
                <span>{{ uploadForm.fileSizeKb ? (uploadForm.fileSizeKb / 1024).toFixed(2) + ' MB' : '' }}</span>
                <button @click.stop="clearFile" style="color:var(--johor-red);">{{ t('remove') }}</button>
              </div>
            </div>
          </label>

          <!-- Upload status message -->
          <div v-if="uploadStatus" :class="uploadStatus.type === 'success' ? 'upload-status success' : 'upload-status error'">
            {{ uploadStatus.message }}
          </div>
        </div>

        <!-- ─── MODULE 4.2 AI CLASSIFICATION REVIEW ─── -->
        <div v-if="session === 'Admin'"
        class="wide-card">

          <div class="section-title">
            <div>
              <p class="eyebrow">{{ t('aiClassificationReview') }}</p>
              <h3>{{ t('suggestedDocumentCategories') }}</h3>
            </div>
            <button @click="refreshClassification">{{ t('refreshSuggestions') }}</button>
          </div>
          <p style="color:var(--muted);margin:0 0 18px;">{{t('classificationDesc')}}</p>

          <div v-if="classificationQueue.length === 0" class="empty-state">
            <p>{{t('noClassification')}}</p>
          </div>

          <div class="doc-grid" v-else>
            <article
              v-for="item in classificationQueue"
              :key="item.id"
              class="doc-card"
            >
              <span :class="{
                'status-pill green': item.status === 'Approved',
                'status-pill amber': item.status === 'Pending Review' || item.status === 'Needs Edit',
                'status-pill red': item.status === 'Rejected'
              }">{{ item.status }}</span>

              <h4>{{ item.title }}</h4>

              <!-- Confidence score bar -->
              <div style="display:flex;align-items:center;gap:8px;margin:0;">
                <span style="font-size:12px;color:var(--muted);font-weight:700;">{{ t('aiConfidence') }}</span>
                <div class="confidence-bar">
                  <div class="confidence-fill" :style="{ width: (item.confidence || 75) + '%' }"></div>
                </div>
                <span style="font-size:12px;font-weight:800;color:var(--johor-blue);">{{ item.confidence || 75 }}%</span>
              </div>

              <!-- Suggested categories -->
              <div>
                <span style="font-size:12px;color:var(--muted);font-weight:700;display:block;margin-bottom:6px;">{{ t('suggestedCategories') }}</span>
                <div style="display:flex;gap:6px;flex-wrap:wrap;">
                  <span v-for="s in item.suggestions" :key="s">{{ s }}</span>
                </div>
              </div>

              <!-- Suggested department tags -->
              <div>
                <span style="font-size:12px;color:var(--muted);font-weight:700;display:block;margin-bottom:6px;">{{t('departmentTags')}}</span>
                <div style="display:flex;gap:6px;flex-wrap:wrap;">
                  <span v-for="tag in item.tags" :key="tag">{{ tag }}</span>
                </div>
              </div>

              <!-- Modify fields shown when editing -->
              <div v-if="item.editing" style="display:grid;gap:8px;margin-top:4px;">
                <label class="input-group" style="margin:0;">
                  <span>{{ t('modifyCategory') }}</span>
                  <select v-model="item.modifiedCategory">
                    <option v-for="s in item.suggestions" :key="s" :value="s">{{ s }}</option>
                    <option>Leave Policy</option>
                    <option>Promotion</option>
                    <option>Discipline</option>
                    <option>Salary</option>
                    <option>Staff Benefits</option>
                    <option>Overseas Travel</option>
                    <option>Contract Service</option>
                  </select>
                </label>
                <label class="input-group" style="margin:0;">
                  <span>{{ t('modifyDepartmentTag') }}</span>
                  <select v-model="item.modifiedDepartmentTag">
                    <option>Human Resource Management Division</option>
                    <option>Finance Division</option>
                    <option>Administration Division</option>
                    <option>Legal Division</option>
                  </select>
                </label>
                <div style="display:flex;gap:8px;">
                  <button class="primary" style="flex:1;" @click="confirmModifyClassification(item)"> {{ t('saveChanges') }}</button>
                  <button style="flex:1;" @click="item.editing = false"> {{ t('cancel') }}</button>
                </div>
              </div>

              <!-- Action buttons shown when not editing -->
              <div v-else style="display:flex;gap:8px;margin-top:4px;">
                <button
                  class="primary"
                  style="flex:1;"
                  :disabled="item.status === 'Approved'"
                  @click="approveClassification(item)"
                >
                  {{ item.status === 'Approved' ? '✓ ' + t('approved') : t('approve') }}
                </button>
                <button
                  style="flex:1;"
                  :disabled="item.status === 'Approved'"
                  @click="startModifyClassification(item)"
                >
                  {{ t('modify') }}
                </button>
                <button
                  class="secondary"
                  :disabled="item.status === 'Approved'"
                  @click="rejectClassification(item)"
                >
                  {{ t('reject') }}
                </button>
              </div>
            </article>
          </div>
        </div>

        <!-- ─── MODULE 4.3 + 4.4 DOCUMENT REPOSITORY & SEARCH ─── -->
        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Repository &amp; Search</p>
              <h3>{{ t('searchManageDocuments') }}</h3>
            </div>
            <button
              v-if="session === 'Admin'"
              class="primary"
              @click="openNewVersionModal"
            >
            {{ t('uploadNewVersion') }}
            </button>
          </div>

          <!-- 5-column filter toolbar -->
          <div class="repo-filters">
            <input
                v-model="repoQuery"
                :placeholder="t('searchPlaceholder')"
              />
            <select v-model="repoType">
              <option value="">{{t('allTypes')}}</option>
              <option>Circular</option>
              <option>Guideline</option>
              <option>Policy</option>
              <option>Memo</option>
              <option>Form</option>
              <option>Reference Document</option>
              <option>Administrative Decision</option>
            </select>
            <select v-model="repoCategory">
              <option value="">{{t('allCategories')}}</option>
              <option>Leave Policy</option>
              <option>Promotion</option>
              <option>Discipline</option>
              <option>Salary</option>
              <option>Staff Benefits</option>
              <option>Overseas Travel</option>
              <option>Contract Service</option>
              <option>Promotion and Discipline</option>
            </select>
            <select v-model="repoStatus">
              <option value="">All Statuses</option>
              <option>Published</option>
              <option>Draft</option>
              <option>Archived</option>
              <option>Pending Review</option>
            </select>
            <select v-model="repoAccess">
              <option value="">{{t('allAccessLevels')}}</option>
              <option>Public</option>
              <option>Registered</option>
              <option>Restricted</option>
            </select>
          </div>

          <!-- Result count -->
          <p style="color:var(--muted);font-size:13px;font-weight:700;margin:0 0 14px;">
            Showing {{ repositoryDocs.length }} result{{ repositoryDocs.length !== 1 ? 's' : '' }}
            <span v-if="repoQuery"> for "{{ repoQuery }}"</span>
          </p>

          <div class="table-card">
            <table>
              <thead>
                <tr>
                  <th>{{ t('document') }}</th>
                  <th>{{ t('referenceNo') }}</th>
                  <th>{{ t('category') }}</th>
                  <th>{{ t('access') }}</th>
                  <th>{{ t('status') }}</th>
                  <th>{{ t('effectiveDate') }}</th>
                  <th>{{ t('views') }}</th>
                  <th>{{ t('actions') }}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-if="repositoryDocs.length === 0">
                  <td colspan="9" style="text-align:center;color:var(--muted);padding:32px;">
                    {{t('noDocumentsMatch')}}
                  </td>
                </tr>
                <tr v-for="doc in repositoryDocs" :key="doc.documentId">
                  <td>
                    <strong>{{ doc.title }}</strong>
                    <span>{{ doc.type }} · v{{ doc.version }}</span>
                  </td>
                  <td>{{ doc.referenceNo }}</td>
                  <td>{{ doc.category }}</td>
              
                  <td>
                    <span :class="{
                      'status-pill green': doc.access === 'Public',
                      'status-pill amber': doc.access === 'Registered',
                      'status-pill red': doc.access === 'Restricted'
                    }">{{ doc.access }}</span>
                  </td>
                  <td>
                    <span :class="{
                      'status-pill green': doc.status === 'Published',
                      'status-pill amber': doc.status === 'Draft' || doc.status === 'Pending Review',
                      'status-pill red': doc.status === 'Archived'
                    }">{{ doc.status }}</span>
                  </td>
                  <td>{{ doc.effectiveDate || '—' }}</td>
                  <td>{{ doc.totalViews || 0 }}</td>
                    <td>

  <div class="action-group">

    <button @click="openPreview(doc)">
      {{t('viewDetails')}}
    </button>

    <button
      class="secondary"
      @click="downloadDocument(doc)"
    >
      {{t('download')}}
    </button>

    <button
      v-if="session === 'Admin'"
      class="secondary"
      @click="openVersionModal(doc)"
    >
      {{t('newVersion')}}
    </button>

    <button
      v-if="session === 'Admin'"
      class="secondary"
      @click="archiveDocument(doc)"
    >
      {{t('archive')}}
    </button>

    <button
      v-if="session === 'Admin' && doc.status === 'Archived'"
      class="secondary"
      @click="restoreDocument(doc)"
    >
      {{t('restore')}}
    </button>

  
  </div>

                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- ─── MODULE 4.5 ARCHIVE MODAL ─── -->
        <div v-if="showArchiveModal" class="modal-overlay" @click.self="showArchiveModal = false">
          <div v-if="session === 'Admin'"
          class="modal-card">

            <div class="section-title" style="margin-bottom:16px;">
              <div>
                <p class="eyebrow">{{ t('archiveDocument') }}</p>
                <h3>Archive: {{ archiveTarget?.referenceNo }}</h3>
              </div>
              <button @click="showArchiveModal = false">✕</button>
            </div>

            <p style="color:var(--muted);margin:0 0 18px;">
              {{t('archiveDesc')}}
            </p>

            <label class="input-group">
              <span>{{t('archiveReason')}} *</span>
              <select v-model="archiveForm.reason">
                <option value="">{{t('selectReason')}}</option>
                <option value="superseded">{{t('supersededReason')}}</option>
                <option value="expired">{{t('expiredReason')}}</option>
                <option value="withdrawn">{{t('withdrawnReason')}}</option>
                <option value="other">{{t('otherReason')}}</option>
              </select>
            </label>

            <label class="input-group">
              <span>{{t('successorReference')}}</span>
              <input v-model="archiveForm.successorReference" placeholder="e.g. JHR/CUTI/2026/02" />
            </label>

            <label class="input-group">
              <span>{{t('additionalNotes')}}</span>
              <textarea
                v-model="archiveForm.reasonDetails"
                :placeholder="t('additionalNotesPlaceholder')"
                rows="3"
                style="width:100%;border:1px solid var(--line);border-radius:16px;padding:14px 16px;font:inherit;resize:vertical;"
              ></textarea>
            </label>

            <div style="display:flex;gap:10px;margin-top:8px;">
              <button class="secondary" style="flex:1;" @click="confirmArchive">{{t('confirmArchive')}}</button>
              <button style="flex:1;" @click="showArchiveModal = false">{{t('cancel')}}</button>
            </div>
          </div>
        </div>

        <!-- ─── MODULE 4.5 UPLOAD NEW VERSION MODAL ─── -->
        <div v-if="showVersionModal" class="modal-overlay" @click.self="showVersionModal = false">
          <div class="modal-card">
            <div class="section-title" style="margin-bottom:16px;">
              <div>
                <p class="eyebrow">{{t('versionManagement')}}</p>
                <h3>{{t('uploadNewVersion')}}</h3>
              </div>
              <button @click="showVersionModal = false">✕</button>
            </div>

            <label class="input-group">
              <span>{{t('documentToUpdate')}}</span>
              <select v-model="versionForm.documentId">
                <option value="">{{t('selectDocument')}}</option>
                <option
                  v-for="doc in documents.filter(d => d.status !== 'Archived')"
                  :key="doc.documentId"
                  :value="doc.documentId"
                >
                  {{ doc.referenceNo }} — {{ doc.title }}
                </option>
              </select>
            </label>

            <div v-if="versionForm.documentId" class="version-info-box">
              <span class="status-pill">
                {{t('currentVersion')}}: v{{ documents.find(d => d.documentId == versionForm.documentId)?.version || '1.0' }}
              </span>
              <span style="color:var(--muted);font-size:13px;">{{t('newVersionWillBe')}}: v{{ nextVersionNumber }}</span>
            </div>

            <label class="input-group">
              <span>{{t('updateType')}}</span>
              <select v-model="versionForm.updateType">
                <option value="">— {{t('selectType')}} —</option>
                <option value="amendment">{{t('amendment')}}</option>
                <option value="replacement">{{t('replacement')}}</option>
                <option value="correction">{{t('correction')}}</option>
                <option value="withdrawal">{{t('withdrawal')}}</option>
              </select>
            </label>

            <label class="input-group">
              <span>{{t('changeSummary')}}</span>
              <textarea
                v-model="versionForm.changeSummary"
                :placeholder="t('changeSummaryPlaceholder')"
                rows="3"
                style="width:100%;border:1px solid var(--line);border-radius:16px;padding:14px 16px;font:inherit;resize:vertical;"
              ></textarea>
            </label>

            <label class="input-group">
              <span>{{t('newPdfFile')}}</span>
              <div class="file-upload-box" @click="triggerVersionFileInput" @dragover.prevent @drop.prevent="handleVersionFileDrop">
                <input
                  ref="versionFileInputRef"
                  type="file"
                  accept=".pdf"
                  style="display:none;"
                  @change="handleVersionFileSelect"
                />
                <div v-if="!versionForm.fileName" class="file-upload-placeholder">
                  <strong>{{t('choosePdfFile')}}</strong>
                  <span>{{t('dragDropPdf')}}</span>
                </div>
                <div v-else class="file-upload-selected">
                  <span class="status-pill green">✓ {{t('fileSelected')}}</span>
                  <strong>{{ versionForm.fileName }}</strong>
                </div>
              </div>
            </label>

            <label class="input-group">
              <span>{{t('newEffectiveDate')}}</span>
              <input v-model="versionForm.newEffectiveDate" type="date" />
            </label>

            <div style="display:flex;gap:10px;margin-top:8px;">
              <button class="primary" style="flex:1;" @click="confirmUploadNewVersion">Upload New Version</button>
              <button style="flex:1;" @click="showVersionModal = false">Cancel</button>
            </div>
          </div>
        </div>

       <div
  v-if="showPreviewModal && previewDocument"
  class="modal-overlay"
  @click.self="closePreview"
>
  <div class="modal-card preview-modal">

    <div class="preview-header">
      <div>
        <p class="eyebrow">{{t('documentDetails')}}</p>
        <h2>{{ previewDocument.title }}</h2>
      </div>

  
    </div>

    <div class="preview-badges">
      <span class="status-pill green">
        {{ previewDocument.access }}
      </span>

      <span class="status-pill">
        {{ previewDocument.status }}
      </span>

      <span class="status-pill">
        {{t('version')}} {{ previewDocument.version }}
      </span>
    </div>

    <div class="preview-grid">

      <div class="info-card">
        <span>{{t('referenceNumber')}}</span>
        <strong>{{ previewDocument.referenceNo }}</strong>
      </div>

      <div class="info-card">
        <span>{{t('category')}}</span>
        <strong>{{ previewDocument.category }}</strong>
      </div>

      <div class="info-card">
        <span>{{t('documentType')}}</span>
        <strong>{{ previewDocument.type }}</strong>
      </div>

      <div class="info-card">
        <span>{{t('department')}}</span>
        <strong>{{ previewDocument.departmentTag }}</strong>
      </div>

      <div class="info-card">
        <span>{{t('effectiveDate')}}</span>
        <strong>{{ previewDocument.effectiveDate }}</strong>
      </div>

      <div class="info-card">
        <span>{{t('totalViews')}}</span>
        <strong>{{ previewDocument.totalViews || 0 }}</strong>
      </div>

    </div>

    <div class="summary-card">
      <h4>{{t('documentSummary')}}</h4>
      <p>{{ language === 'en' ? previewDocument.summary_en : previewDocument.summary_ms }}</p>
    </div>

    <div class="button-row">

      <button @click="closePreview">
        {{t('close')}}
      </button>
    </div>

  </div>
</div>



        <!-- ─── AUDIT LOG ─── -->
        <div
            v-if="session === 'Admin'"
            class="wide-card"
        >

          <div class="section-title">
            <div>
              <p class="eyebrow">{{t('documentAuditTrail')}}</p>
              <h3>{{t('recentDocumentActions')}}</h3>
            </div>
            <button @click="toast = t('exportLog')">{{ t('exportLog') }}</button>
          </div>

          <div class="log-list">
            <div v-if="documentAuditLog.length === 0" class="empty-state">
              <p>{{t('noAuditActions')}}</p>
            </div>
            <div
              v-for="entry in documentAuditLog"
              :key="entry.id"
              class="log-item"
            >
              <div :class="entry.actionType === 'archive' ? 'dot amber-dot' : 'dot green-dot'"></div>
              <div>
                <strong>{{ entry.actionLabel }}</strong>
                <p>{{ entry.documentTitle }} · {{ entry.actionDetails }}</p>
              </div>
              <em>{{ entry.createdAt }}</em>
            </div>
          </div>
        </div>

        

      </section>  

      

      <!-- SMART SUPPORT -->
      <section v-if="screen === 'smart'" class="grid-two">
        <div class="hero-card">
          <p class="eyebrow">{{ t('smartSearch') }}</p>
          <h3>{{t('smartSearchTitle')}}</h3>
          <p>{{t('smartSearchDesc')}}</p>

          <div class="search-box single">
            <input
              v-model="smartQuery"
              :placeholder="t('smartSearchPlaceholder')"
              @keyup.enter="performSmartSearch"
            />
          </div>

          <div v-if="searchSuggestions.length > 0" class="suggestion-list">
            <button
              v-for="suggestion in searchSuggestions"
              :key="suggestion.suggestionId"
              @click="selectSearchSuggestion(suggestion)"
            >
              {{ language === 'en' ? suggestion.suggestionText_en : suggestion.suggestionText_ms }}
            </button>
          </div>

          <label class="field-label">{{ t('sortResults') }}</label>
          <select v-model="smartSortBy" class="feedback-input">
          <option value="relevance">{{ t('relevance') }}</option>
          <option value="latest">{{ t('latestUpdated') }}</option>
          <option value="title">{{ t('titleAz') }}</option>
          <option value="most_viewed">{{ t('mostViewed') }}</option>
          </select>

          <button class="primary" @click="performSmartSearch">
            {{ t('performSmartSearch') }}
          </button>

          <button
            v-if="hasSearched"
            @click="clearSearchResults"
          >
            {{ t('clearSearch') }}
          </button>

          <div class="history-panel">
            <p class="eyebrow">{{ t('recentSearchHistory') }}</p>

            <button
              v-for="history in recentSearchHistory"
              :key="history.searchId"
              class="history-chip"
              @click="smartQuery = history.searchQuery; performSmartSearch()"
            >
              {{ history.searchQuery }}
            </button>

            <p v-if="recentSearchHistory.length === 0" class="muted">
              {{ t('noRecentSearch') }}
            </p>
          </div>
        </div>

        <div class="detail-card chatbot-card">
          <p class="eyebrow">{{ t('hrAssistant') }}</p>
          <h3>{{ t('askChatbot') }}</h3>

          <div class="chat-window">
            <div
              v-for="(message, index) in chatMessages"
              :key="index"
              :class="message.sender === 'bot' ? 'chat-bubble bot' : 'chat-bubble user'"
            >
              {{ message.text }}
            </div>
          </div>

          <div class="suggested-question-box">
            <p>{{ t('suggestedQuestions') }}</p>
            <div class="quick-question-row">
              <button
                v-for="question in suggestedQuestions"
                :key="question"
                @click="sendSuggestedQuestion(question)"
              >
                {{ question }}
              </button>
            </div>
          </div>

          <div class="chat-input-row">
            <input
              v-model="chatInput"
              :placeholder="t('chatbotPlaceholder')"
              @keyup.enter="sendChatMessage"
            />
            <button class="primary" @click="sendChatMessage">
              {{ t('send') }}
            </button>
          </div>

          <div class="assistant-actions">
            <button @click="rateChatbotResponse(1)">
              👍 {{ t('helpful') }}
            </button>

            <button @click="rateChatbotResponse(0)">
              👎 {{ t('notHelpful') }}
            </button>

            <button @click="openEscalationPanel">
              {{ t('escalateHrOfficer') }}
            </button>
          </div>

          <input
            v-model="ratingComment"
            class="feedback-input"
            :placeholder="t('optionalFeedback')"
          />

          <div v-if="escalationPanelOpen" class="escalation-panel">
            <div class="section-title">
              <div>
                <p class="eyebrow">{{ t('hrOfficerSupport') }}</p>
                <h3>{{ t('escalateQuestion') }}</h3>
              </div>

              <button @click="cancelEscalationPanel">
                {{ t('cancel') }}
              </button>
            </div>

            <label class="field-label">{{ t('question') }}</label>
            <input
              v-model="escalationForm.question"
              class="feedback-input"
              :placeholder="t('questionPlaceholder')"
            />

            <label class="field-label">{{ t('description') }}</label>
            <textarea
              v-model="escalationForm.description"
              class="feedback-textarea"
              placeholder="Describe why this question needs HR officer support..."
            ></textarea>

            <button class="primary" @click="submitEscalationRequest">
              {{ t('submitHrOfficer') }}
            </button>
          </div>

          <div class="history-panel">
            <p class="eyebrow">{{ t('conversationHistory') }}</p>

            <div
              v-for="item in conversationHistory"
              :key="item.conversationId"
              class="history-item"
            >
              <strong>{{ item.questionText }}</strong>
              <p>{{ item.responseText }}</p>
              <small>
                {{ t('status') }}: {{ item.conversationStatus }}
                <span v-if="item.ratingValue !== null">
                  | {{ t('rating') }}: {{ item.ratingValue === 1 ? t('helpful') : t('notHelpful') }}
                </span>
              </small>
            </div>

            <p v-if="conversationHistory.length === 0" class="muted">
              {{t('noConversation')}}
            </p>
          </div>

          <div class="history-panel">
            <p class="eyebrow">{{ t('escalationRequests') }}</p>

            <div
              v-for="request in escalationRequests.filter((item) => item.userId === currentUserId)"
              :key="request.escalationId"
              class="history-item"
            >
              <strong>{{ request.escalationQuestion }}</strong>
              <p>{{ request.escalationDescription }}</p>
              <small>
                Status: {{ request.escalationStatus }}
                <span v-if="request.submittedAt">
                  | Submitted: {{ new Date(request.submittedAt).toLocaleString() }}
                </span>
              </small>
            </div>

            <p
              v-if="escalationRequests.filter((item) => item.userId === currentUserId).length === 0"
              class="muted"
            >
              {{ t('noEscalation') }}
            </p>
          </div>
        </div>

        <div v-if="hasSearched" class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">{{ t('searchResults') }}</p>
              <h3>{{ t('smartSearchResults') }}</h3>
            </div>

            <button @click="clearSearchResults">
              {{ t('clear') }}
            </button>
          </div>

          <div class="doc-grid">
            <article
              v-for="doc in searchResults"
              :key="doc.documentId"
              class="doc-card"
            >
              <h3>{{ t('smartSearchResults') }}</h3>

              <h4 v-html="highlightMatchedContent(doc.title)"></h4>

              <p
                v-if="doc.summary"
                v-html="highlightMatchedContent(doc.summary)"
              ></p>

              <div>
                <span>{{ doc.category }}</span>
                <span>{{ doc.type }}</span>
              </div>

              <div class="button-row">
                <button class="primary" @click="saveSearchResultDocument(doc)">
                  {{ t('saveDocument') }}
                </button>

                <button @click="generateSearchResultSummary(doc)">
                  {{ t('generateSummary') }}
                </button>
              </div>
            </article>

            <div v-if="searchResults.length === 0" class="empty-state">
              {{ t('noMatchingSmartDocument') }}
            </div>
          </div>
        </div>

        <div v-if="searchResultSummary" class="wide-card summary-panel">
          <div class="section-title">
            <div>
              <p class="eyebrow">{{ t('aiDocumentSummary') }}</p>
              <h3>{{ selectedSearchSummaryDoc?.title }}</h3>
            </div>

            <button @click="searchResultSummary = ''; selectedSearchSummaryDoc = null">
              {{ t('close') }}
            </button>
          </div>

          <p>{{ searchResultSummary }}</p>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">{{ t('recommendations') }}</p>
              <h3>{{ t('recommendedDocuments') }}</h3>
            </div>

            <button @click="refreshRecommendations">
              {{ t('refresh') }}
            </button>
          </div>

          <div class="doc-grid">
            <article
              v-for="doc in smartResults"
              :key="doc.documentId"
              class="doc-card"
            >
              <span class="status-pill green">{{ t('recommended') }}</span>
              <h4>{{ doc.title }}</h4>

              <p v-if="doc.reason">
                {{ t('reason') }}: {{ doc.reason }}
              </p>

              <p v-if="doc.summary" v-html="highlightMatchedContent(doc.summary)"></p>

              <p v-if="doc.relevanceScore">
                {{ t('relevanceScore') }}: {{ doc.relevanceScore }}
              </p>

              <div>
                <span>{{ doc.category }}</span>
                <span>{{ doc.type }}</span>
              </div>

              <div class="button-row">
                <button class="primary" @click="saveDocument(doc)">
                  {{ t('saveDocument') }}
                </button>

                <button @click="generateDocumentSummary(doc)">
                  {{ t('generateSummary') }}
                </button>

                <button @click="openRecommendationReport(doc)">
                  {{ t('reportIncorrect') }}
                </button>
              </div>
            </article>

            <div v-if="smartResults.length === 0" class="empty-state">
              {{ t('noRecommended') }}
            </div>
          </div>

          <div v-if="generatedSummary" class="summary-panel">
            <div class="section-title">
              <div>
                <p class="eyebrow">{{ t('aiDocumentSummary') }}</p>
                <h3>{{ selectedSummaryDoc?.title }}</h3>
              </div>

              <button @click="generatedSummary = ''">
                {{ t('close') }}
              </button>
            </div>

            <p>{{ generatedSummary }}</p>
          </div>

          <div v-if="reportDialogOpen" class="report-panel">
            <div class="section-title">
              <div>
                <p class="eyebrow">{{ t('recommendationReport') }}</p>
                <h3>{{ t('reportIncorrectRecommendation') }}</h3>
              </div>

              <button @click="cancelRecommendationReport">
                {{ t('cancel') }}
              </button>
            </div>

            <p v-if="selectedRecommendation">
              Reporting: <strong>{{ selectedRecommendation.title }}</strong>
            </p>

            <label class="field-label">{{ t('reason') }}</label>
            <select v-model="recommendationReportForm.reportReason">
              <option>{{ t('irrelevant') }}</option>
              <option>{{ t('inaccurate') }}</option>
              <option>{{ t('outdated') }}</option>
              <option>{{ t('inappropriate') }}</option>
              <option>{{ t('others') }}</option>
            </select>

            <label class="field-label">{{ t('description') }}</label>
            <textarea
              v-model="recommendationReportForm.reportDescription"
              placeholder="Explain why this recommendation is incorrect..."
            ></textarea>

            <button class="primary full" @click="submitRecommendationReport">
              {{ t('submitReport') }}
            </button>
          </div>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">{{ t('faq') }}</p>
              <h3>{{ t('frequentlyAskedQuestions') }}</h3>
            </div>

            <button @click="openEscalationPanel">
              {{t('escalateHrOfficer')}}
            </button>
          </div>

          <div class="faq-list">
            <details v-for="faq in faqs" :key="faq.id" open>
              <summary>{{ language === 'en' ? faq.question_en : faq.question_ms }}</summary>
              <p>{{ language === 'en' ? faq.answer_en : faq.answer_ms }}</p>
            </details>
          </div>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">{{ t('trendingDocuments') }}</p>
              <h3>{{ t('popularDocuments') }}</h3>
            </div>
          </div>

          <div class="doc-grid">
            <article
              v-for="doc in trendingDocuments"
              :key="doc.trendingId"
              class="doc-card"
    >
              <span class="status-pill green">{{ t('trending') }}</span>
              <h4>{{ doc.title }}</h4>
              <p>{{ language === 'en' ? doc.summary_en : doc.summary_ms }}</p>

              <div>
                <span>{{ t('views') }}: {{ doc.viewCount }}</span>
                <span>{{ t('score') }}: {{ doc.trendingScore }}</span>
              </div>
            </article>
          </div>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">{{t('frequentlyUsedPolicies')}}</p>
              <h3>{{t('suggestedFrequentlyUsed')}}</h3>
            </div>
          </div>

          <div class="doc-grid">
            <article
              v-for="doc in frequentlyUsedPolicies"
              :key="doc.documentId"
              class="doc-card"
            >
              <span class="status-pill amber">{{ t('frequentlyUsed') }}</span>
              <h4>{{ doc.title }}</h4>
              <p>{{ language === 'en' ? doc.summary_en : doc.summary_ms }}</p>

              <div>
                <span>{{ doc.category }}</span>
                <span>Views: {{ doc.totalViews }}</span>
              </div>
            </article>
          </div>
        </div>


      </section>

      <!-- PERSONAL STORAGE AND NOTIFICATION -->
      <section v-if="screen === 'personal'" class="dashboard-grid">
        <div class="welcome-card">
          <p class="eyebrow">{{ t('savedNotifications') }}</p>
          <h3>{{ t('savedNotificationsTitle') }}</h3>
          <p>{{ t('savedNotificationsDesc') }}</p>
        </div>

        <StatCard label="Saved" :value="String(savedDocuments.length)" note="Personal collection" />
        <StatCard label="Unread Alerts" :value="String(unreadNotifications)" note="Policy updates" />
        <StatCard label="Notes" :value="String(savedDocuments.length)" note="Personal notes" />

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">{{ t('notificationPreferences') }}</p>
              <h3>{{ t('manageAlerts') }}</h3>
            </div>

            <button @click="saveNotificationPreferences">
              {{ t('savePreferences') }}
            </button>
          </div>

          <div class="settings-grid">
            <SettingCard
              title="Policy Updates"
              desc="Notify when new relevant documents are published."
              :action="policyUpdateEnabled ? 'Enabled' : 'Disabled'"
              @click="policyUpdateEnabled = !policyUpdateEnabled"
            />

            <SettingCard
              title="Saved Document Updates"
              desc="Notify when bookmarked documents are replaced."
              :action="savedUpdateEnabled ? 'Enabled' : 'Disabled'"
              @click="savedUpdateEnabled = !savedUpdateEnabled"
            />

            <SettingCard
              title="Frequency"
              desc="Choose instant, daily or weekly notifications."
              :action="notificationFrequency"
              @click="cycleNotificationFrequency"
            />

            <SettingCard
              title="Delivery Channel"
              desc="Choose how notifications are delivered."
              :action="deliveryChannel"
              @click="deliveryChannel = deliveryChannel === 'In-System' ? 'Email' : deliveryChannel === 'Email' ? 'Both' : 'In-System'"
            />
          </div>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">{{ t('smartAlerts') }}</p>
              <h3>{{ t('recommendedAlerts') }}</h3>
            </div>

            <button @click="loadNotifications">
              {{ t('refreshAlerts') }}
            </button>
          </div>

          <div
            v-for="alert in smartAlerts"
            :key="alert.id"
            class="smart-alert-item"
          >
            <span :class="alert.read ? 'dot green-dot' : 'dot amber-dot'"></span>

            <div>
              <strong>{{ alert.title }}</strong>
              <p>{{ alert.message }}</p>
              <small>
                Type: {{ alert.type }}
                <span v-if="alert.time">
                  | {{ new Date(alert.time).toLocaleString() }}
                </span>
              </small>
            </div>

            <button
              v-if="!alert.read"
              @click="markNotificationRead(alert.id)"
            >
              {{ t('markRead') }}
            </button>
          </div>

          <p v-if="smartAlerts.length === 0" class="muted">
            {{ t('noSmartAlerts') }}
          </p>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">{{ t('recentNotifications') }}</p>
              <h3>{{ t('policyUpdatesAlerts') }}</h3>
            </div>
            <button @click="markAllNotificationsRead">
              {{ t('markAllRead') }}
            </button>
          </div>

          <div class="log-list">
            <div
              v-for="notice in policyNotifications"
              :key="notice.id"
              class="log-item"
            >
              <span :class="notice.read ? 'dot green-dot' : 'dot amber-dot'"></span>

              <div>
                <strong>{{ notice.title }}</strong>
                <p>{{ notice.message }}</p>
                <small>Type: {{ notice.type }}</small>
              </div>

              <div class="notification-actions">
                <em>{{ new Date(notice.time).toLocaleString() }}</em>

                <button
                  v-if="!notice.read"
                  @click="markNotificationRead(notice.id)"
                >
                  {{ t('markRead') }}
                </button>
              </div>
            </div>

            <p v-if="policyNotifications.length === 0" class="muted">
              {{ t('noNotifications') }}
            </p>
          </div>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">{{ t('userFeedback') }}</p>
              <h3>{{ t('submitFeedback') }}</h3>
            </div>
          </div>

          <label class="field-label">{{ t('feedbackCategory') }}</label>
          <select v-model="feedbackForm.feedbackCategory" class="feedback-input">
            <option>{{ t('systemIssue') }}</option>
            <option>{{ t('documentIssue') }}</option>
            <option>{{ t('chatbotIssue') }}</option>
            <option>{{ t('searchIssue') }}</option>
            <option>{{ t('suggestion') }}</option>
            <option>{{ t('others') }}</option>
          </select>

          <label class="field-label">{{ t('feedbackContent') }}</label>
          <textarea
            v-model="feedbackForm.feedbackContent"
            class="feedback-textarea"
            placeholder="Write your feedback here..."
          ></textarea>

          <button class="primary" @click="submitUserFeedback">
            {{ t('submitFeedback') }}
          </button>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">{{ t('personalStorage') }}</p>
              <h3>{{ t('savedPersonalNotes') }}</h3>
            </div>
          </div>

          <div
            v-if="noteForm.documentId"
            class="note-editor"
          >
            <div class="section-title">
              <div>
                <p class="eyebrow">{{ t('personalNote') }}</p>
                <h3>{{ noteForm.title }}</h3>
              </div>

              <button @click="cancelNoteEditor">
                {{ t('cancel') }}
              </button>
            </div>

            <label class="field-label">{{ t('noteContent') }}</label>
            <textarea
              v-model="noteForm.noteContent"
              class="feedback-textarea"
              placeholder="Write your personal note for this document..."
            ></textarea>

            <button class="primary" @click="savePersonalNote">
              {{ t('saveNote') }}
            </button>
          </div>

          <div class="doc-grid">
            <article
              v-for="item in savedDocuments"
              :key="item.savedId"
              class="doc-card"
            >
              <span class="status-pill green">Saved</span>
              <h4>{{ item.title }}</h4>

              <p v-if="item.note">
                Note: {{ item.note }}
              </p>

              <p v-else class="muted">
                {{ t('noPersonalNote') }}
              </p>

              <div>
                <span>{{ item.category }}</span>
                <span>{{ new Date(item.updated).toLocaleDateString() }}</span>
              </div>

              <div class="button-row">
                <button @click="openNoteEditor(item)">
                  {{ item.note ? t('editNote') : t('addNote') }}
                </button>

                <button
                  v-if="item.noteId"
                  @click="deletePersonalNote(item)"
                >
                  {{ t('deleteNote') }}
                </button>

                <button @click="removeSavedDocument(item.savedId)">
                  {{ t('remove') }}
                </button>
              </div>
            </article>

            <div v-if="savedDocuments.length === 0" class="empty-state">
              {{ t('noSavedDocuments') }}
            </div>
          </div>
        </div>
      </section>

      <!-- ADMIN WORKSPACE -->
      <section v-if="screen === 'admin' && session === 'Admin'" class="dashboard-grid">
        <div class="welcome-card admin-theme">
          <p class="eyebrow">{{ t('adminWorkspace') }}</p>
          <h3>{{ t('adminWorkspaceDesc') }}</h3>
          <p>{{ t('adminControlDesc') }}</p>
        </div>

        <StatCard label="Users" :value="String(users.length)" note="Registered accounts" />
        <StatCard :label="t('totalDocuments')" :value="String(documents.length)" :note="t('repositoryRecords')" />
        <StatCard label="Audit Events" :value="String(logs.length)" note="System activity logs" />

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">{{ t('hrEscalation') }}</p>
              <h3>{{ t('escalationRequestsFromUsers') }}</h3>
            </div>

            <button @click="loadEscalationRequests">
              {{ t('refresh') }}
            </button>
          </div>

          <div class="table-card">
            <table>
              <thead>
                <tr>
                  <th>{{ t('question') }}</th>
                  <th>{{ t('user') }}</th>
                  <th>{{ t('description') }}</th>
                  <th>{{ t('status') }}</th>
                  <th>{{ t('submittedAt') }}</th>
                  <th>{{ t('action') }}</th>
                </tr>
              </thead>

              <tbody>
                <tr
                  v-for="request in escalationRequests"
                  :key="request.escalationId"
                >
                  <td>{{ request.escalationQuestion }}</td>
                  <td>{{ request.userName || 'User' }}</td>
                  <td>{{ request.escalationDescription }}</td>
                  <td>
                    <span
                      :class="request.escalationStatus === 'Resolved'
                        ? 'status-pill green'
                        : 'status-pill amber'"
                    >
                      {{ request.escalationStatus }}
                    </span>
                  </td>
                  <td>{{ new Date(request.submittedAt).toLocaleString() }}</td>
                  <td>
                    <button
                      v-if="request.escalationStatus !== 'Resolved'"
                      @click="resolveEscalationRequest(request.escalationId)"
                    >
                      {{ t('markResolved') }}
                    </button>

                    <span v-else class="muted">
                      {{ t('completed') }}
                    </span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <p v-if="escalationRequests.length === 0" class="muted">
            {{ t('noEscalationSubmitted') }}
          </p>
        </div>

      <div class="wide-card">
        <div class="section-title">
          <h3>{{ t('rolePermission') }}</h3>
          <button @click="openCreateRoleForm">
            {{ t('createRole') }}
          </button>
        </div>

  <div class="role-grid">
    <article
      v-for="(role, index) in roles"
      :key="role.name"
      class="role-card"
    >
      <h4>{{ role.name }}</h4>
      <p>{{ role.description }}</p>

      <div>
        <span v-for="permission in role.permissions" :key="permission">
          {{ permission }}
        </span>
      </div>

      <div class="button-row">
        <button @click="openEditRoleForm(role, index)">
          {{ t('editRole') }}
        </button>
      </div>
    </article>
  </div>
</div>

<div v-if="roleModalOpen" class="modal-overlay" @click.self="cancelRoleForm">
  <div class="modal-card">
    <div class="section-title">
      <div>
        <p class="eyebrow">{{ t('roleManagement') }}</p>
        <h3>{{ editingRoleIndex === null ? t('createNewRole') : t('editRole') }}</h3>
      </div>

      <button @click="cancelRoleForm">
        {{ t('cancel') }}
      </button>
    </div>

    <InputField
      v-model="roleForm.name"
      label="Role Name"
      placeholder="Example: Document Reviewer"
    />

    <label class="input-group">
      <span>{{ t('roleDescription') }}</span>
      <textarea
        v-model="roleForm.description"
        class="feedback-textarea"
        placeholder="Describe what this role can do..."
      ></textarea>
    </label>

    <label class="input-group">
      <span>{{ t('permissions') }}</span>
      <textarea
        v-model="roleForm.permissions"
        class="feedback-textarea"
        placeholder="Enter permissions separated by comma"
      ></textarea>
    </label>

    <button class="primary full" @click="saveRole">
      {{ editingRoleIndex === null ? t('createRole') : t('saveChanges') }}
    </button>
  </div>
</div>
        

        <div class="wide-card">
          <div class="section-title">
            <h3>{{ t('userAccountManagement') }}</h3>
            <button @click="toast = 'User table exported for audit review.'">
              Export
            </button>
          </div>

          <div class="table-card">
            <table>
              <thead>
                <tr>
                  <th>{{ t('user') }}</th>
                  <th>{{ t('department') }}</th>
                  <th>{{ t('designation') }}</th>
                  <th>{{ t('role') }}</th>
                  <th>{{ t('status') }}</th>
                  <th>{{ t('createdAt') }}</th>
                  <th>{{ t('updatedAt') }}</th>
                  <th>{{ t('action') }}</th>
                </tr>
              </thead>

              <tbody>
                <tr v-for="user in users" :key="user.id">
                  <td>
                    <strong>{{ user.name }}</strong>
                    <span>{{ user.email }}</span>
                  </td>

                  <td>{{ user.department }}</td>
                  <td>{{ user.designation }}</td>
                  <td>{{ user.role }}</td>

                  <td>
                    <span :class="user.status === 'Active' ? 'status-pill green' : 'status-pill red'">
                      {{ user.status }}
                    </span>
                  </td>

                  <td>{{ user.created_at }}</td>
                  <td>{{ user.updated_at }}</td>

                  <td>
                    <button @click="toggleUserStatus(user)">
                      {{ user.status === 'Active' ? t('suspend') : t('reactivate') }}
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <h3>{{ t('systemActivityLogs') }}</h3>
            <button @click="filterLogs">
              {{ t('filterLogs') }}
            </button>
          </div>

          <div class="log-list">
            <div
              v-for="log in logs"
              :key="log.id"
              class="log-item"
            >
              <span :class="log.result === 'Success' ? 'dot green-dot' : 'dot amber-dot'"></span>

              <div>
                <strong>{{ log.action }}</strong>
                <p>{{ log.user }} · {{ log.module }}</p>
              </div>

              <em>{{ log.time }}</em>
            </div>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>

<script setup>
import { computed, ref, watch, onMounted } from 'vue'
import InputField from './components/InputField.vue'
import StatCard from './components/StatCard.vue'
import SettingCard from './components/SettingCard.vue'
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3000'

function useLocalStorage(key, defaultValue) {
  let initialValue = defaultValue

  try {
    const storedValue = localStorage.getItem(key)

    if (storedValue) {
      initialValue = JSON.parse(storedValue)
    }
  } catch (error) {
    console.warn(`Invalid localStorage data for ${key}. Resetting to default value.`)
    localStorage.removeItem(key)
    initialValue = defaultValue
  }

  const data = ref(initialValue)

  watch(
    data,
    (newValue) => {
      try {
        localStorage.setItem(key, JSON.stringify(newValue))
      } catch (error) {
        console.warn(`Failed to save ${key} to localStorage.`)
      }
    },
    { deep: true }
  )

  return data
}

  function submitDeactivationRequest() {
    if (!deactivationForm.value.reason.trim()) {
    showToast('Please enter a reason for account deactivation.', 'info')
      return
    }

    if (deactivationForm.value.confirmText !== 'DEACTIVATE') {
      showToast('Please type DEACTIVATE to confirm the request.', 'info')
      return
    }

    showToast('Account deactivation request submitted for administrator review.', 'success')
    addLog('Submitted account deactivation request', 'Profile Management', 'Warning', session.value)
    cancelDeactivationRequest()
  }

  function cancelDeactivationRequest() {
    deactivationModalOpen.value = false

    deactivationForm.value = {
      reason: '',
      confirmText: ''
    }
  }

/* const documents = ref([])

async function loadDocuments() {
  try {
    const response = await fetch('http://localhost:3000/api/documents')
    documents.value = await response.json()
  } catch (error) {
    toast.value = 'Failed to load documents from database.'
  }
}

onMounted(() => {
  loadDocuments()
}) */

const documents = ref([])
const currentUserId = 1

const selectedDoc = ref({
  documentId: null,
  referenceNo: '',
  title: 'Loading documents...',
  category: '',
  type: '',
  status: '',
  access: 'Public',
  effectiveDate: '',
  version: '',
  reason: '',
  summary: 'Please wait while documents are loaded from the database.'
})

const publicDetailsModalOpen = ref(false)

const smartResults = ref([]) // recommended documents only
const searchResults = ref([]) // smart search results only
const hasSearched = ref(false)

const reportDialogOpen = ref(false)
const selectedRecommendation = ref(null)

const recommendationReportForm = ref({
  reportReason: 'Irrelevant',
  reportDescription: ''
})

async function loadDocuments() {
  try {
    const response = await fetch(`${API_BASE_URL}/api/documents`)

    if (!response.ok) {
      throw new Error('Failed to load documents')
    }

    documents.value = await response.json()

    if (documents.value.length > 0) {
      selectedDoc.value = documents.value[0]
    }
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to load documents from database.'
  }
}

async function loadUsers() {
  try {
    const response = await fetch(`${API_BASE_URL}/api/users`)

    if (!response.ok) {
      throw new Error('Failed to load users')
    }

    users.value = await response.json()
  } catch (error) {
    console.error('Silently failed to load users:', error)
  }
}

async function loadRecommendations() {
  try {
    const response = await fetch(`${API_BASE_URL}/api/recommendations/${currentUserId}`)

    if (!response.ok) {
      throw new Error('Failed to load recommendations')
    }

    const data = await response.json()

    smartResults.value = data.length > 0
      ? data
      : documents.value.filter((doc) => doc.access !== 'Restricted')
  } catch (error) {
    console.error(error)
    smartResults.value = documents.value.filter((doc) => doc.access !== 'Restricted')
    toast.value = 'Failed to load recommendations from database.'
  }
}

async function loadFaqs() {
  try {
    const response = await fetch(`${API_BASE_URL}/api/faqs`)

    if (!response.ok) {
      throw new Error('Failed to load FAQs')
    }

    faqs.value = await response.json()
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to load FAQs from database.'
  }
}

async function loadConversationHistory() {
  try {
    const response = await fetch(`${API_BASE_URL}/api/chatbot/conversations/${currentUserId}`)

    if (!response.ok) {
      throw new Error('Failed to load conversation history')
    }

    conversationHistory.value = await response.json()
  } catch (error) {
    console.error(error)
  }
}

async function loadEscalationRequests() {
  try {
    const response = await fetch(`${API_BASE_URL}/api/escalation-requests`)

    if (!response.ok) {
      throw new Error('Failed to load escalation requests')
    }

    escalationRequests.value = await response.json()
  } catch (error) {
    console.error(error)
  }
}

async function resolveEscalationRequest(escalationId) {
  try {
    const response = await fetch(
      `${API_BASE_URL}/api/escalation-requests/${escalationId}/resolve`,
      {
        method: 'PATCH'
      }
    )

    if (!response.ok) {
      throw new Error('Failed to resolve escalation request')
    }

    await loadEscalationRequests()

    toast.value = 'Escalation request marked as resolved.'
    addLog('Resolved escalation request', 'Admin Workspace', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to resolve escalation request.'
  }
}

async function loadNotifications() {
  try {
    const response = await fetch(`${API_BASE_URL}/api/notifications/${currentUserId}`)

    if (!response.ok) {
      throw new Error('Failed to load notifications')
    }

    notifications.value = await response.json()
  } catch (error) {
    console.error('Silently failed to load notification preferences:', error)
  }
}

async function loadNotificationPreferences() {
  try {
    const response = await fetch(`${API_BASE_URL}/api/notification-preferences/${currentUserId}`)

    if (!response.ok) {
      throw new Error('Failed to load notification preferences')
    }

    const data = await response.json()

    policyUpdateEnabled.value = data.policyUpdateEnabled === 1
    savedUpdateEnabled.value = data.savedUpdateEnabled === 1
    notificationFrequency.value = data.notificationFrequency || 'Daily'
    deliveryChannel.value = data.deliveryChannel || 'In-System'
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to load notification preferences.'
  }
}

async function loadSavedDocuments() {
  try {
    const response = await fetch(`${API_BASE_URL}/api/saved-documents/${currentUserId}`)

    if (!response.ok) {
      throw new Error('Failed to load saved documents')
    }

    const dbSavedDocuments = await response.json()
    const localSavedDocuments = getLocalSavedDocuments()

    const mergedDocuments = [...dbSavedDocuments]

    localSavedDocuments.forEach((localItem) => {
      const exists = mergedDocuments.some((item) => item.documentId === localItem.documentId)

      if (!exists) {
        mergedDocuments.push(localItem)
      }
    })

    savedDocuments.value = mergedDocuments
    persistLocalSavedDocuments()
  } catch (error) {
    console.error(error)
    savedDocuments.value = getLocalSavedDocuments()
  }
}

function getLocalSavedDocuments() {
  try {
    return JSON.parse(localStorage.getItem(`jhr_saved_documents_${currentUserId}`) || '[]')
  } catch (error) {
    console.warn('Failed to read local saved documents.', error)
    return []
  }
}

function downloadDocument(doc) {
  addAuditEntry(
    'download',
    doc.title,
    'Document downloaded'
  )

  toast.value = `${doc.title} downloaded successfully`
}

function openPreview(doc) {
  previewDocument.value = doc
  showPreviewModal.value = true
}

function closePreview() {
  showPreviewModal.value = false
  previewDocument.value = null
}

onMounted(async () => {
  await loadDocuments()
  await loadUsers()
  await loadRecommendations()
  await loadFaqs()
  await loadConversationHistory()
  await loadNotifications()
  await loadNotificationPreferences()
  await loadSearchSuggestions()
  await loadRecentSearchHistory()
  await loadTrendingDocuments()
  await loadFrequentlyUsedPolicies()
  await loadSavedDocuments()
  await loadEscalationRequests()
})

const users = ref([])

const logs = useLocalStorage('jhr_logs', [
  {
    id: 'LOG-1003',
    user: 'May Yan',
    action: 'Updated role permission',
    module: 'Role Management',
    time: 'Yesterday, 04:42 PM',
    result: 'Success'
  }
])

const roles = useLocalStorage('jhr_roles', [
  {
    name: 'Guest User',
    description: 'Can browse and search public HR documents only.',
    permissions: ['Search Public Documents', 'Browse Public Documents', 'View Public Details']
  },
  {
    name: 'Registered User',
    description:
      'Can access full document search, AI features, downloads, bookmarks and notifications.',
    permissions: ['Full Search', 'Download Documents', 'AI Chatbot', 'Recommendations', 'Bookmarks']
  },
  {
    name: 'Administrator',
    description:
      'Can manage users, roles, audit logs and document administration functions.',
    permissions: [
      'User Management',
      'Role Management',
      'Audit Trail',
      'Document Upload',
      'Version Management'
    ]
  }
])

const classificationQueue = useLocalStorage('jhr_classification_queue', [
  {
    id: 1,
    title: 'Cuti Rehat Khas Update 2026',
    status: 'Pending Review',
    suggestions: ['Leave Policy', 'Staff Benefits'],
    tags: ['HRMD', 'Leave', 'Circular']
  },
  {
    id: 2,
    title: 'Kenaikan Pangkat Pegawai Sokongan',
    status: 'Pending Review',
    suggestions: ['Promotion', 'Evaluation'],
    tags: ['Promotion', 'Performance', 'Department']
  },
  {
    id: 3,
    title: 'Tatatertib dan Amaran Pentadbiran',
    status: 'Needs Edit',
    suggestions: ['Discipline', 'Compliance'],
    tags: ['Discipline', 'Internal', 'Restricted']
  }
])

const notifications = ref([])

const smartAlerts = computed(() => {
  return notifications.value.filter((notice) => notice.type === 'smart_alert')
})

const policyNotifications = computed(() => {
  return notifications.value.filter((notice) => notice.type !== 'smart_alert')
})

const savedDocuments = ref([])

const faqs = ref([])

const suggestedQuestions = [
  'How do I apply for TASKA subsidy?',
  'What is TBK promotion?',
  'What is SPKN used for?',
  'What is COS and CFS contract service?',
  'What is the promotion and discipline document about?'
]

const navItems = [
  { id: 'public', labelKey: 'navPublic' },
  { id: 'auth', labelKey: 'navAuth' },
  { id: 'profile', labelKey: 'navProfile' },
  { id: 'documents', labelKey: 'navDocuments' },
  { id: 'smart', labelKey: 'navSmart' },
  { id: 'personal', labelKey: 'navPersonal' },
  { id: 'admin', labelKey: 'navAdmin' }
]

const authTabs = [
  { id: 'admin', labelKey: 'adminLogin' }
]

//const categories = ['All', 'Leave Policy', 'Promotion', 'Discipline', 'Salary', 'Loan']
const categories = [
  'All',
  'Staff Benefits',
  'Promotion',
  'Overseas Travel',
  'Contract Service',
  'Promotion and Discipline'
]

const screen = ref('public')
const query = ref('')
const category = ref('All')
const roleModalOpen = ref(false)
const editingRoleIndex = ref(null)

const roleForm = ref({
  name: '',
  description: '',
  permissions: ''
})
//const selectedDoc = ref(documents.value[0])
const authMode = ref('admin')
const resetModalOpen = ref(false)
const resetAccountType = ref('user')
const session = ref('Guest')
const toast = ref('Welcome to Johor HR Knowledge Hub interactive prototype.')
const toastType = ref('success')

function showToast(message, type = 'success') {
  toast.value = message
  toastType.value = type
}

const language = useLocalStorage('jhr_language', 'ms')

const translations = {
  en: {
    // General
    systemMessage: 'System message',
    currentAccess: 'Current access',
    publicMode: 'Public mode',
    adminSession: 'Administrator session',
    userSession: 'Registered user session',
    userLogin: 'User Login',
    adminLogin: 'Admin Login',
    register: 'Register',
    logout: 'Logout',
    close: 'Close',
    cancel: 'Cancel',
    refresh: 'Refresh',
    clear: 'Clear',
    save: 'Save',
    export: 'Export',
    action: 'Action',
    actions: 'Actions',
    status: 'Status',
    access: 'Access',
    category: 'Category',
    type: 'Type',
    department: 'Department',
    designation: 'Designation',
    password: 'Password',
    email: 'Email',
    user: 'User',
    role: 'Role',
    description: 'Description',
    question: 'Question',

    // Temporary email example keys
    'user@johor.gov.my': 'user@johor.gov.my',
    'admin@johor.gov.my': 'admin@johor.gov.my',

    // Navigation
    navPublic: 'Public Portal',
    navAuth: 'Login / Register',
    navProfile: 'Admin Profile',
    navDocuments: 'Document Management',
    navSmart: 'Smart Support',
    navPersonal: 'Notifications & Saved',
    navAdmin: 'Admin Workspace',

    // Public Portal
    guestAccess: 'Guest Access',
    publicTitle: 'Search official HR documents without logging in.',
    publicDesc: 'Search and preview public HR policies, circulars and guidelines.',
    searchPlaceholder: 'Search by title, reference number or category...',
    searchResults: 'Search Results',
    documentsFound: 'document(s) found',
    requestRegistration: 'Request Account Registration',
    openPublicDetails: 'Open Public Details',
    registerLoginAccess: 'Register / Login to Access',
    noMatchingDocuments: 'No matching documents found. Try another keyword or category.',
    publicDocumentDetails: 'Public Document Details',
    reference: 'Reference',
    referenceNumber: 'Reference Number',
    documentType: 'Document Type',
    effectiveDate: 'Effective Date',
    issuingDepartment: 'Issuing Department',
    issuingDepartmentValue: 'Johor Human Resource Management Division',
    documentPurpose: 'Document Purpose',
    documentPurposeValue: 'Provides official guidance for HR-related procedures.',
    documentSummary: 'Document Summary',
    prototypeNote: 'Prototype Note',
    prototypeNoteText: 'This page shows the public document information available to guest users. Additional actions such as download, bookmark, AI chatbot, recommendations and notification subscription require login.',
    backToPublicPortal: 'Back to Public Portal',
    version: 'Version',

    // Auth
    registrationLogin: 'Registration and Login',
    authTitle: 'Secure access using official Johor government email.',
    authDesc: 'Users can register, log in, reset password and use MFA protection.',
    sessionControl: 'Session control',
    extraProtection: 'Extra protection',
    failedLoginHandling: 'Failed login handling',
    userLoginAccount: 'User Login Account',
    userLoginDesc: 'Access full document search and registered features.',
    loginRegisteredUser: 'Login as Registered User',
    governmentEmail: 'Government Email',
    adminEmail: 'Admin Email',
    mfaCode: 'MFA Code',
    mfaPlaceholder: '6-digit code if enabled',
    forgotPassword: 'Forgot password?',
    registerAccount: 'Register Account',
    registerDesc: 'Create account using required profile information.',
    fullName: 'Full Name',
    fullNamePlaceholder: 'Enter full name',
    enterFullName: 'Enter full name',
    enterGovernmentEmail: 'Enter government email',
    enterAdminEmail: 'Enter admin email',
    enterDepartment: 'Enter department',
    enterDesignation: 'Enter designation',
    designationLevel: 'Designation Level',
    departmentPlaceholder: 'Human Resource Management Division',
    designationPlaceholder: 'Officer / Assistant Officer',
    passwordPlaceholder: 'Minimum 8 characters',
    enterPassword: 'Enter password',
    enterAdminPassword: 'Enter admin password',
    submitRegistration: 'Submit Registration',
    adminLoginAccount: 'Administrator Login Account',
    adminLoginDesc: 'Dedicated admin login for management functions.',
    failedLoginProtection: 'Failed Login Protection',
    failedAttempts: 'Failed attempts',
    failedAttemptText: 'failed login attempt(s).',
    attemptRemainingText: 'attempt(s) remaining before account lock.',
    accountLockedAfterAttempts: 'This account is locked after 3 failed login attempts.',
    accountLockedToast: 'Account locked after multiple failed login attempts.',
    enterEmailBeforeAttempt: 'Please enter an email before login attempt can be recorded.',

    // Reset Password
    accountRecovery: 'Account Recovery',
    resetAdminPassword: 'Reset Admin Password',
    resetUserPassword: 'Reset User Password',
    resetAdminDesc: 'Enter your administrator email, verification code and new password.',
    resetUserDesc: 'Enter your registered government email, verification code and new password.',
    registeredEmail: 'Registered Email',
    sendResetLink: 'Send Reset Link',
    verificationCode: 'Verification Code',
    enterCode: 'Enter code',
    enterVerificationCode: 'Enter verification code',
    newPassword: 'New Password',
    enterNewPassword: 'Enter new password',
    reenterNewPassword: 'Re-enter new password',
    updatePassword: 'Update Password',

    // Profile
    activeRegisteredUser: 'Active Registered User',
    notification: 'Notification',
    profileManagement: 'Profile Management',
    manageUserProfile: 'Manage User Profile',
    notificationPreference: 'Notification Preference',
    saveProfile: 'Save Profile',
    instant: 'Instant',
    daily: 'Daily',
    weekly: 'Weekly',
    emailPlaceholder: 'aina@johor.gov.my',

    // Security
    accountSecurity: 'Account Security',
    mfaEnabled: 'MFA Enabled',
    mfaDisabled: 'MFA Disabled',
    changePassword: 'Change Password',
    changePasswordDesc: 'Update password while logged in.',
    currentPassword: 'Current Password',
    confirmNewPassword: 'Confirm New Password',
    change: 'Change',
    enableMfa: 'Enable MFA',
    enableMfaDesc: 'Use verification code during login.',
    useVerificationCode: 'Use verification code during login.',
    enable: 'Enable',
    disable: 'Disable',
    deactivateAccount: 'Deactivate Account',
    deactivateDesc: 'Request own account deactivation.',
    request: 'Request',
    accountDeactivation: 'Account Deactivation',
    requestAccountDeactivation: 'Request Account Deactivation',
    deactivationDesc: 'Submit a request to deactivate your account. The request will be reviewed by an administrator before the account is deactivated.',
    reasonForDeactivation: 'Reason for Deactivation',
    deactivationPlaceholder: 'Example: I no longer need access to the Johor HR Knowledge Hub.',
    typeDeactivate: 'Type DEACTIVATE to confirm',
    submitDeactivation: 'Submit Deactivation Request',
    enterCurrentPassword: 'Enter current password',
    accountDeactivation: 'Account Deactivation',
    requestAccountDeactivation: 'Request Account Deactivation',
    deactivationDesc: 'Submit a request to deactivate your account. The request will be reviewed by an administrator before the account is deactivated.',
    reasonForDeactivation: 'Reason for Deactivation',
    deactivationPlaceholder: 'Example: I no longer need access to the Johor HR Knowledge Hub.',
    typeDeactivate: 'Type DEACTIVATE to confirm',
    submitDeactivation: 'Submit Deactivation Request',

    // Admin Workspace
    adminWorkspace: 'Administrator Workspace',
    adminWorkspaceDesc: 'Manage users, permissions, documents, AI suggestions and audit logs.',
    adminControlDesc: 'Admin can control user access, roles and system records.',
    users: 'Users',
    documents: 'Documents',
    auditEvents: 'Audit Events',
    registeredAccounts: 'Registered accounts',
    repositoryRecords: 'Repository records',
    systemActivityLogs: 'System Activity Logs',
    systemActivityLogNote: 'System activity logs',
    hrEscalation: 'HR Escalation',
    escalationRequestsFromUsers: 'Escalation Requests from Users',
    submittedAt: 'Submitted At',
    markResolved: 'Mark Resolved',
    completed: 'Completed',
    noEscalationSubmitted: 'No escalation requests submitted yet.',
    rolePermission: 'Role and Permission Control',
    createRole: 'Create Role',
    editRole: 'Edit Role',
    roleManagement: 'Role Management',
    createNewRole: 'Create New Role',
    saveChanges: 'Save Changes',
    roleName: 'Role Name',
    roleDescription: 'Role Description',
    permissions: 'Permissions',
    roleNamePlaceholder: 'Example: Document Reviewer',
    roleDescriptionPlaceholder: 'Describe what this role can do...',
    permissionsPlaceholder: 'Enter permissions separated by comma',
    userAccountManagement: 'User Account Management',
    createdAt: 'Created At',
    updatedAt: 'Updated At',
    suspend: 'Suspend',
    reactivate: 'Reactivate',
    filterLogs: 'Filter Logs',
    adminProfile: 'Admin Profile',
    manageAdminProfile: 'Manage Admin Profile',
    administrator: 'Administrator',

    // Document Management
    documentManagement: 'Document Management',
    documentManagementTitle: 'Upload, classify, store, search and manage HR documents.',
    administrators: 'Administrators',
    adminsDocumentDesc: 'Can upload official HR documents, review AI classification suggestions, manage the document repository and archive outdated circulars.',
    guestUser: 'User',
    guestUserDocumentDesc: 'Browse, search and view HR documents available to your access level.',
    totalDocuments: 'Total Documents',
    pendingReview: 'Pending Review',
    archived: 'Archived',
    published: 'Published',
    restricted: 'Restricted',
    aiClassificationQueue: 'AI classification queue',
    oldCircularVersions: 'Old circular versions',
    availableDocuments: 'Available documents',
    protectedDocuments: 'Protected documents',
    documentUpload: 'Document Upload',
    uploadHrDocument: 'Upload HR Document',
    uploadSubmitReview: 'Upload & Submit for Review',
    saveAsDraft: 'Save as Draft',
    documentTitle: 'Document Title',
    officialReferenceNumber: 'Official Reference Number',
    issuingAuthority: 'Issuing Authority',
    expiryDate: 'Expiry Date',
    departmentTag: 'Department Tag',
    selectDepartment: '— Select Department —',
    accessLevel: 'Access Level',
    language: 'Language',
    pdfFile: 'PDF File',
    choosePdfFile: 'Click to choose PDF file',
    dragDropPdf: 'or drag and drop here · PDF only · Max 20MB',
    fileSelected: 'File selected',
    remove: 'Remove',

    // AI Classification
    aiClassificationReview: 'AI Classification Review',
    suggestedDocumentCategories: 'Suggested Document Categories',
    refreshSuggestions: 'Refresh Suggestions',
    classificationDesc: 'Review and approve or modify the AI-suggested categories and department tags before each document is published.',
    noClassification: 'No documents waiting for classification review.',
    aiConfidence: 'AI Confidence',
    suggestedCategories: 'Suggested Categories',
    departmentTags: 'Department Tags',
    modifyCategory: 'Modify Category',
    modifyDepartmentTag: 'Modify Department Tag',
    approve: 'Approve',
    approved: 'Approved',
    modify: 'Modify',
    reject: 'Reject',

    // Repository
    repositorySearch: 'Repository & Search',
    searchManageDocuments: 'Search and Manage Documents',
    uploadNewVersion: 'Upload New Version',
    allTypes: 'All Types',
    allCategories: 'All Categories',
    allStatuses: 'All Statuses',
    allAccessLevels: 'All Access Levels',
    showing: 'Showing',
    result: 'result',
    results: 'results',
    forText: 'for',
    document: 'Document',
    referenceNo: 'Reference No.',
    views: 'Views',
    noDocumentsMatch: 'No documents match your filters.',
    viewDetails: 'View Details',
    download: 'Download',
    newVersion: 'New Version',
    archive: 'Archive',
    restore: 'Restore',

    // Archive and Version
    archiveDocument: 'Archive Document',
    archiveDesc: 'Archiving removes this document from active circulation. Users with saved copies will be notified.',
    archiveReason: 'Archive Reason',
    selectReason: '— Select reason —',
    supersededReason: 'Superseded by newer circular',
    expiredReason: 'Document has expired',
    withdrawnReason: 'Officially withdrawn',
    otherReason: 'Other reason',
    successorReference: 'Successor Document Reference (if replaced)',
    additionalNotes: 'Additional Notes',
    additionalNotesPlaceholder: 'Provide any additional explanation...',
    confirmArchive: 'Confirm Archive',
    versionManagement: 'Version Management',
    documentToUpdate: 'Document to Update',
    selectDocument: '— Select document —',
    currentVersion: 'Current',
    newVersionWillBe: 'New version will be',
    updateType: 'Update Type',
    selectType: '— Select type —',
    amendment: 'Amendment',
    replacement: 'Replacement',
    correction: 'Correction',
    withdrawal: 'Withdrawal',
    changeSummary: 'Change Summary',
    changeSummaryPlaceholder: 'Describe what changed in this version...',
    newPdfFile: 'New PDF File',
    newEffectiveDate: 'New Effective Date (if changed)',

    // Preview and Audit
    documentDetails: 'Document Details',
    totalViews: 'Total Views',
    documentAuditTrail: 'Document Audit Trail',
    recentDocumentActions: 'Recent Document Actions',
    exportLog: 'Export Log',
    noAuditActions: 'No audit actions recorded yet. Actions will appear here after you upload, classify, archive or update documents.',

    // Smart Support
    smartSearch: 'Smart Search',
    smartSearchTitle: 'Search HR policies using normal questions.',
    smartSearchDesc: 'Type a question and the system will suggest related documents.',
    smartSearchPlaceholder: 'Example: TASKA subsidy, promotion TBK, SPKN travel...',
    sortResults: 'Sort Results',
    relevance: 'Relevance',
    latestUpdated: 'Latest Updated',
    titleAz: 'Title A-Z',
    mostViewed: 'Most Viewed',
    performSmartSearch: 'Perform Smart Search',
    clearSearch: 'Clear Search',
    recentSearchHistory: 'Recent Search History',
    noRecentSearch: 'No recent search history yet.',
    hrAssistant: 'HR Assistant',
    askChatbot: 'Ask the HR Chatbot',
    suggestedQuestions: 'Suggested questions',
    chatbotPlaceholder: 'Ask about login, documents, leave, promotion, salary, upload...',
    send: 'Send',
    helpful: 'Helpful',
    notHelpful: 'Not Helpful',
    escalateHrOfficer: 'Escalate to HR Officer',
    optionalFeedback: 'Optional chatbot feedback comment...',
    hrOfficerSupport: 'HR Officer Support',
    escalateQuestion: 'Escalate Question',
    questionPlaceholder: 'Enter the question to escalate...',
    descriptionPlaceholder: 'Describe why this question needs HR officer support...',
    submitHrOfficer: 'Submit to HR Officer',
    conversationHistory: 'Conversation History',
    rating: 'Rating',
    noConversation: 'No conversation history yet.',
    escalationRequests: 'Escalation Requests',
    noEscalation: 'No escalation request submitted yet.',
    smartSearchResults: 'Smart Search Result Documents',
    searchResult: 'Search Result',
    saveDocument: 'Save Document',
    generateSummary: 'Generate Summary',
    noMatchingSmartDocument: 'No matching document found. Try searching TASKA, TBK, SPKN, COS, CFS, promotion, or contract.',
    recommendations: 'Recommendations',
    recommendedDocuments: 'Recommended Documents',
    recommended: 'Recommended',
    reason: 'Reason',
    relevanceScore: 'Relevance Score',
    reportIncorrect: 'Report Incorrect',
    noRecommended: 'No recommended documents available.',
    aiDocumentSummary: 'AI Document Summary',
    recommendationReport: 'Recommendation Report',
    reportIncorrectRecommendation: 'Report Incorrect Recommendation',
    reporting: 'Reporting',
    irrelevant: 'Irrelevant',
    inaccurate: 'Inaccurate',
    outdated: 'Outdated',
    inappropriate: 'Inappropriate',
    others: 'Others',
    reportDescriptionPlaceholder: 'Explain why this recommendation is incorrect...',
    submitReport: 'Submit Report',
    faq: 'FAQ',
    frequentlyAskedQuestions: 'Frequently Asked Questions',
    trendingDocuments: 'Trending Documents',
    popularDocuments: 'Currently Popular HR Documents',
    trending: 'Trending',
    score: 'Score',
    frequentlyUsedPolicies: 'Frequently Used Policies',
    suggestedFrequentlyUsed: 'Suggested Frequently Used Policies',
    frequentlyUsed: 'Frequently Used',

    // Personal Storage and Notifications
    savedNotifications: 'Saved Documents and Notifications',
    savedNotificationsTitle: 'Keep track of saved documents, notes and policy updates.',
    savedNotificationsDesc: 'Users receive alerts when relevant or saved documents are updated.',
    saved: 'Saved',
    unreadAlerts: 'Unread Alerts',
    notes: 'Notes',
    personalCollection: 'Personal collection',
    policyUpdates: 'Policy updates',
    personalNotes: 'Personal notes',
    notificationPreferences: 'Notification Preferences',
    manageAlerts: 'Manage Alerts',
    savePreferences: 'Save Preferences',
    policyUpdatesTitle: 'Policy Updates',
    policyUpdatesDesc: 'Notify when new relevant documents are published.',
    savedDocumentUpdates: 'Saved Document Updates',
    savedDocumentUpdatesDesc: 'Notify when bookmarked documents are replaced.',
    frequency: 'Frequency',
    frequencyDesc: 'Choose instant, daily or weekly notifications.',
    deliveryChannel: 'Delivery Channel',
    deliveryChannelDesc: 'Choose how notifications are delivered.',
    enabled: 'Enabled',
    disabled: 'Disabled',
    smartAlerts: 'Smart Alerts',
    recommendedAlerts: 'Recommended Alerts Based on User Activity',
    refreshAlerts: 'Refresh Alerts',
    markRead: 'Mark as Read',
    markAllRead: 'Mark All as Read',
    noSmartAlerts: 'No smart alerts available.',
    recentNotifications: 'Recent Notifications',
    policyUpdatesAlerts: 'Policy Updates and Alerts',
    noNotifications: 'No notifications available.',
    userFeedback: 'User Feedback',
    submitFeedback: 'Submit Feedback',
    feedbackCategory: 'Feedback Category',
    feedbackContent: 'Feedback Content',
    feedbackPlaceholder: 'Write your feedback here...',
    systemIssue: 'System Issue',
    documentIssue: 'Document Issue',
    chatbotIssue: 'Chatbot Issue',
    searchIssue: 'Search Issue',
    suggestion: 'Suggestion',
    personalStorage: 'Personal Storage',
    savedPersonalNotes: 'Saved Documents and Personal Notes',
    personalNote: 'Personal Note',
    noteContent: 'Note Content',
    notePlaceholder: 'Write your personal note for this document...',
    saveNote: 'Save Note',
    note: 'Note',
    noPersonalNote: 'No personal note yet.',
    editNote: 'Edit Note',
    addNote: 'Add Note',
    deleteNote: 'Delete Note',
    noSavedDocuments: 'No saved documents yet. Go to Smart Support and save one.'
  },

  ms: {
    // General
    systemMessage: 'Mesej Sistem',
    currentAccess: 'Akses Semasa',
    publicMode: 'Mod awam',
    adminSession: 'Sesi pentadbir',
    userSession: 'Sesi pengguna berdaftar',
    userLogin: 'Log Masuk Pengguna',
    adminLogin: 'Log Masuk Pentadbir',
    register: 'Daftar',
    logout: 'Log Keluar',
    close: 'Tutup',
    cancel: 'Batal',
    refresh: 'Segar Semula',
    clear: 'Kosongkan',
    save: 'Simpan',
    export: 'Eksport',
    action: 'Tindakan',
    actions: 'Tindakan',
    status: 'Status',
    access: 'Akses',
    category: 'Kategori',
    type: 'Jenis',
    department: 'Jabatan',
    designation: 'Jawatan',
    password: 'Kata Laluan',
    email: 'Emel',
    user: 'Pengguna',
    role: 'Peranan',
    description: 'Penerangan',
    question: 'Soalan',

    // Temporary email example keys
    'user@johor.gov.my': 'user@johor.gov.my',
    'admin@johor.gov.my': 'admin@johor.gov.my',

    // Navigation
    navPublic: 'Portal Awam',
    navAuth: 'Log Masuk / Daftar',
    navProfile: 'Profil Admin',
    navDocuments: 'Pengurusan Dokumen',
    navSmart: 'Sokongan Pintar',
    navPersonal: 'Notifikasi & Simpanan',
    navAdmin: 'Ruang Kerja Pentadbir',

    // Public Portal
    guestAccess: 'Akses Tetamu',
    publicTitle: 'Cari dokumen rasmi HR tanpa log masuk.',
    publicDesc: 'Cari dan pratonton polisi HR, pekeliling dan garis panduan awam.',
    searchPlaceholder: 'Cari mengikut tajuk, nombor rujukan atau kategori...',
    searchResults: 'Keputusan Carian',
    documentsFound: 'dokumen dijumpai',
    requestRegistration: 'Mohon Pendaftaran Akaun',
    openPublicDetails: 'Buka Butiran Awam',
    registerLoginAccess: 'Daftar / Log Masuk untuk Akses',
    noMatchingDocuments: 'Tiada dokumen sepadan dijumpai. Cuba kata kunci atau kategori lain.',
    publicDocumentDetails: 'Butiran Dokumen Awam',
    reference: 'Rujukan',
    referenceNumber: 'Nombor Rujukan',
    documentType: 'Jenis Dokumen',
    effectiveDate: 'Tarikh Berkuat Kuasa',
    issuingDepartment: 'Jabatan Pengeluar',
    issuingDepartmentValue: 'Bahagian Pengurusan Sumber Manusia Johor',
    documentPurpose: 'Tujuan Dokumen',
    documentPurposeValue: 'Menyediakan panduan rasmi untuk prosedur berkaitan HR.',
    documentSummary: 'Ringkasan Dokumen',
    prototypeNote: 'Nota Prototaip',
    prototypeNoteText: 'Halaman ini menunjukkan maklumat dokumen awam yang tersedia kepada pengguna tetamu. Tindakan tambahan seperti muat turun, penanda buku, chatbot AI, cadangan dan langganan notifikasi memerlukan log masuk.',
    backToPublicPortal: 'Kembali ke Portal Awam',
    version: 'Versi',

    // Auth
    registrationLogin: 'Pendaftaran dan Log Masuk',
    authTitle: 'Akses selamat menggunakan emel rasmi Kerajaan Johor.',
    authDesc: 'Pengguna boleh mendaftar, log masuk, menetapkan semula kata laluan dan menggunakan perlindungan MFA.',
    sessionControl: 'Kawalan sesi',
    extraProtection: 'Perlindungan tambahan',
    failedLoginHandling: 'Pengendalian log masuk gagal',
    userLoginAccount: 'Akaun Log Masuk Pengguna',
    userLoginDesc: 'Akses carian dokumen penuh dan fungsi pengguna berdaftar.',
    loginRegisteredUser: 'Log Masuk sebagai Pengguna Berdaftar',
    governmentEmail: 'Emel Kerajaan',
    adminEmail: 'Emel Pentadbir',
    mfaCode: 'Kod MFA',
    mfaPlaceholder: 'Kod 6 digit jika diaktifkan',
    forgotPassword: 'Lupa kata laluan?',
    registerAccount: 'Daftar Akaun',
    registerDesc: 'Cipta akaun menggunakan maklumat profil yang diperlukan.',
    fullName: 'Nama Penuh',
    fullNamePlaceholder: 'Masukkan nama penuh',
    enterFullName: 'Masukkan nama penuh',
    enterGovernmentEmail: 'Masukkan emel kerajaan',
    enterAdminEmail: 'Masukkan emel pentadbir',
    enterDepartment: 'Masukkan jabatan',
    enterDesignation: 'Masukkan jawatan',
    designationLevel: 'Tahap Jawatan',
    departmentPlaceholder: 'Bahagian Pengurusan Sumber Manusia',
    designationPlaceholder: 'Pegawai / Penolong Pegawai',
    passwordPlaceholder: 'Minimum 8 aksara',
    enterPassword: 'Masukkan kata laluan',
    enterAdminPassword: 'Masukkan kata laluan pentadbir',
    submitRegistration: 'Hantar Pendaftaran',
    adminLoginAccount: 'Akaun Log Masuk Pentadbir',
    adminLoginDesc: 'Log masuk khas pentadbir untuk fungsi pengurusan.',
    enterCurrentPassword: 'Masukkan kata laluan semasa',
    failedLoginProtection: 'Perlindungan Log Masuk Gagal',
    failedAttempts: 'Percubaan gagal',
    failedAttemptText: 'percubaan log masuk gagal.',
    attemptRemainingText: 'percubaan lagi sebelum akaun dikunci.',
    accountLockedAfterAttempts: 'Akaun ini dikunci selepas 3 percubaan log masuk gagal.',
    accountLockedToast: 'Akaun dikunci selepas beberapa percubaan log masuk gagal.',
    enterEmailBeforeAttempt: 'Sila masukkan emel sebelum percubaan log masuk direkodkan.',

    // Reset Password
    accountRecovery: 'Pemulihan Akaun',
    resetAdminPassword: 'Tetapkan Semula Kata Laluan Pentadbir',
    resetUserPassword: 'Tetapkan Semula Kata Laluan Pengguna',
    resetAdminDesc: 'Masukkan emel pentadbir, kod pengesahan dan kata laluan baharu.',
    resetUserDesc: 'Masukkan emel kerajaan berdaftar, kod pengesahan dan kata laluan baharu.',
    registeredEmail: 'Emel Berdaftar',
    sendResetLink: 'Hantar Pautan Tetapan Semula',
    verificationCode: 'Kod Pengesahan',
    enterCode: 'Masukkan kod',
    enterVerificationCode: 'Masukkan kod pengesahan',
    newPassword: 'Kata Laluan Baharu',
    enterNewPassword: 'Masukkan kata laluan baharu',
    reenterNewPassword: 'Masukkan semula kata laluan baharu',
    updatePassword: 'Kemas Kini Kata Laluan',

    // Profile
    activeRegisteredUser: 'Pengguna Berdaftar Aktif',
    notification: 'Notifikasi',
    profileManagement: 'Pengurusan Profil',
    manageUserProfile: 'Urus Profil Pengguna',
    notificationPreference: 'Tetapan Notifikasi',
    saveProfile: 'Simpan Profil',
    instant: 'Serta-merta',
    daily: 'Harian',
    weekly: 'Mingguan',
    emailPlaceholder: 'aina@johor.gov.my',
    accountDeactivation: 'Nyahaktif Akaun',
    requestAccountDeactivation: 'Mohon Nyahaktif Akaun',
    deactivationDesc: 'Hantar permohonan untuk menyahaktifkan akaun anda. Permohonan ini akan disemak oleh pentadbir sebelum akaun dinyahaktifkan.',
    reasonForDeactivation: 'Sebab Nyahaktif Akaun',
    deactivationPlaceholder: 'Contoh: Saya tidak lagi memerlukan akses ke Johor HR Knowledge Hub.',
    typeDeactivate: 'Taip DEACTIVATE untuk pengesahan',
    submitDeactivation: 'Hantar Permohonan Nyahaktif',

    // Security
    accountSecurity: 'Keselamatan Akaun',
    mfaEnabled: 'MFA Diaktifkan',
    mfaDisabled: 'MFA Dinyahaktifkan',
    changePassword: 'Tukar Kata Laluan',
    changePasswordDesc: 'Kemas kini kata laluan semasa log masuk.',
    currentPassword: 'Kata Laluan Semasa',
    confirmNewPassword: 'Sahkan Kata Laluan Baharu',
    change: 'Tukar',
    enableMfa: 'Aktifkan MFA',
    enableMfaDesc: 'Gunakan kod pengesahan semasa log masuk.',
    useVerificationCode: 'Gunakan kod pengesahan semasa log masuk.',
    enable: 'Aktifkan',
    disable: 'Nyahaktifkan',
    deactivateAccount: 'Nyahaktifkan Akaun',
    deactivateDesc: 'Mohon nyahaktifkan akaun sendiri.',
    request: 'Mohon',
    accountDeactivation: 'Nyahaktif Akaun',
    requestAccountDeactivation: 'Mohon Nyahaktif Akaun',
    deactivationDesc: 'Hantar permohonan untuk menyahaktifkan akaun anda. Permohonan ini akan disemak oleh pentadbir sebelum akaun dinyahaktifkan.',
    reasonForDeactivation: 'Sebab Nyahaktif Akaun',
    deactivationPlaceholder: 'Contoh: Saya tidak lagi memerlukan akses ke Johor HR Knowledge Hub.',
    typeDeactivate: 'Taip DEACTIVATE untuk pengesahan',
    submitDeactivation: 'Hantar Permohonan Nyahaktif',

    // Admin Workspace
    adminWorkspace: 'Ruang Kerja Pentadbir',
    adminWorkspaceDesc: 'Urus pengguna, kebenaran, dokumen, cadangan AI dan log audit.',
    adminControlDesc: 'Pentadbir boleh mengawal akses pengguna, peranan dan rekod sistem.',
    users: 'Pengguna',
    documents: 'Dokumen',
    auditEvents: 'Peristiwa Audit',
    registeredAccounts: 'Akaun berdaftar',
    repositoryRecords: 'Rekod repositori',
    systemActivityLogs: 'Log Aktiviti Sistem',
    systemActivityLogNote: 'Log aktiviti sistem',
    hrEscalation: 'Eskalasi HR',
    escalationRequestsFromUsers: 'Permohonan Eskalasi daripada Pengguna',
    submittedAt: 'Dihantar Pada',
    markResolved: 'Tanda Selesai',
    completed: 'Selesai',
    noEscalationSubmitted: 'Tiada permohonan eskalasi dihantar.',
    rolePermission: 'Kawalan Peranan dan Kebenaran',
    createRole: 'Cipta Peranan',
    editRole: 'Edit Peranan',
    roleManagement: 'Pengurusan Peranan',
    createNewRole: 'Cipta Peranan Baharu',
    saveChanges: 'Simpan Perubahan',
    roleName: 'Nama Peranan',
    roleDescription: 'Penerangan Peranan',
    permissions: 'Kebenaran',
    roleNamePlaceholder: 'Contoh: Penyemak Dokumen',
    roleDescriptionPlaceholder: 'Terangkan fungsi peranan ini...',
    permissionsPlaceholder: 'Masukkan kebenaran dipisahkan dengan koma',
    userAccountManagement: 'Pengurusan Akaun Pengguna',
    createdAt: 'Dicipta Pada',
    updatedAt: 'Dikemas Kini Pada',
    suspend: 'Gantung',
    reactivate: 'Aktifkan Semula',
    filterLogs: 'Tapis Log',
    adminProfile: 'Profil Admin',
    manageAdminProfile: 'Urus Profil Admin',
    administrator: 'Pentadbir',

    // Document Management
    documentManagement: 'Pengurusan Dokumen',
    documentManagementTitle: 'Muat naik, klasifikasi, simpan, cari dan urus dokumen HR.',
    administrators: 'Pentadbir',
    adminsDocumentDesc: 'Boleh memuat naik dokumen rasmi HR, menyemak cadangan klasifikasi AI, mengurus repositori dokumen dan mengarkibkan pekeliling lama.',
    guestUser: 'Pengguna',
    guestUserDocumentDesc: 'Semak imbas, cari dan lihat dokumen HR yang tersedia mengikut tahap akses.',
    totalDocuments: 'Jumlah Dokumen',
    pendingReview: 'Menunggu Semakan',
    archived: 'Diarkibkan',
    published: 'Diterbitkan',
    restricted: 'Terhad',
    aiClassificationQueue: 'Barisan klasifikasi AI',
    oldCircularVersions: 'Versi pekeliling lama',
    availableDocuments: 'Dokumen tersedia',
    protectedDocuments: 'Dokumen dilindungi',
    documentUpload: 'Muat Naik Dokumen',
    uploadHrDocument: 'Muat Naik Dokumen HR',
    uploadSubmitReview: 'Muat Naik & Hantar untuk Semakan',
    saveAsDraft: 'Simpan sebagai Draf',
    documentTitle: 'Tajuk Dokumen',
    officialReferenceNumber: 'Nombor Rujukan Rasmi',
    issuingAuthority: 'Pihak Berkuasa Pengeluar',
    expiryDate: 'Tarikh Luput',
    departmentTag: 'Tag Jabatan',
    selectDepartment: '— Pilih Jabatan —',
    accessLevel: 'Tahap Akses',
    language: 'Bahasa',
    pdfFile: 'Fail PDF',
    choosePdfFile: 'Klik untuk pilih fail PDF',
    dragDropPdf: 'atau seret dan lepas di sini · PDF sahaja · Maksimum 20MB',
    fileSelected: 'Fail dipilih',
    remove: 'Buang',

    // AI Classification
    aiClassificationReview: 'Semakan Klasifikasi AI',
    suggestedDocumentCategories: 'Kategori Dokumen Dicadangkan',
    refreshSuggestions: 'Segar Semula Cadangan',
    classificationDesc: 'Semak dan luluskan atau ubah kategori dan tag jabatan yang dicadangkan oleh AI sebelum setiap dokumen diterbitkan.',
    noClassification: 'Tiada dokumen menunggu semakan klasifikasi.',
    aiConfidence: 'Keyakinan AI',
    suggestedCategories: 'Kategori Dicadangkan',
    departmentTags: 'Tag Jabatan',
    modifyCategory: 'Ubah Kategori',
    modifyDepartmentTag: 'Ubah Tag Jabatan',
    approve: 'Luluskan',
    approved: 'Diluluskan',
    modify: 'Ubah',
    reject: 'Tolak',

    // Repository
    repositorySearch: 'Repositori & Carian',
    searchManageDocuments: 'Cari dan Urus Dokumen',
    uploadNewVersion: 'Muat Naik Versi Baharu',
    allTypes: 'Semua Jenis',
    allCategories: 'Semua Kategori',
    allStatuses: 'Semua Status',
    allAccessLevels: 'Semua Tahap Akses',
    showing: 'Memaparkan',
    result: 'keputusan',
    results: 'keputusan',
    forText: 'untuk',
    document: 'Dokumen',
    referenceNo: 'No. Rujukan',
    views: 'Paparan',
    noDocumentsMatch: 'Tiada dokumen sepadan dengan tapisan anda.',
    viewDetails: 'Lihat Butiran',
    download: 'Muat Turun',
    newVersion: 'Versi Baharu',
    archive: 'Arkib',
    restore: 'Pulihkan',

    // Archive and Version
    archiveDocument: 'Arkib Dokumen',
    archiveDesc: 'Pengarkiban akan mengeluarkan dokumen ini daripada edaran aktif. Pengguna yang menyimpan salinan akan dimaklumkan.',
    archiveReason: 'Sebab Arkib',
    selectReason: '— Pilih sebab —',
    supersededReason: 'Digantikan oleh pekeliling baharu',
    expiredReason: 'Dokumen telah tamat tempoh',
    withdrawnReason: 'Ditarik balik secara rasmi',
    otherReason: 'Sebab lain',
    successorReference: 'Rujukan Dokumen Pengganti (jika diganti)',
    additionalNotes: 'Nota Tambahan',
    additionalNotesPlaceholder: 'Berikan penjelasan tambahan...',
    confirmArchive: 'Sahkan Arkib',
    versionManagement: 'Pengurusan Versi',
    documentToUpdate: 'Dokumen untuk Dikemas Kini',
    selectDocument: '— Pilih dokumen —',
    currentVersion: 'Semasa',
    newVersionWillBe: 'Versi baharu ialah',
    updateType: 'Jenis Kemas Kini',
    selectType: '— Pilih jenis —',
    amendment: 'Pindaan',
    replacement: 'Penggantian',
    correction: 'Pembetulan',
    withdrawal: 'Penarikan balik',
    changeSummary: 'Ringkasan Perubahan',
    changeSummaryPlaceholder: 'Terangkan perubahan dalam versi ini...',
    newPdfFile: 'Fail PDF Baharu',
    newEffectiveDate: 'Tarikh Berkuat Kuasa Baharu (jika berubah)',

    // Preview and Audit
    documentDetails: 'Butiran Dokumen',
    totalViews: 'Jumlah Paparan',
    documentAuditTrail: 'Jejak Audit Dokumen',
    recentDocumentActions: 'Tindakan Dokumen Terkini',
    exportLog: 'Eksport Log',
    noAuditActions: 'Tiada tindakan audit direkodkan lagi. Tindakan akan muncul di sini selepas anda memuat naik, mengklasifikasi, mengarkib atau mengemas kini dokumen.',

    // Smart Support
    smartSearch: 'Carian Pintar',
    smartSearchTitle: 'Cari polisi HR menggunakan soalan biasa.',
    smartSearchDesc: 'Taip soalan dan sistem akan mencadangkan dokumen berkaitan.',
    smartSearchPlaceholder: 'Contoh: subsidi TASKA, kenaikan pangkat TBK, perjalanan SPKN...',
    sortResults: 'Susun Keputusan',
    relevance: 'Kerelevanan',
    latestUpdated: 'Kemas Kini Terkini',
    titleAz: 'Tajuk A-Z',
    mostViewed: 'Paling Banyak Dilihat',
    performSmartSearch: 'Jalankan Carian Pintar',
    clearSearch: 'Kosongkan Carian',
    recentSearchHistory: 'Sejarah Carian Terkini',
    noRecentSearch: 'Tiada sejarah carian terkini.',
    hrAssistant: 'Pembantu HR',
    askChatbot: 'Tanya Chatbot HR',
    suggestedQuestions: 'Soalan dicadangkan',
    chatbotPlaceholder: 'Tanya tentang log masuk, dokumen, cuti, kenaikan pangkat, gaji, muat naik...',
    send: 'Hantar',
    helpful: 'Membantu',
    notHelpful: 'Tidak Membantu',
    escalateHrOfficer: 'Rujuk kepada Pegawai HR',
    optionalFeedback: 'Komen maklum balas chatbot secara pilihan...',
    hrOfficerSupport: 'Sokongan Pegawai HR',
    escalateQuestion: 'Panjangkan Soalan',
    questionPlaceholder: 'Masukkan soalan untuk dieskalasikan...',
    descriptionPlaceholder: 'Terangkan sebab soalan ini memerlukan sokongan pegawai HR...',
    submitHrOfficer: 'Hantar kepada Pegawai HR',
    conversationHistory: 'Sejarah Perbualan',
    rating: 'Penilaian',
    noConversation: 'Tiada sejarah perbualan.',
    escalationRequests: 'Permohonan Eskalasi',
    noEscalation: 'Tiada permohonan eskalasi dihantar.',
    smartSearchResults: 'Dokumen Keputusan Carian Pintar',
    searchResult: 'Keputusan Carian',
    saveDocument: 'Simpan Dokumen',
    generateSummary: 'Jana Ringkasan',
    noMatchingSmartDocument: 'Tiada dokumen sepadan dijumpai. Cuba cari TASKA, TBK, SPKN, COS, CFS, kenaikan pangkat atau kontrak.',
    recommendations: 'Cadangan',
    recommendedDocuments: 'Dokumen Dicadangkan',
    recommended: 'Dicadangkan',
    reason: 'Sebab',
    relevanceScore: 'Skor Kerelevanan',
    reportIncorrect: 'Lapor Tidak Tepat',
    noRecommended: 'Tiada dokumen cadangan tersedia.',
    aiDocumentSummary: 'Ringkasan Dokumen AI',
    recommendationReport: 'Laporan Cadangan',
    reportIncorrectRecommendation: 'Lapor Cadangan Tidak Tepat',
    reporting: 'Melaporkan',
    irrelevant: 'Tidak berkaitan',
    inaccurate: 'Tidak tepat',
    outdated: 'Lapuk',
    inappropriate: 'Tidak sesuai',
    others: 'Lain-lain',
    reportDescriptionPlaceholder: 'Terangkan sebab cadangan ini tidak tepat...',
    submitReport: 'Hantar Laporan',
    faq: 'FAQ',
    frequentlyAskedQuestions: 'Soalan Lazim',
    trendingDocuments: 'Dokumen Trending',
    popularDocuments: 'Dokumen HR Popular Semasa',
    trending: 'Trending',
    score: 'Skor',
    frequentlyUsedPolicies: 'Polisi Kerap Digunakan',
    suggestedFrequentlyUsed: 'Cadangan Polisi Kerap Digunakan',
    frequentlyUsed: 'Kerap Digunakan',

    // Personal Storage and Notifications
    savedNotifications: 'Dokumen Disimpan dan Notifikasi',
    savedNotificationsTitle: 'Jejak dokumen disimpan, nota dan kemas kini polisi.',
    savedNotificationsDesc: 'Pengguna menerima amaran apabila dokumen berkaitan atau dokumen disimpan dikemas kini.',
    saved: 'Disimpan',
    unreadAlerts: 'Amaran Belum Dibaca',
    notes: 'Nota',
    personalCollection: 'Koleksi peribadi',
    policyUpdates: 'Kemas kini polisi',
    personalNotes: 'Nota peribadi',
    notificationPreferences: 'Tetapan Notifikasi',
    manageAlerts: 'Urus Amaran',
    savePreferences: 'Simpan Tetapan',
    policyUpdatesTitle: 'Kemas Kini Polisi',
    policyUpdatesDesc: 'Maklumkan apabila dokumen berkaitan baharu diterbitkan.',
    savedDocumentUpdates: 'Kemas Kini Dokumen Disimpan',
    savedDocumentUpdatesDesc: 'Maklumkan apabila dokumen yang ditanda buku diganti.',
    frequency: 'Kekerapan',
    frequencyDesc: 'Pilih notifikasi serta-merta, harian atau mingguan.',
    deliveryChannel: 'Saluran Penghantaran',
    deliveryChannelDesc: 'Pilih cara notifikasi dihantar.',
    enabled: 'Diaktifkan',
    disabled: 'Dinyahaktifkan',
    smartAlerts: 'Amaran Pintar',
    recommendedAlerts: 'Amaran Dicadangkan Berdasarkan Aktiviti Pengguna',
    refreshAlerts: 'Segar Semula Amaran',
    markRead: 'Tanda sebagai Dibaca',
    markAllRead: 'Tanda Semua Dibaca',
    noSmartAlerts: 'Tiada amaran pintar tersedia.',
    recentNotifications: 'Notifikasi Terkini',
    policyUpdatesAlerts: 'Kemas Kini Polisi dan Amaran',
    noNotifications: 'Tiada notifikasi tersedia.',
    userFeedback: 'Maklum Balas Pengguna',
    submitFeedback: 'Hantar Maklum Balas',
    feedbackCategory: 'Kategori Maklum Balas',
    feedbackContent: 'Kandungan Maklum Balas',
    feedbackPlaceholder: 'Tulis maklum balas anda di sini...',
    systemIssue: 'Isu Sistem',
    documentIssue: 'Isu Dokumen',
    chatbotIssue: 'Isu Chatbot',
    searchIssue: 'Isu Carian',
    suggestion: 'Cadangan',
    personalStorage: 'Simpanan Peribadi',
    savedPersonalNotes: 'Dokumen Disimpan dan Nota Peribadi',
    personalNote: 'Nota Peribadi',
    noteContent: 'Kandungan Nota',
    notePlaceholder: 'Tulis nota peribadi anda untuk dokumen ini...',
    saveNote: 'Simpan Nota',
    note: 'Nota',
    noPersonalNote: 'Tiada nota peribadi lagi.',
    editNote: 'Edit Nota',
    addNote: 'Tambah Nota',
    deleteNote: 'Padam Nota',
    noSavedDocuments: 'Tiada dokumen disimpan lagi. Pergi ke Sokongan Pintar dan simpan satu dokumen.'
  }
}

function t(key) {
  return translations[language.value]?.[key] || translations.en[key] || key
}

function tv(value) {
  if (!value) return ''
  const key = String(value)
    .replace(/[^a-zA-Z0-9]+/g, ' ')
    .trim()
    .split(' ')
    .map((word, index) =>
      index === 0
        ? word.charAt(0).toLowerCase() + word.slice(1)
        : word.charAt(0).toUpperCase() + word.slice(1)
    )
    .join('')

  return translations[language.value]?.[key] || translations.en[key] || value
}

function toggleLanguage() {
  language.value = language.value === 'en' ? 'ms' : 'en'
  showToast(
    language.value === 'en'
      ? 'Language changed to English.'
      : 'Bahasa ditukar kepada Bahasa Malaysia.',
    'success'
  )
}

const visibleNavItems = computed(() => {
  if (session.value === 'Admin') {
    return navItems.filter((item) => item.id !== 'auth')
  }

  return navItems.filter(
    (item) => !['auth', 'profile', 'admin'].includes(item.id)
  )
})

const repoQuery = ref('')
const repoType = ref('All Types')
const smartQuery = ref('')
const smartSortBy = ref('relevance')
const searchSuggestions = ref([])
const recentSearchHistory = ref([])
const trendingDocuments = ref([])
const frequentlyUsedPolicies = ref([])
const lastSearchKeyword = ref('')

watch(smartQuery, () => {
  loadSearchSuggestions()
})
//const smartResults = ref(documents.value.filter((doc) => doc.access !== 'Restricted'))

const mfaEnabled = ref(true)
const policyUpdateEnabled = ref(true)
const deactivationModalOpen = ref(false)
const deactivationForm = ref({
  reason: '',
  confirmText: ''
})
const changePasswordModalOpen = ref(false)

const changePasswordForm = ref({
  currentPassword: '',
  newPassword: '',
  confirmPassword: ''
})

function submitChangePassword() {
  if (
    !changePasswordForm.value.currentPassword ||
    !changePasswordForm.value.newPassword ||
    !changePasswordForm.value.confirmPassword
  ) {
    showToast('Please complete all password fields.', 'info')
    return
  }

  if (changePasswordForm.value.newPassword !== changePasswordForm.value.confirmPassword) {
    showToast('New password and confirm password do not match.', 'error')
    return
  }

  showToast('Password updated successfully.', 'success')
  addLog('Changed password', 'Profile Management', 'Success', session.value)
  cancelChangePassword()
}

function cancelChangePassword() {
  changePasswordModalOpen.value = false

  changePasswordForm.value = {
    currentPassword: '',
    newPassword: '',
    confirmPassword: ''
  }
}

const savedUpdateEnabled = ref(true)
const notificationFrequency = ref('Daily')
const deliveryChannel = ref('In-System')

const feedbackForm = ref({
  feedbackCategory: 'System Issue',
  feedbackContent: ''
})

const noteForm = ref({
  savedId: null,
  documentId: null,
  title: '',
  noteContent: ''
})

const resetForm = ref({
  email: '',
  code: '',
  newPassword: ''
})

const adminLoginForm = ref({
  email: '',
  password: '',
  mfa: ''
})

const profileForm = ref({
  name: 'Nur Aina Rahman',
  email: 'aina@johor.gov.my',
  department: 'Human Resource Management Division',
  designation: 'Assistant Officer'
})

const uploadForm = ref({
  title: '',
  referenceNo: '',
  issuingAuthority: '',
  effectiveDate: '',
  expiryDate: '',
  departmentTag: '',
  type: 'Guideline',
  category: 'Leave Policy',
  access: 'Registered',
  language: 'BM',
  fileName: '',
  fileSizeKb: 0,
  fileObject: null
})

// ── Subsystem 2 new reactive state ──

const showPreviewModal = ref(false)
const previewDocument = ref(null)

const repoCategory = ref('')
const repoStatus = ref('')
const repoAccess = ref('')
const uploadStatus = ref(null)
const showArchiveModal = ref(false)
const archiveTarget = ref(null)
const archiveForm = ref({ reason: '', successorReference: '', reasonDetails: '' })
const showVersionModal = ref(false)
const versionForm = ref({
  documentId: '',
  changeSummary: '',
  updateType: '',
  newEffectiveDate: '',
  fileName: '',
  fileObject: null
})
const documentAuditLog = ref([
  {
     id: 1,
    actionType: 'upload',
    actionLabel: 'Document Uploaded',
    documentTitle: 'Employee Leave Policy 2026',
    actionDetails: 'Uploaded by Administrator',
    createdAt: '19 Jun 2026 10:00 AM'
  },
  {
    id: 2,
    actionType: 'classification',
    actionLabel: 'AI Classification Approved',
    documentTitle: 'Promotion Guidelines',
    actionDetails: 'Category approved as Promotion',
    createdAt: '19 Jun 2026 10:15 AM'
  },
  {
    id: 3,
    actionType: 'archive',
    actionLabel: 'Document Archived',
    documentTitle: 'Disciplinary Action Procedures',
    actionDetails: 'Superseded by newer circular',
    createdAt: '19 Jun 2026 10:30 AM'
  },
  {
    id: 4,
    actionType: 'version',
    actionLabel: 'New Version Uploaded',
    documentTitle: 'Promotion Guidelines',
    actionDetails: 'Version 2.0 uploaded',
    createdAt: '19 Jun 2026 11:00 AM'

  }
])


const fileInputRef = ref(null)
const versionFileInputRef = ref(null)


const chatInput = ref('')
const conversationHistory = ref([])
const latestConversationId = ref(null)
const generatedSummary = ref('')
const selectedSummaryDoc = ref(null)
const searchResultSummary = ref('')
const selectedSearchSummaryDoc = ref(null)
const ratingComment = ref('')
const escalationPanelOpen = ref(false)
const escalationRequests = ref([])

const escalationForm = ref({
  question: '',
  description: ''
})

const chatMessages = ref([
  {
    sender: 'bot',
    text: 'Hi, I am the Johor HR Knowledge Hub assistant. What can I help you?'
  }
])

const currentPageTitle = computed(() => {
  const found = navItems.find((item) => item.id === screen.value)
  return found ? t(found.labelKey) : 'Dashboard'
})

const sessionText = computed(() => {
  if (session.value === 'Guest') return t('publicMode')
  if (session.value === 'Admin') return t('adminSession')
  return t('userSession')
})

const filteredDocs = computed(() => {
  return documents.value.filter((doc) => {
    const searchText = `${doc.title} ${doc.referenceNo} ${doc.category}`.toLowerCase()
    const matchesQuery = searchText.includes(query.value.toLowerCase())
    const matchesCategory = category.value === 'All' || doc.category === category.value
    return matchesQuery && matchesCategory
  })
})

const repositoryDocs = computed(() => {
  return documents.value.filter((doc) => {

    // Access Control
    if (session.value !== 'Admin' && doc.access === 'Restricted') {
      return false
    }

    const searchText = `${doc.title} ${doc.referenceNo} ${doc.category}`.toLowerCase()
    const matchesQuery = !repoQuery.value || searchText.includes(repoQuery.value.toLowerCase())
    const matchesType = !repoType.value || doc.type === repoType.value
    const matchesCategory = !repoCategory.value || doc.category === repoCategory.value
    const matchesStatus = !repoStatus.value || doc.status === repoStatus.value
    const matchesAccess = !repoAccess.value || doc.access === repoAccess.value
    return matchesQuery && matchesType && matchesCategory && matchesStatus && matchesAccess
  })
})

const pendingClassificationCount = computed(() => {
  return classificationQueue.value.filter((item) => item.status !== 'Approved').length
})

const archivedCount = computed(() => {
  return documents.value.filter((doc) => doc.status === 'Archived').length
})

const unreadNotifications = computed(() => {
  return notifications.value.filter((notice) => !notice.read).length
})

function addLog(action, module, result = 'Success', user = 'System') {
  logs.value.unshift({
    id: `LOG-${Date.now()}`,
    user,
    action,
    module,
    time: 'Just now',
    result
  })
}

function getCurrentDateTime() {
  return new Date().toLocaleString('en-MY', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

function normalizeUsers() {
  users.value = users.value.map((user) => {
    return {
      ...user,
      designation: user.designation || 'Not assigned',
      created_at: user.created_at || getCurrentDateTime(),
      updated_at: user.updated_at || getCurrentDateTime()
    }
  })

  const defaultUsers = [
    {
      id: 'USR003',
      name: 'Tung Ern',
      email: 'tungern@johor.gov.my',
      department: 'Knowledge and Document Management Unit',
      designation: 'Document Officer',
      role: 'Registered User',
      status: 'Active',
      created_at: '2026-01-05 10:00 AM',
      updated_at: '2026-01-05 10:00 AM'
    },
    {
      id: 'ADM002',
      name: 'Yuan Man',
      email: 'yuanman@johor.gov.my',
      department: 'Intelligent Recommendation and Support Unit',
      designation: 'AI Support Administrator',
      role: 'Administrator',
      status: 'Active',
      created_at: '2026-01-14 11:20 AM',
      updated_at: '2026-01-14 11:20 AM'
    }
  ]

  defaultUsers.forEach((defaultUser) => {
    const existingUser = users.value.find((user) => user.email === defaultUser.email)

    if (existingUser) {
      existingUser.id = defaultUser.id
      existingUser.name = defaultUser.name
      existingUser.department = defaultUser.department
      existingUser.designation = defaultUser.designation
      existingUser.role = defaultUser.role
      existingUser.status = defaultUser.status
      existingUser.created_at = existingUser.created_at || defaultUser.created_at
      existingUser.updated_at = getCurrentDateTime()
    } else {
      users.value.push(defaultUser)
    }
  })
}

function fakeLogin(type) {
  session.value = type
  screen.value = type === 'Admin' ? 'admin' : 'personal'
  toast.value = `${type} session created.`
  addLog(`${type} demo login`, 'Authentication', 'Success', type)
}

function getLoginKey(email) {
  return email.trim().toLowerCase()
}

function getFailedAttempts(email) {
  const key = getLoginKey(email)
  return failedLoginAttempts.value[key] || 0
}

function isPrototypeLocked(email) {
  const key = getLoginKey(email)
  return lockedPrototypeAccounts.value[key] === true
}

function recordFailedLogin(email) {
  const key = getLoginKey(email)

  if (!key) {
    loginLockMessage.value = t('enterEmailBeforeAttempt')
    return
  }

  failedLoginAttempts.value[key] = (failedLoginAttempts.value[key] || 0) + 1

  const attempts = failedLoginAttempts.value[key]
  const remaining = MAX_LOGIN_ATTEMPTS - attempts

  if (attempts >= MAX_LOGIN_ATTEMPTS) {
    lockedPrototypeAccounts.value[key] = true
    loginLockMessage.value = t('accountLockedAfterAttempts')
  } else {
    loginLockMessage.value =
      `${attempts} ${t('failedAttemptText')} ${remaining} ${t('attemptRemainingText')}`
  }
}

function resetFailedLogin(email) {
  const key = getLoginKey(email)
  failedLoginAttempts.value[key] = 0
  lockedPrototypeAccounts.value[key] = false
  loginLockMessage.value = ''
}

function userLogin() {
  loginLockMessage.value = ''

  if (!loginForm.value.email || !loginForm.value.password) {
    showToast('Please enter email and password.', 'info')
    addLog('Failed login attempt', 'User Login', 'Warning', 'Unknown User')
    recordFailedLogin(loginForm.value.email)
    return
  }

  if (isPrototypeLocked(loginForm.value.email)) {
    loginLockMessage.value = t('accountLockedAfterAttempts')
    showToast(t('accountLockedToast'), 'error')
    addLog('Login blocked - account locked', 'User Login', 'Warning', loginForm.value.email)
    return
  }

  if (loginForm.value.password.length < 8) {
    showToast('Password must contain at least 8 characters.', 'error')
    addLog('Failed login attempt - invalid password length', 'User Login', 'Warning', loginForm.value.email)
    recordFailedLogin(loginForm.value.email)
    return
  }

  if (loginForm.value.mfa && !/^\d{6}$/.test(loginForm.value.mfa)) {
    showToast('MFA code must be 6 digits.', 'error')
    addLog('Failed login attempt - invalid MFA code', 'User Login', 'Warning', loginForm.value.email)
    recordFailedLogin(loginForm.value.email)
    return
  }

  const loggedInUser = users.value.find(
    (user) =>
      user.email.toLowerCase() === loginForm.value.email.toLowerCase() &&
      user.role.toLowerCase().includes('registered')
  )

  if (!loggedInUser) {
    showToast('User account not found.', 'error')
    addLog('Failed login attempt - account not found', 'User Login', 'Warning', loginForm.value.email)
    recordFailedLogin(loginForm.value.email)
    return
  }

  if (loggedInUser.status !== 'Active') {
    showToast('This account is not active.', 'error')
    addLog('Failed login attempt - inactive account', 'User Login', 'Warning', loggedInUser.name)
    return
  }

  resetFailedLogin(loginForm.value.email)

  profileForm.value = {
    name: loggedInUser.name,
    email: loggedInUser.email,
    department: loggedInUser.department,
    designation: loggedInUser.designation
  }

  session.value = 'User'
  screen.value = 'profile'
  showToast(`${loggedInUser.name} logged in successfully.`, 'success')
  addLog('User login', 'Authentication', 'Success', loggedInUser.name)
}

function adminLogin() {
  if (!adminLoginForm.value.email || !adminLoginForm.value.password) {
    showToast('Please enter admin email and password.', 'info')
    return
  }

  const loggedInAdmin = users.value.find(
  (user) =>
    user.email.toLowerCase() === adminLoginForm.value.email.toLowerCase() &&
    user.role.toLowerCase().includes('administrator')
  )

  profileForm.value = {
    name: loggedInAdmin.name,
    email: loggedInAdmin.email,
    department: loggedInAdmin.department,
    designation: loggedInAdmin.designation
  }

  session.value = 'Admin'
  screen.value = 'admin'
  showToast(`${loggedInAdmin.name} logged in successfully as administrator.`, 'success')
  addLog('Admin login', 'Admin Authentication', 'Success', loggedInAdmin.name)
}

function registerUser() {
  if (!registerForm.value.name || !registerForm.value.email || !registerForm.value.password) {
    showToast('Please complete name, email and password.', 'info')
    return
  }

  const now = getCurrentDateTime()

  const newUser = {
    id: `USR${Date.now()}`,
    name: registerForm.value.name,
    email: registerForm.value.email,
    department: registerForm.value.department || 'Not assigned',
    designation: registerForm.value.designation || 'Not assigned',
    role: 'Registered User',
    status: 'Active',
    created_at: now,
    updated_at: now
  }
  users.value.unshift(newUser)

  registerForm.value = {
    name: '',
    email: '',
    department: '',
    designation: '',
    password: ''
  }

  showToast('Registration submitted successfully. New user is added to admin table.', 'success')
  addLog('Registered new account', 'Registration', 'Success', newUser.name)
}

function sendResetLink() {
  if (!resetForm.value.email) {
    showToast('Please enter registered email first.', 'info')
    return
  }

  showToast('Password reset link sent to verified government email.', 'success')
  addLog('Requested password reset link', 'Password Reset', 'Success', resetForm.value.email)
}

function updatePassword() {
  if (!resetForm.value.code || !resetForm.value.newPassword) {
    showToast('Please enter verification code and new password.', 'info')
    return
  }

  showToast('Password updated successfully.', 'success')
  addLog('Updated password', 'Password Reset', 'Success', resetForm.value.email)

  resetForm.value = {
    email: '',
    code: '',
    newPassword: ''
  }
}

function logoutPrototype() {
  session.value = 'Guest'
  screen.value = 'public'
  showToast('Logged out successfully. You are now a guest.', 'success')
  addLog('User logged out', 'Logout', 'Success', 'Current User')
}

function openDocumentDetails(doc) {
  selectedDoc.value = doc
  publicDetailsModalOpen.value = true
  addLog('Viewed public document details', 'Public Search', 'Success', session.value)
}

function saveProfile() {
  const now = getCurrentDateTime()

  const currentUser = users.value.find((user) => user.email === profileForm.value.email)

  if (currentUser) {
    currentUser.name = profileForm.value.name
    currentUser.email = profileForm.value.email
    currentUser.department = profileForm.value.department
    currentUser.designation = profileForm.value.designation
    currentUser.updated_at = now
  }

  showToast('Profile updated successfully.', 'success')
  addLog('Updated profile information', 'Profile Management', 'Success', profileForm.value.name)
}

function toggleMfa() {
  mfaEnabled.value = !mfaEnabled.value
  showToast(mfaEnabled.value ? 'MFA has been enabled.' : 'MFA has been disabled.', 'success')
  addLog('Changed MFA setting', 'Account Security', 'Success', profileForm.value.name)
}

// ─── MODULE 4.1: DOCUMENT UPLOAD FUNCTIONS ───

function triggerFileInput() {
  fileInputRef.value?.click()
}

function handleFileSelect(event) {
  const file = event.target.files[0]
  if (!file) return
  if (file.type !== 'application/pdf') {
    uploadStatus.value = { type: 'error', message: 'Only PDF files are accepted.' }
    return
  }
  if (file.size > 20 * 1024 * 1024) {
    uploadStatus.value = { type: 'error', message: 'File size must not exceed 20MB.' }
    return
  }
  uploadForm.value.fileName = file.name
  uploadForm.value.fileSizeKb = Math.round(file.size / 1024)
  uploadForm.value.fileObject = file
  uploadStatus.value = null
}

function handleFileDrop(event) {
  const file = event.dataTransfer.files[0]
  if (!file) return
  handleFileSelect({ target: { files: [file] } })
}

function clearFile() {
  uploadForm.value.fileName = ''
  uploadForm.value.fileSizeKb = 0
  uploadForm.value.fileObject = null
  if (fileInputRef.value) fileInputRef.value.value = ''
}

function uploadDocument() {
  if (!uploadForm.value.title || !uploadForm.value.referenceNo) {
    toast.value = 'Please enter document title and reference number.'
    return
  }
  if (!uploadForm.value.issuingAuthority) {
    toast.value = 'Please enter the issuing authority.'
    return
  }
  if (!uploadForm.value.effectiveDate) {
    toast.value = 'Please enter the effective date.'
    return
  }
  if (!uploadForm.value.fileName) {
    toast.value = 'Please select a PDF file to upload.'
    return
  }

  const newDocument = {
    documentId: Date.now(),
    referenceNo: uploadForm.value.referenceNo,
    title: uploadForm.value.title,
    category: uploadForm.value.category,
    type: uploadForm.value.type || 'Guideline',
    status: 'Pending Review',
    access: uploadForm.value.access || 'Registered',
    language: uploadForm.value.language || 'BM',
    effectiveDate: uploadForm.value.effectiveDate,
    expiryDate: uploadForm.value.expiryDate || null,
    departmentTag: uploadForm.value.departmentTag || '',
    version: '1.0',
    fileName: uploadForm.value.fileName,
    fileSizeKb: uploadForm.value.fileSizeKb,
    totalViews: 0,
    totalDownloads: 0,
    summary: `Uploaded by ${uploadForm.value.issuingAuthority}. Pending AI classification review.`
  }

  documents.value.unshift(newDocument)
  selectedDoc.value = newDocument

  classificationQueue.value.unshift({
    id: Date.now(),
    title: uploadForm.value.title,
    status: 'Pending Review',
    suggestions: [uploadForm.value.category, 'HR Policy'],
    tags: [uploadForm.value.departmentTag || 'HRMD', uploadForm.value.type || 'Guideline'],
    confidence: Math.floor(Math.random() * 20) + 75,
    editing: false,
    modifiedCategory: '',
    modifiedDepartmentTag: ''
  })

  addAuditEntry('upload', newDocument.title, 'Document uploaded and sent for classification review')
  uploadStatus.value = { type: 'success', message: `"${newDocument.title}" uploaded and added to AI classification queue.` }
  resetUploadForm()
  toast.value = 'Document uploaded successfully.'
}

function saveDocumentAsDraft() {
  if (!uploadForm.value.title || !uploadForm.value.referenceNo) {
    toast.value = 'Please enter document title and reference number before saving draft.'
    return
  }

  const draftDocument = {
    documentId: Date.now(),
    referenceNo: uploadForm.value.referenceNo,
    title: uploadForm.value.title,
    category: uploadForm.value.category,
    type: uploadForm.value.type || 'Guideline',
    status: 'Draft',
    access: uploadForm.value.access || 'Registered',
    language: uploadForm.value.language || 'BM',
    effectiveDate: uploadForm.value.effectiveDate || 'Not set',
    departmentTag: uploadForm.value.departmentTag || '',
    version: '1.0',
    fileName: uploadForm.value.fileName || '',
    totalViews: 0,
    totalDownloads: 0,
    summary: `Draft saved by ${uploadForm.value.issuingAuthority || 'Administrator'}.`
  }

  documents.value.unshift(draftDocument)
  selectedDoc.value = draftDocument
  addAuditEntry('draft', draftDocument.title, 'Document saved as draft')
  resetUploadForm()
  toast.value = 'Document saved as draft.'
}

function resetUploadForm() {
  uploadForm.value = {
    title: '',
    referenceNo: '',
    issuingAuthority: '',
    effectiveDate: '',
    expiryDate: '',
    departmentTag: '',
    type: 'Guideline',
    category: 'Leave Policy',
    access: 'Registered',
    language: 'BM',
    fileName: '',
    fileSizeKb: 0,
    fileObject: null
  }
  if (fileInputRef.value) fileInputRef.value.value = ''
  uploadStatus.value = null
}

// ─── MODULE 4.2: AI CLASSIFICATION FUNCTIONS ───

function approveClassification(item) {
  item.status = 'Approved'
  item.editing = false
  const doc = documents.value.find(d => d.title === item.title)
  if (doc && doc.status === 'Pending Review') doc.status = 'Published'
  addAuditEntry('classify', item.title, 'AI classification approved')
  toast.value = `Classification approved for "${item.title}".`
}

function startModifyClassification(item) {
  item.editing = true
  item.modifiedCategory = item.suggestions[0]
  item.modifiedDepartmentTag = item.tags[0]
}

function confirmModifyClassification(item) {
  if (item.modifiedCategory) {
    item.suggestions = [item.modifiedCategory, ...item.suggestions.filter(s => s !== item.modifiedCategory)]
  }
  if (item.modifiedDepartmentTag) {
    item.tags = [item.modifiedDepartmentTag, ...item.tags.filter(t => t !== item.modifiedDepartmentTag)]
  }
  item.status = 'Approved'
  item.editing = false
  const doc = documents.value.find(d => d.title === item.title)
  if (doc) {
    if (item.modifiedCategory) doc.category = item.modifiedCategory
    if (item.modifiedDepartmentTag) doc.departmentTag = item.modifiedDepartmentTag
    if (doc.status === 'Pending Review') doc.status = 'Published'
  }
  addAuditEntry('classify', item.title, `Classification modified: ${item.modifiedCategory}`)
  toast.value = `Classification modified and approved for "${item.title}".`
}

function rejectClassification(item) {
  item.status = 'Rejected'
  item.editing = false
  addAuditEntry('classify', item.title, 'AI classification rejected')
  toast.value = `Classification rejected for "${item.title}".`
}

function refreshClassification() {
  classificationQueue.value.forEach(item => {
    if (item.status !== 'Approved') {
      item.confidence = Math.floor(Math.random() * 20) + 75
    }
  })
  toast.value = 'AI classification suggestions refreshed.'
  addLog('Refreshed AI classification suggestions', 'Document Classification', 'Success', 'Administrator')
}

// ─── MODULE 4.3 + 4.4: REPOSITORY FUNCTIONS ───

function previewRepositoryDoc(doc) {
  previewDoc.value = doc
  showPreviewModal.value = true

  addAuditEntry(
    'view',
    doc.title,
    'Viewed document details'
  )
}


// ─── MODULE 4.5: ARCHIVE FUNCTIONS ───

function openArchiveModal(doc) {
  if (doc.status === 'Archived') {
    toast.value = 'This document is already archived.'
    return
  }
  archiveTarget.value = doc
  archiveForm.value = { reason: '', successorReference: '', reasonDetails: '' }
  showArchiveModal.value = true
}

function confirmArchive() {
  if (!archiveForm.value.reason) {
    toast.value = 'Please select an archive reason.'
    return
  }
  archiveTarget.value.status = 'Archived'
  addAuditEntry('archive', archiveTarget.value.title,
    `Archived: ${archiveForm.value.reason}${archiveForm.value.successorReference ? ' · Successor: ' + archiveForm.value.successorReference : ''}`)
  notifications.value.unshift({
    id: Date.now(),
    title: 'Document archived',
    message: `${archiveTarget.value.title} has been archived.${archiveForm.value.successorReference ? ' Successor: ' + archiveForm.value.successorReference : ''}`,
    time: 'Just now',
    read: false
  })
  toast.value = `"${archiveTarget.value.referenceNo}" archived successfully.`
  showArchiveModal.value = false
  archiveTarget.value = null
}

function archiveDocument(doc) {
  archiveTarget.value = doc
  showArchiveModal.value = true
}

function restoreDocument(doc) {
  doc.status = 'Published'
  addAuditEntry('restore', doc.title, 'Restored archived document')
  toast.value = `"${doc.referenceNo}" restored successfully.`
}

// ─── MODULE 4.5: VERSION MANAGEMENT FUNCTIONS ───

function openNewVersionModal() {
  versionForm.value = {
    documentId: selectedDoc.value?.documentId || '',
    changeSummary: '',
    updateType: '',
    newEffectiveDate: '',
    fileName: '',
    fileObject: null
  }
  showVersionModal.value = true
}

function openVersionModal(doc) {
  versionForm.value = {
    documentId: doc.documentId,
    changeSummary: '',
    updateType: '',
    newEffectiveDate: '',
    fileName: '',
    fileObject: null
  }
  showVersionModal.value = true
}

function selectDocForVersion(doc) {
  selectedDoc.value = doc
  openNewVersionModal()
}

function triggerVersionFileInput() {
  versionFileInputRef.value?.click()
}

function handleVersionFileSelect(event) {
  const file = event.target.files[0]
  if (!file) return
  versionForm.value.fileName = file.name
  versionForm.value.fileObject = file
}

function handleVersionFileDrop(event) {
  const file = event.dataTransfer.files[0]
  if (!file) return
  versionForm.value.fileName = file.name
  versionForm.value.fileObject = file
}

const nextVersionNumber = computed(() => {
  if (!versionForm.value.documentId) return '2.0'
  const doc = documents.value.find(d => d.documentId == versionForm.value.documentId)
  if (!doc) return '2.0'
  const current = parseFloat(doc.version) || 1.0
  return (current + 1.0).toFixed(1)
})

function confirmUploadNewVersion() {
  if (!versionForm.value.documentId) {
    toast.value = 'Please select a document to update.'
    return
  }
  if (!versionForm.value.updateType) {
    toast.value = 'Please select an update type.'
    return
  }
  if (!versionForm.value.changeSummary) {
    toast.value = 'Please enter a change summary.'
    return
  }
  if (!versionForm.value.fileName) {
    toast.value = 'Please select the new PDF file.'
    return
  }
  const doc = documents.value.find(d => d.documentId == versionForm.value.documentId)
  if (!doc) return

  const newVersion = nextVersionNumber.value
  doc.version = newVersion
  doc.status = 'Published'
  if (versionForm.value.newEffectiveDate) doc.effectiveDate = versionForm.value.newEffectiveDate

  addAuditEntry('version', doc.title, `v${newVersion} uploaded: ${versionForm.value.changeSummary}`)
  notifications.value.unshift({
    id: Date.now(),
    title: 'Document updated',
    message: `${doc.title} has a new version (v${newVersion}). ${versionForm.value.changeSummary}`,
    time: 'Just now',
    read: false
  })
  toast.value = `"${doc.title}" updated to version ${newVersion}.`
  showVersionModal.value = false
}

// ─── AUDIT LOG HELPER ───

function addAuditEntry(actionType, documentTitle, actionDetails) {
  const labels = {
    upload: 'Document Uploaded',
    draft: 'Draft Saved',
    classify: 'Classification Reviewed',
    archive: 'Document Archived',
    version: 'New Version Uploaded'
  }
  documentAuditLog.value.unshift({
    id: Date.now(),
    actionType,
    actionLabel: labels[actionType] || actionType,
    documentTitle,
    actionDetails,
    performedBy: session.value === 'Admin' ? 'Administrator' : session.value,
    createdAt: new Date().toLocaleString('en-MY', { dateStyle: 'short', timeStyle: 'short' })
  })
}

async function loadSearchSuggestions() {
  try {
    const response = await fetch(
      `${API_BASE_URL}/api/search-suggestions?keyword=${encodeURIComponent(smartQuery.value)}`
    )

    if (!response.ok) {
      throw new Error('Failed to load search suggestions')
    }

    searchSuggestions.value = await response.json()
  } catch (error) {
    console.error(error)
  }
}

function selectSearchSuggestion(suggestion) {
  smartQuery.value = language.value === 'en' ? suggestion.suggestionText_en : suggestion.suggestionText_ms
  performSmartSearch()
}

async function loadRecentSearchHistory() {
  try {
    const response = await fetch(`${API_BASE_URL}/api/search-history/${currentUserId}`)

    if (!response.ok) {
      throw new Error('Failed to load recent search history')
    }

    recentSearchHistory.value = await response.json()
  } catch (error) {
    console.error(error)
  }
}

async function loadTrendingDocuments() {
  try {
    const response = await fetch(`${API_BASE_URL}/api/trending-documents`)

    if (!response.ok) {
      throw new Error('Failed to load trending documents')
    }

    trendingDocuments.value = await response.json()
  } catch (error) {
    console.error(error)
  }
}

async function loadFrequentlyUsedPolicies() {
  try {
    const response = await fetch(`${API_BASE_URL}/api/frequently-used-policies`)

    if (!response.ok) {
      throw new Error('Failed to load frequently used policies')
    }

    frequentlyUsedPolicies.value = await response.json()
  } catch (error) {
    console.error(error)
  }
}

async function performSmartSearch() {
  if (!smartQuery.value.trim()) {
    searchResults.value = []
    hasSearched.value = false
    toast.value = 'Please enter a keyword to search.'
    return
  }

  try {
    const response = await fetch(
      `${API_BASE_URL}/api/search?userId=${currentUserId}&keyword=${encodeURIComponent(smartQuery.value)}&sortBy=${smartSortBy.value}`
    )

    if (!response.ok) {
      throw new Error('Smart search failed')
    }

    const data = await response.json()

    searchResults.value = data.results
    hasSearched.value = true
    lastSearchKeyword.value = smartQuery.value

    await loadRecentSearchHistory()
    await loadSearchSuggestions()

    if (data.results.length === 0) {
      toast.value = 'No matching document found. Try another keyword such as TASKA, TBK, SPKN, COS, or CFS.'
      return
    }

    toast.value = 'Smart search completed. Results are shown in the Search Results section.'
    addLog('Performed smart search', 'Smart Search', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Smart search failed.'
  }
}

function highlightMatchedContent(text) {
  if (!text) return ''

  const keyword = lastSearchKeyword.value || smartQuery.value

  if (!keyword.trim()) {
    return text
  }

  const words = keyword
    .trim()
    .split(/\s+/)
    .filter((word) => word.length > 1)

  if (words.length === 0) {
    return text
  }

  let highlightedText = text

  words.forEach((word) => {
    const escapedWord = word.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
    const regex = new RegExp(`(${escapedWord})`, 'gi')
    highlightedText = highlightedText.replace(regex, '<mark>$1</mark>')
  })

  return highlightedText
}

function clearSearchResults() {
  smartQuery.value = ''
  searchResults.value = []
  hasSearched.value = false
  lastSearchKeyword.value = ''
  toast.value = 'Search results cleared.'
}

/*function refreshRecommendations() {
  smartResults.value = documents.value.filter((doc) => doc.access !== 'Restricted')
  toast.value = 'Recommendations refreshed based on department and recent searches.'
  addLog('Refreshed recommendations', 'Recommendation', 'Success', session.value)
}*/

async function refreshRecommendations() {
  try {
    const response = await fetch(
      `${API_BASE_URL}/api/recommendations/refresh/${currentUserId}`,
      {
        method: 'POST'
      }
    )

    if (!response.ok) {
      throw new Error('Failed to refresh recommendations')
    }

    await loadRecommendations()

    toast.value = 'Recommendations refreshed based on department and document activity.'
    addLog('Refreshed recommendations', 'Recommendation', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to refresh recommendations.'
  }
}

function openRecommendationReport(doc) {
  if (!doc.recommendationId) {
    toast.value = 'This recommendation cannot be reported because it has no recommendation record.'
    return
  }

  selectedRecommendation.value = doc
  recommendationReportForm.value = {
    reportReason: 'Irrelevant',
    reportDescription: ''
  }
  reportDialogOpen.value = true
}

async function submitRecommendationReport() {
  if (!selectedRecommendation.value) {
    toast.value = 'Please select a recommendation first.'
    return
  }

  try {
    const response = await fetch(`${API_BASE_URL}/api/recommendation-reports`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        recommendationId: selectedRecommendation.value.recommendationId,
        userId: currentUserId,
        reportReason: recommendationReportForm.value.reportReason,
        reportDescription: recommendationReportForm.value.reportDescription
      })
    })

    if (!response.ok) {
      throw new Error('Failed to submit recommendation report')
    }

    toast.value = 'Incorrect recommendation report submitted to administrator.'
    reportDialogOpen.value = false
    selectedRecommendation.value = null

    await loadRecommendations()

    addLog('Reported incorrect recommendation', 'Recommendation', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to submit recommendation report.'
  }
}

function cancelRecommendationReport() {
  reportDialogOpen.value = false
  selectedRecommendation.value = null
}

function askSuggestedQuestion(question) {
  chatInput.value = question
  sendChatMessage()
}

async function sendChatMessage() {
  const question = chatInput.value.trim()

  if (!question) {
    toast.value = 'Please type a question first.'
    return
  }

  chatMessages.value.push({
    sender: 'user',
    text: question
  })

  const answer = generateChatbotAnswer(question)

  chatMessages.value.push({
    sender: 'bot',
    text: answer
  })

  try {
    const response = await fetch(`${API_BASE_URL}/api/chatbot/conversations`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        userId: currentUserId,
        questionText: question,
        responseText: answer,
        confidenceScore: 88.00
      })
    })

    const data = await response.json()
    latestConversationId.value = data.conversationId

    await loadConversationHistory()
  } catch (error) {
    console.error(error)
    toast.value = 'Chatbot answered, but conversation was not saved.'
  }

  chatInput.value = ''
  toast.value = 'Chatbot response generated.'
  addLog('Used HR chatbot assistance', 'AI Chatbot', 'Success', session.value)
}

function sendSuggestedQuestion(question) {
  chatInput.value = question
  sendChatMessage()
}

async function rateChatbotResponse(value) {
  if (!latestConversationId.value) {
    toast.value = 'Please ask the chatbot a question before rating.'
    return
  }

  try {
    const response = await fetch(
      `${API_BASE_URL}/api/chatbot/conversations/${latestConversationId.value}/rating`,
      {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          ratingValue: value,
          ratingComment: ratingComment.value
        })
      }
    )

    if (!response.ok) {
      throw new Error('Failed to rate chatbot response')
    }

    toast.value = value === 1
      ? 'Thank you for rating the chatbot response as helpful.'
      : 'Thank you. Your feedback will help improve chatbot response quality.'

    ratingComment.value = ''
    await loadConversationHistory()
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to save chatbot rating.'
  }
}

async function generateDocumentSummary(doc) {
  selectedSummaryDoc.value = doc

  const fallbackSummary = buildLocalDocumentSummary(doc)

  try {
    const response = await fetch(`${API_BASE_URL}/api/document-summaries`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        documentId: doc.documentId,
        userId: currentUserId
      })
    })

    if (!response.ok) {
      throw new Error('Failed to generate document summary')
    }

    const data = await response.json()
    generatedSummary.value = data.summaryText || fallbackSummary

    toast.value = language.value === 'ms'
      ? 'Ringkasan dokumen telah dijana.'
      : 'Document summary generated.'
  } catch (error) {
    console.error(error)
    generatedSummary.value = fallbackSummary
    toast.value = language.value === 'ms'
      ? 'Ringkasan prototaip dijana tanpa sambungan backend.'
      : 'Prototype summary generated without backend connection.'
  }

  addLog('Generated document summary', 'AI Summary', 'Success', session.value)
}

function buildLocalDocumentSummary(doc) {
  const title = doc.title || 'Selected document'
  const category = doc.category || 'HR policy'
  const summary = doc.summary || 'This document contains HR policy information for Johor government officers.'

  if (language.value === 'ms') {
    return `Ringkasan untuk ${title}: Dokumen ini berkaitan dengan ${category}. ${summary} Ringkasan ini membantu pengguna memahami tujuan utama dokumen tanpa membaca keseluruhan kandungan.`
  }

  return `Summary for ${title}: This document is related to ${category}. ${summary} This generated summary helps users understand the main purpose of the document without reading the full content.`
}

async function generateSearchResultSummary(doc) {
  selectedSearchSummaryDoc.value = doc

  const fallbackSummary = buildLocalDocumentSummary(doc)

  try {
    const response = await fetch(`${API_BASE_URL}/api/document-summaries`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        documentId: doc.documentId,
        userId: currentUserId
      })
    })

    if (!response.ok) {
      throw new Error('Failed to generate document summary')
    }

    const data = await response.json()
    searchResultSummary.value = data.summaryText || fallbackSummary

    toast.value = language.value === 'ms'
      ? 'Ringkasan dokumen telah dijana.'
      : 'Document summary generated.'
  } catch (error) {
    console.error(error)
    searchResultSummary.value = fallbackSummary

    toast.value = language.value === 'ms'
      ? 'Ringkasan prototaip dijana tanpa sambungan backend.'
      : 'Prototype summary generated without backend connection.'
  }

  addLog('Generated search result document summary', 'AI Summary', 'Success', session.value)
}

function openEscalationPanel() {
  const latestUserMessage = [...chatMessages.value]
    .reverse()
    .find((message) => message.sender === 'user')

  escalationForm.value = {
    question: latestUserMessage ? latestUserMessage.text : '',
    description: latestUserMessage
      ? 'User requested HR officer support for this chatbot question.'
      : 'User requested HR officer support from FAQ or chatbot panel.'
  }

  escalationPanelOpen.value = true
}

async function submitEscalationRequest() {
  if (!escalationForm.value.question.trim()) {
    toast.value = 'Please enter a question before escalating.'
    return
  }

  try {
    const response = await fetch(`${API_BASE_URL}/api/escalation-requests`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        conversationId: latestConversationId.value,
        userId: currentUserId,
        escalationQuestion: escalationForm.value.question,
        escalationDescription: escalationForm.value.description
      })
    })

    if (!response.ok) {
      throw new Error('Failed to escalate question')
    }

    escalationPanelOpen.value = false

    escalationForm.value = {
      question: '',
      description: ''
    }

    toast.value = 'Question escalated to HR officer successfully.'

    await loadConversationHistory()
    await loadEscalationRequests()

    addLog('Escalated question to HR officer', 'AI Chatbot', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to escalate question.'
  }
}

function cancelEscalationPanel() {
  escalationPanelOpen.value = false
}

function generateChatbotAnswer(question) {
  const text = question.toLowerCase()

  if (
    text.includes('taska') ||
    text.includes('childcare') ||
    text.includes('subsidi') ||
    text.includes('subsidy')
  ) {
    return 'To apply for TASKA subsidy, the user should refer to the Borang Permohonan Subsidi TASKA and TASKA subsidy guideline. The application is for eligible public officers who want to claim childcare fee subsidy. The user needs to complete the application form and prepare supporting details such as officer information, spouse information, child information, household income details, TASKA confirmation, and required supporting documents.'
  }

  if (
    text.includes('tbk') ||
    text.includes('promotion') ||
    text.includes('pangkat') ||
    text.includes('kenaikan pangkat')
  ) {
    return 'TBK promotion refers to time-based promotion for eligible Johor public service officers. The TBK guideline explains matters such as TBK1 and TBK2, service period requirements, performance conditions, eligible officer categories, submission period, and promotion date determination.'
  }

  if (
    text.includes('spkn') ||
    text.includes('travel') ||
    text.includes('overseas') ||
    text.includes('luar negara') ||
    text.includes('hajj') ||
    text.includes('umrah')
  ) {
    return 'SPKN is used to manage overseas travel applications for Johor public officers. The guideline covers official travel, personal travel, hajj and umrah applications, supporting documents, department approval, and application submission through the SPKN system.'
  }

  if (
    text.includes('cos') ||
    text.includes('cfs') ||
    text.includes('contract') ||
    text.includes('kontrak') ||
    text.includes('sspa')
  ) {
    return 'The COS and CFS guideline explains the management of contract officers under Contract of Service and Contract for Service in Johor public service. It includes contract officer categories, salary adjustment, appointment management, and implementation under SSPA.'
  }

  if (
    text.includes('discipline') ||
    text.includes('tatatertib') ||
    text.includes('disciplinary') ||
    text.includes('promotion and discipline')
  ) {
    return 'The promotion and discipline reference document is related to guidelines under the promotion and disciplinary section. It helps users refer to information connected with promotion matters and disciplinary procedures. Since the document is scanned, full detailed text may require OCR before the system can search every part accurately.'
  }

  return 'I can help with document-related questions about TASKA subsidy, TBK promotion, SPKN overseas travel, COS/CFS contract service, and promotion or discipline references. Please choose one of the suggested questions or type a related HR policy question.'
}

function findDocumentAnswer(categoryName) {
  const matchedDocs = documents.value.filter((doc) => doc.category === categoryName)

  if (matchedDocs.length === 0) {
    return `I could not find a document under ${categoryName} yet. Please check the document repository or ask an administrator to upload it.`
  }

  const docList = matchedDocs
    .map((doc) => `${doc.title} (${doc.referenceNo})`)
    .join(', ')

  return `I found ${matchedDocs.length} related document(s) under ${categoryName}: ${docList}. You can open the Public Portal or Document Repository to view the details.`
}

async function saveDocument(doc) {
  const alreadySaved = savedDocuments.value.some((item) => item.documentId === doc.documentId)

  if (alreadySaved) {
    toast.value = language.value === 'ms'
      ? 'Dokumen ini sudah disimpan dalam koleksi peribadi.'
      : 'This document is already saved in your personal collection.'
    return
  }

  try {
    const response = await fetch(`${API_BASE_URL}/api/saved-documents`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        userId: currentUserId,
        documentId: doc.documentId
      })
    })

    if (!response.ok) {
      throw new Error('Failed to save document')
    }

    await loadSavedDocuments()

    if (!savedDocuments.value.some((item) => item.documentId === doc.documentId)) {
      addDocumentToLocalSavedList(doc)
    }

    toast.value = language.value === 'ms'
      ? `${doc.title} telah disimpan dalam koleksi peribadi.`
      : `${doc.title} saved to personal collection.`
  } catch (error) {
    console.error(error)
    addDocumentToLocalSavedList(doc)
    toast.value = language.value === 'ms'
      ? `${doc.title} disimpan secara tempatan untuk prototaip.`
      : `${doc.title} saved locally for prototype demo.`
  }

  addLog('Saved favourite document', 'Saved Documents', 'Success', session.value)
}

async function saveSearchResultDocument(doc) {
  const alreadySaved = savedDocuments.value.some((item) => item.documentId === doc.documentId)

  if (alreadySaved) {
    toast.value = language.value === 'ms'
      ? 'Dokumen ini sudah disimpan dalam koleksi peribadi.'
      : 'This document is already saved in your personal collection.'
    return
  }

  try {
    const response = await fetch(`${API_BASE_URL}/api/saved-documents`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        userId: currentUserId,
        documentId: doc.documentId
      })
    })

    if (!response.ok) {
      throw new Error('Failed to save document')
    }

    await loadSavedDocuments()

    if (!savedDocuments.value.some((item) => item.documentId === doc.documentId)) {
      addDocumentToLocalSavedList(doc)
    }

    toast.value = language.value === 'ms'
      ? `${doc.title} telah disimpan dalam koleksi peribadi.`
      : `${doc.title} saved to personal collection.`
  } catch (error) {
    console.error(error)

    addDocumentToLocalSavedList(doc)

    toast.value = language.value === 'ms'
      ? `${doc.title} disimpan secara tempatan untuk prototaip.`
      : `${doc.title} saved locally for prototype demo.`
  }

  addLog('Saved document from smart search result', 'Smart Search', 'Success', session.value)
}

function addDocumentToLocalSavedList(doc) {
  const savedItem = {
    savedId: Date.now(),
    documentId: doc.documentId,
    title: doc.title,
    category: doc.category || 'General',
    type: doc.type || 'Document',
    summary: doc.summary || '',
    updated: doc.updated || doc.effectiveDate || new Date().toISOString(),
    noteId: null,
    note: ''
  }

  savedDocuments.value = [savedItem, ...savedDocuments.value]
  persistLocalSavedDocuments()
}

function persistLocalSavedDocuments() {
  try {
    localStorage.setItem(`jhr_saved_documents_${currentUserId}`, JSON.stringify(savedDocuments.value))
  } catch (error) {
    console.warn('Failed to save local saved documents.', error)
  }
}

async function removeSavedDocument(savedId) {
  const originalDocuments = [...savedDocuments.value]
  savedDocuments.value = savedDocuments.value.filter((item) => item.savedId !== savedId)
  persistLocalSavedDocuments()

  try {
    const response = await fetch(`${API_BASE_URL}/api/saved-documents/${savedId}`, {
      method: 'DELETE'
    })

    if (!response.ok) {
      throw new Error('Failed to remove saved document')
    }

    await loadSavedDocuments()
  } catch (error) {
    console.error(error)
    savedDocuments.value = originalDocuments.filter((item) => item.savedId !== savedId)
    persistLocalSavedDocuments()
  }

  toast.value = language.value === 'ms'
    ? 'Dokumen disimpan telah dibuang.'
    : 'Saved document removed.'

  addLog('Removed favourite document', 'Saved Documents', 'Success', session.value)
}

function openNoteEditor(item) {
  noteForm.value = {
    savedId: item.savedId,
    documentId: item.documentId,
    title: item.title,
    noteContent: item.note || ''
  }
}

async function savePersonalNote() {
  if (!noteForm.value.documentId) {
    toast.value = 'Please select a saved document first.'
    return
  }

  if (!noteForm.value.noteContent.trim()) {
    toast.value = 'Please enter a note before saving.'
    return
  }

  try {
    const response = await fetch(`${API_BASE_URL}/api/personal-notes`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        userId: currentUserId,
        documentId: noteForm.value.documentId,
        noteContent: noteForm.value.noteContent
      })
    })

    if (!response.ok) {
      throw new Error('Failed to save personal note')
    }

    await loadSavedDocuments()

    noteForm.value = {
      savedId: null,
      documentId: null,
      title: '',
      noteContent: ''
    }

    toast.value = 'Personal note saved.'
    addLog('Saved personal note', 'Personal Notes', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to save personal note.'
  }
}

async function deletePersonalNote(item) {
  if (!item.noteId) {
    toast.value = 'This document has no note to delete.'
    return
  }

  try {
    const response = await fetch(`${API_BASE_URL}/api/personal-notes/${item.noteId}`, {
      method: 'DELETE'
    })

    if (!response.ok) {
      throw new Error('Failed to delete personal note')
    }

    await loadSavedDocuments()

    toast.value = 'Personal note deleted.'
    addLog('Deleted personal note', 'Personal Notes', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to delete personal note.'
  }
}

function cancelNoteEditor() {
  noteForm.value = {
    savedId: null,
    documentId: null,
    title: '',
    noteContent: ''
  }
}

async function markAllNotificationsRead() {
  try {
    const response = await fetch(
      `${API_BASE_URL}/api/notifications/read-all/${currentUserId}`,
      {
        method: 'PATCH'
      }
    )

    if (!response.ok) {
      throw new Error('Failed to mark all notifications as read')
    }

    await loadNotifications()

    toast.value = 'All notifications marked as read.'
    addLog('Marked notifications as read', 'Notifications', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to mark notifications as read.'
  }
}

async function markNotificationRead(notificationId) {
  try {
    const response = await fetch(
      `${API_BASE_URL}/api/notifications/${notificationId}/read`,
      {
        method: 'PATCH'
      }
    )

    if (!response.ok) {
      throw new Error('Failed to mark notification as read')
    }

    await loadNotifications()

    toast.value = 'Notification marked as read.'
    addLog('Marked notification as read', 'Notifications', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to mark notification as read.'
  }
}

function cycleNotificationFrequency() {
  if (notificationFrequency.value === 'Instant') {
    notificationFrequency.value = 'Daily'
  } else if (notificationFrequency.value === 'Daily') {
    notificationFrequency.value = 'Weekly'
  } else {
    notificationFrequency.value = 'Instant'
  }

  toast.value = `Notification frequency changed to ${notificationFrequency.value}. Click Save Preferences to update database.`
}

async function saveNotificationPreferences() {
  try {
    const response = await fetch(
      `${API_BASE_URL}/api/notification-preferences/${currentUserId}`,
      {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          policyUpdateEnabled: policyUpdateEnabled.value,
          savedUpdateEnabled: savedUpdateEnabled.value,
          notificationFrequency: notificationFrequency.value,
          deliveryChannel: deliveryChannel.value
        })
      }
    )

    if (!response.ok) {
      throw new Error('Failed to save notification preferences')
    }

    toast.value = 'Notification preferences updated.'
    addLog('Updated notification preferences', 'Notifications', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to save notification preferences.'
  }
}

async function submitUserFeedback() {
  if (!feedbackForm.value.feedbackContent.trim()) {
    toast.value = 'Please enter your feedback before submitting.'
    return
  }

  try {
    const response = await fetch(`${API_BASE_URL}/api/user-feedback`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        userId: currentUserId,
        feedbackCategory: feedbackForm.value.feedbackCategory,
        feedbackContent: feedbackForm.value.feedbackContent
      })
    })

    if (!response.ok) {
      throw new Error('Failed to submit feedback')
    }

    feedbackForm.value = {
      feedbackCategory: 'System Issue',
      feedbackContent: ''
    }

    toast.value = 'Feedback submitted successfully.'
    addLog('Submitted user feedback', 'User Feedback', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to submit feedback.'
  }
}

function toggleUserStatus(user) {
  user.updated_at = getCurrentDateTime()

  if (user.status === 'Active') {
    user.status = 'Suspended'
    toast.value = `${user.name} account suspended.`
    addLog('Suspended user account', 'User Management', 'Warning', 'Administrator')
  } else {
    user.status = 'Active'
    toast.value = `${user.name} account reactivated.`
    addLog('Reactivated user account', 'User Management', 'Success', 'Administrator')
  }
}
function openCreateRoleForm() {
  editingRoleIndex.value = null

  roleForm.value = {
    name: '',
    description: '',
    permissions: ''
  }

  roleModalOpen.value = true
}

function openEditRoleForm(role, index) {
  editingRoleIndex.value = index

  roleForm.value = {
    name: role.name,
    description: role.description,
    permissions: role.permissions.join(', ')
  }

  roleModalOpen.value = true
}

function saveRole() {
  const roleName = roleForm.value.name.trim()
  const roleDescription = roleForm.value.description.trim()
  const permissions = roleForm.value.permissions
    .split(',')
    .map((permission) => permission.trim())
    .filter(Boolean)

  if (!roleName || !roleDescription || permissions.length === 0) {
    toast.value = 'Please enter role name, description and at least one permission.'
    return
  }

  const duplicateRole = roles.value.some((role, index) => {
    return role.name.toLowerCase() === roleName.toLowerCase() &&
      index !== editingRoleIndex.value
  })

  if (duplicateRole) {
    toast.value = `${roleName} role already exists.`
    return
  }

  const roleData = {
    name: roleName,
    description: roleDescription,
    permissions
  }

  if (editingRoleIndex.value === null) {
    roles.value.push(roleData)
    toast.value = `${roleName} role created successfully.`
    addLog('Created new user role', 'Role Management', 'Success', 'Administrator')
  } else {
    roles.value[editingRoleIndex.value] = roleData
    toast.value = `${roleName} role updated successfully.`
    addLog('Edited user role', 'Role Management', 'Success', 'Administrator')
  }

  cancelRoleForm()
}

function cancelRoleForm() {
  roleModalOpen.value = false
  editingRoleIndex.value = null

  roleForm.value = {
    name: '',
    description: '',
    permissions: ''
  }
}

function filterLogs() {
  logs.value = logs.value.filter((log) => log.result === 'Success')
  toast.value = 'Showing success logs only.'
}
</script>