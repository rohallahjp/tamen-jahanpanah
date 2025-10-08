

import React, { useState, useMemo, lazy, Suspense } from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';

// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
import Header from './src/components/Header.tsx';
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
import Sidebar from './src/components/Sidebar.tsx';
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
import PageLoader from './src/components/PageLoader.tsx';
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
import ProtectedRoute from './src/components/ProtectedRoute.tsx';
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
import { useAuth } from './src/hooks/useAuth.ts';
// FIX: Added imports for personsApi, requestCategoriesApi, and internalWorkflowsApi
import { unitsApi, rolesApi, diagnosticsApi, personsApi, requestCategoriesApi, internalWorkflowsApi } from './src/services/api.ts';
// FIX: Added imports for Person, RequestCategory, and InternalWorkflow types
import { Unit, Role, Person, RequestCategory, InternalWorkflow } from './src/types.ts';
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
import { ServerStatusContext, ServerStatus, useServerStatus } from './src/context/ServerStatusContext.tsx';
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
import { MainLayoutContext, MainLayoutContextType } from './src/context/MainLayoutContext.tsx';
// FIX: Added import for OfflineAiAssistant
import OfflineAiAssistant from './src/components/OfflineAiAssistant.tsx';

// Lazy load page components for code splitting
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const WelcomePage = lazy(() => import('./src/components/WelcomePage.tsx'));
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const DashboardPage = lazy(() => import('./src/features/Dashboard/DashboardPage.tsx'));
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const ReportsPage = lazy(() => import('./src/features/Reports/ReportsPage.tsx'));
// FIX: React.lazy requires the imported module to have a `default` export.
// The module for `UnitsPage` appears to use a named export, so we are
// wrapping the import to create a `default` property on the fly.
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const UnitsPage = lazy(() => import('./src/features/Units/UnitsPage.tsx'));
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const PersonsPage = lazy(() => import('./src/features/Persons/PersonsPage.tsx'));
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const BeneficiariesPage = lazy(() => import('./src/features/Beneficiaries/BeneficiariesPage.tsx'));
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const ProjectsPage = lazy(() => import('./src/features/Projects/ProjectsPage.tsx'));
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const RequestTypesPage = lazy(() => import('./src/features/RequestTypes/RequestTypesPage.tsx'));
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const ChangePasswordPage = lazy(() => import('./src/features/Profile/ChangePasswordPage.tsx'));
// FIX: Corrected the dynamic import for `WorkflowPage` to ensure it has a default export for React.lazy.
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const WorkflowPage = lazy(() => import('./src/features/Workflow/WorkflowPage.tsx'));
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const InternalWorkflowPage = lazy(() => import('./src/features/InternalWorkflow/InternalWorkflowPage.tsx'));
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const RolesPage = lazy(() => import('./src/features/Roles/RolesPage.tsx'));
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const SecurityPage = lazy(() => import('./src/features/Security/SecurityPage.tsx'));
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const AppearancePage = lazy(() => import('./src/features/Appearance/AppearancePage.tsx'));
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const PettyCashPage = lazy(() => import('./src/features/PettyCash/PettyCashPage.tsx'));
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const PettyCashManagementPage = lazy(() => import('./src/features/PettyCash/PettyCashManagementPage.tsx'));
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const ContractsPage = lazy(() => import('./src/features/Contracts/ContractsPage.tsx'));
// FIX: Added lazy import for DebitPage
const DebitPage = lazy(() => import('./src/features/Debit/DebitPage.tsx'));
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const LoginPage = lazy(() => import('./src/pages/LoginPage.tsx'));
// FIX: Corrected import paths to be relative to the project root, pointing into the 'src' directory.
const BackupRecoveryPage = lazy(() => import('./src/features/BackupRecovery/BackupRecoveryPage.tsx'));

const MainLayout: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { currentUser } = useAuth();
  const [isSidebarVisible, setIsSidebarVisible] = useState(true);
  const { status: serverStatus } = useServerStatus();

  return (
      <div className="flex h-screen overflow-hidden bg-gray-100 border-t-4 border-fuchsia-700">
        <Sidebar
          isSidebarVisible={isSidebarVisible}
          onHide={() => setIsSidebarVisible(false)}
        />
        <div
          className="flex-1 flex flex-col overflow-hidden transition-margin duration-300 ease-in-out"
          style={{ marginRight: isSidebarVisible ? '256px' : '0' }}
        >
          <Header
            onShowSidebar={() => setIsSidebarVisible(!isSidebarVisible)}
            userFullName={currentUser?.fullName}
            userPosition={currentUser?.position}
            serverStatus={serverStatus}
          />
          <main className="flex-grow p-4 sm:p-6 lg:p-8 overflow-y-auto">
            <Suspense fallback={<PageLoader />}>
                {children}
            </Suspense>
          </main>
        </div>
        {/* FIX: Added OfflineAiAssistant component to the layout */}
        <OfflineAiAssistant />
      </div>
  );
};

const App: React.FC = () => {
  const { isAuthenticated } = useAuth();

  const { status: queryStatus, isFetching } = useQuery({
      queryKey: ['serverHealth'],
      queryFn: diagnosticsApi.healthCheck,
      refetchOnWindowFocus: true,
      retry: 1,
      staleTime: 0,
      gcTime: 15000,
  });

  const serverStatus = useMemo<ServerStatus>(() => {
      if (queryStatus === 'error') return 'offline';
      if (isFetching) return 'checking';
      if (queryStatus === 'success') return 'online';
      return 'checking';
  }, [queryStatus, isFetching]);
  
  const serverStatusContextValue = useMemo(() => ({ status: serverStatus }), [serverStatus]);
  
  // Data fetching for MainLayoutContext is now done at the App level
  const { data: units, isLoading: unitsLoading } = useQuery<Unit[]>({
    queryKey: ['units_all'],
    queryFn: () => unitsApi.getAllUnpaginated(),
    enabled: serverStatus === 'online' && isAuthenticated,
  });
  const { data: roles, isLoading: rolesLoading } = useQuery<Role[]>({
    queryKey: ['roles_all'],
    queryFn: () => rolesApi.getAllUnpaginated(),
    enabled: serverStatus === 'online' && isAuthenticated,
  });
  // FIX: Added data fetching for persons, requestCategories, and internalWorkflows
  const { data: persons, isLoading: personsLoading } = useQuery<Person[]>({
    queryKey: ['persons_all'],
    queryFn: () => personsApi.getAllUnpaginated(),
    enabled: serverStatus === 'online' && isAuthenticated,
  });
  const { data: requestCategories, isLoading: categoriesLoading } = useQuery<RequestCategory[]>({
    queryKey: ['requestCategories_all'],
    queryFn: () => requestCategoriesApi.getAllUnpaginated(),
    enabled: serverStatus === 'online' && isAuthenticated,
  });
  const { data: internalWorkflows, isLoading: internalWorkflowsLoading } = useQuery<InternalWorkflow[]>({
    queryKey: ['internalWorkflows_all'],
    queryFn: () => internalWorkflowsApi.getAllUnpaginated(),
    enabled: serverStatus === 'online' && isAuthenticated,
  });

  // FIX: Updated isLoading to include new data fetching states
  const isLoading = unitsLoading || rolesLoading || personsLoading || categoriesLoading || internalWorkflowsLoading;
  
  // FIX: Updated mainLayoutContextValue to provide all required properties to the context.
  const mainLayoutContextValue = useMemo<MainLayoutContextType>(() => ({
    units: units || [],
    roles: roles || [],
    persons: persons || [],
    requestCategories: requestCategories || [],
    internalWorkflows: internalWorkflows || [],
    isLoading,
  }), [units, roles, persons, requestCategories, internalWorkflows, isLoading]);

  return (
    <ServerStatusContext.Provider value={serverStatusContextValue}>
      <MainLayoutContext.Provider value={mainLayoutContextValue}>
        <Suspense fallback={<PageLoader />}>
          <Routes>
            <Route path="/login" element={isAuthenticated ? <Navigate to="/dashboard" /> : <LoginPage />} />
            <Route path="/*" element={
              <ProtectedRoute>
                <MainLayout>
                  <Routes>
                      <Route path="/" element={<Navigate to="/dashboard" />} />
                      <Route path="/welcome" element={<WelcomePage />} />
                      <Route path="/dashboard" element={<DashboardPage />} />
                      <Route path="/reports" element={<ReportsPage />} />
                      <Route path="/my-petty-cash" element={<PettyCashPage />} />
                      <Route path="/contracts" element={<ContractsPage />} />
                      {/* FIX: Added DebitPage route */}
                      <Route path="/debit-cards" element={<DebitPage />} />
                      <Route path="/units" element={<UnitsPage />} />
                      <Route path="/persons" element={<PersonsPage />} />
                      <Route path="/beneficiaries" element={<BeneficiariesPage />} />
                      <Route path="/projects" element={<ProjectsPage />} />
                      <Route path="/request-types" element={<RequestTypesPage />} />
                      <Route path="/profile" element={<ChangePasswordPage />} />
                      <Route path="/workflow" element={<WorkflowPage />} />
                      <Route
                        path="/internal-workflows"
                        element={<InternalWorkflowPage />}
                      />
                      <Route path="/roles" element={<RolesPage />} />
                      <Route path="/security" element={<SecurityPage />} />
                      <Route path="/appearance" element={<AppearancePage />} />
                      <Route path="/petty-cash-management" element={<PettyCashManagementPage />} />
                      <Route path="/backup-recovery" element={<BackupRecoveryPage />} />
                      <Route path="*" element={<Navigate to="/dashboard" />} />
                    </Routes>
                </MainLayout>
              </ProtectedRoute>
            } />
          </Routes>
        </Suspense>
      </MainLayoutContext.Provider>
    </ServerStatusContext.Provider>
  );
};

export default App;
