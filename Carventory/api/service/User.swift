//
//  User.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 06/01/2026.
//
import Foundation

struct User: Codable, Identifiable {

    // MARK: - Identity

    let id: String

    let username: String?
    let email: String?
    let phone: String?
    let fullName: String?
    let isActive: Bool?

    // MARK: - Role & Access

    let role: UserRole?
    let status: String?
    let accountType: AccountType?
    let permissions: [String]?

    // MARK: - Ownership / Hierarchy

    let companyId: String?
    let branchId: String?
    let vehicleId: String?
    let createdBy: String?
    // MARK: - Metadata

    let metadata: [String: AnyCodable]?

    // MARK: - Timestamps

    let createdAt: Date?
    let updatedAt: Date?
    let lastLogin: Date?

    // MARK: - Vehicle

    let assignedVehicle: String?

    // MARK: - Other

    let isPublic: Bool?
    let countryCode: String?

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case phone
        case fullName = "full_name"
        case isActive = "is_active"
        case role
        case status
        case accountType = "account_type"
        case permissions
        
        case companyId = "company_id"
        case branchId = "branch_id"
        case vehicleId = "vehicle_id"
        case createdBy = "created_by"

        case metadata

        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case lastLogin = "last_login"

        case assignedVehicle = "assigned_vehicle"

        case isPublic = "is_public"
        case countryCode = "country_code"
    }
}


enum AccountType: String, Codable {
    case individual = "individual"
    case company = "company"
    case system = "system"
}

enum UserRole: String, Codable {
    case owner = "Owner"
    case admin = "Admin"

    case systemCOO = "SystemCOO"
    case systemCFO = "SystemCFO"
    case systemCTO = "SystemCTO"
    case systemAdmin = "SystemAdmin"

    case vehicleOwner = "VehicleOwner"

    case serviceCenterOwner = "ServiceCenterOwner"
    case serviceCenterAdmin = "ServiceCenterAdmin"
    case serviceCenterStaff = "ServiceCenterStaff"

    case posOwner = "POSOwner"
    case posAdmin = "POSAdmin"

    case truckDriver = "TruckDriver"
}


//Owner = "Owner" # will create the first user as admin, SystemCOO, SystemCFO, SystemCTO
//Admin = "Admin" # will create System admin
//
//# C level roles
//SystemCOO = "SystemCOO"
//SystemCFO = "SystemCFO"
//SystemCTO = "SystemCTO"
//# System roles
//SystemAdmin = "SystemAdmin" # will create SystemDeveloper, SystemQa, SystemProduct, SystemUIUX, SystemSales, SystemMarketing, SystemHR, SystemFinance, SystemSupport, SystemSupportB
//BusinessAdmin = "BusinessAdmin"
//
//SystemDeveloper = "SystemDeveloper"
//SystemQa = "SystemQa"
//SystemProduct = "SystemProduct"
//SystemInstall = "SystemInstall" # wil see only installation related tasks
//SystemUIUX = "SystemUIUX"
//SystemSales = "SystemSales" # will request deal,
//SystemMarketing = "SystemMarketing"
//SystemHR = "SystemHR"
//SystemFinance = "SystemFinance" # if done deal, will create OwnerPOS, TruckDriver, ServiceCenterOwner,
//
//SystemSupport = "SystemSupport"
//SystemSupportBBP = "SystemSupportBBP" # support POS
//SystemSupportBBS = "SystemSupportBBS" # support ServiceCenter
//SystemSupportBBT = "SystemSupportBBT" # support TruckDriver
//SystemSupportBBV = "SystemSupportBBV" # support VehicleOwner
//
//SystemSupportC = "SystemSupportC"
//
//# POS roles for auto part retail store management
//POSOwner = "POSOwner" # will create AdminPOS,
//POSAdmin = "POSAdmin" # will create SalesmanPOS, CashierPOS, InventoryManagerPOS, StorekeeperPOS, AccountantPOS, SupportPOS
//POSSalesman = "POSSalesman"
//POSCashier = "POSCashier"
//POSInventoryManager = "POSInventoryManager"
//POSStorekeeper = "POSStorekeeper"
//POSAccountant = "POSAccountant"
//
//# service center roles
//ServiceCenterOwner = "ServiceCenterOwner" # will create ServiceCenterAdmin, ServiceCenterStaff
//ServiceCenterAdmin = "ServiceCenterAdmin"
//ServiceCenterStaff = "ServiceCenterStaff"
//
//# truck driver role
//TruckDriver = "TruckDriver"
//
//# Warehouse roles inverntory management
//VehicleOwner = "VehicleOwner" # will create by own
enum AppDomain {
    case admin, owner, vehicleOwner, serviceCenter, pos, support, driver, system
}


enum DomainResolver {
    static func resolve(roles: [UserRole]) -> AppDomain {
        if roles.contains(.vehicleOwner) { return .vehicleOwner }
        if roles.contains(.owner) { return .owner }
        if roles.contains(.admin) { return .admin }
        if roles.contains(where: { $0.rawValue.hasPrefix("ServiceCenter") }) { return .serviceCenter }
        if roles.contains(where: { $0.rawValue.hasPrefix("POS") }) { return .pos }
        if roles.contains(where: { $0.rawValue.hasPrefix("SystemSupport") }) { return .support }
        if roles.contains(.truckDriver) { return .driver }
        return .system
    }
}
