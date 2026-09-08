//
//  README.md
//  Carventory
//
//  Created by Mohammad kh Suliman on 08/09/2026.
//

MyApp/
├── MyApp.swift                          # @main App entry point
├── App/
│   ├── AppDelegate.swift
│   ├── RootView.swift
│   └── DIContainer.swift
│
├── Core/
│   ├── Models/
│   │   ├── UserRole.swift
│   │   ├── RoleCreationMap.swift
│   │   └── User.swift
│   ├── Permissions/
│   │   ├── RoleManager.swift
│   │   └── PermissionModifier.swift
│   ├── Networking/
│   │   ├── APIClient.swift
│   │   └── Endpoints/
│   ├── Persistence/
│   │   ├── KeychainStore.swift
│   │   └── LocalCache.swift
│   └── Extensions/
│       ├── View+Extensions.swift
│       └── String+Extensions.swift
│
├── Authentication/
│   ├── Views/
│   │   ├── LoginView.swift
│   │   └── SessionExpiredView.swift
│   ├── ViewModels/
│   │   └── AuthViewModel.swift
│   └── SessionManager.swift
│
├── Shared/
│   ├── DesignSystem/
│   │   ├── Colors.swift
│   │   ├── Typography.swift
│   │   └── Spacing.swift
│   └── Components/
│       ├── RoleBadge.swift
│       ├── UserListRow.swift
│       ├── EmptyStateView.swift
│       └── LoadingView.swift
│
├── Features/
│   ├── Owner/
│   │   ├── Views/OwnerDashboardView.swift
│   │   └── ViewModels/OwnerDashboardViewModel.swift
│   │
│   ├── Admin/
│   │   ├── Views/AdminDashboardView.swift
│   │   └── ViewModels/AdminDashboardViewModel.swift
│   │
│   ├── BusinessAdmin/
│   │   ├── Views/BusinessAdminDashboardView.swift
│   │   └── ViewModels/BusinessAdminDashboardViewModel.swift
│   │
│   ├── SystemLeadership/                # SystemCOO, SystemCFO, SystemCTO, SystemHR, SystemFinance
│   │   ├── COO/Views/COODashboardView.swift
│   │   ├── CFO/Views/CFODashboardView.swift
│   │   ├── CTO/Views/CTODashboardView.swift
│   │   ├── HR/Views/HRDashboardView.swift
│   │   └── Finance/
│   │       ├── Views/FinanceDashboardView.swift
│   │       └── Views/ApprovalRequestsView.swift   # approvals for install-related roles
│   │
│   ├── SystemAdmin/
│   │   ├── Views/SystemAdminDashboardView.swift
│   │   ├── Product/Views/ProductDashboardView.swift
│   │   ├── Support/
│   │   │   ├── Views/SupportDashboardView.swift
│   │   │   ├── BBP/Views/BBPView.swift
│   │   │   ├── BBS/Views/BBSView.swift
│   │   │   ├── BBT/Views/BBTView.swift
│   │   │   └── BBV/Views/BBVView.swift
│   │   ├── UIUX/Views/UIUXDashboardView.swift
│   │   ├── Developer/Views/DeveloperDashboardView.swift
│   │   └── QA/Views/QADashboardView.swift
│   │
│   ├── SystemInstall/
│   │   ├── Views/SystemInstallDashboardView.swift
│   │   ├── ServiceCenter/
│   │   │   ├── Owner/Views/ServiceCenterOwnerView.swift
│   │   │   ├── Admin/Views/ServiceCenterAdminView.swift
│   │   │   └── Staff/Views/ServiceCenterStaffView.swift
│   │   ├── POS/
│   │   │   ├── Owner/Views/POSOwnerView.swift
│   │   │   ├── Admin/Views/POSAdminView.swift
│   │   │   ├── Salesman/Views/POSSalesmanView.swift
│   │   │   ├── Cashier/Views/POSCashierView.swift
│   │   │   ├── Storekeeper/Views/POSStorekeeperView.swift
│   │   │   └── Accountant/Views/POSAccountantView.swift
│   │   ├── TruckDriver/Views/TruckDriverView.swift
│   │   └── VehicleOwner/Views/VehicleOwnerView.swift
│   │
│   └── UserManagement/                  # cross-cutting "create user" flows
│       ├── Views/CreateUserView.swift
│       ├── Views/UserListView.swift
│       └── ViewModels/UserManagementViewModel.swift
│
├── Resources/
│   ├── Assets.xcassets
│   └── Localizable.strings
│
└── Tests/
    ├── RoleManagerTests.swift
    └── RoleCreationMapTests.swift
