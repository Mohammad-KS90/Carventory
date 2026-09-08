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
    let username: String
    let email: String
    let phone: String?
    let fullName: String?
    let isActive: Bool

    // MARK: - Role & Access

    let role: UserRole
    let status: String?
    let accountType: AccountType?

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

    // MARK: - Other

    let isPublic: Bool
    let countryCode: String?

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {

        case id

        // Identity
        case username
        case email
        case phone

        case fullName = "full_name"
        case isActive = "is_active"

        // Role & Access
        case role
        case status

        case accountType = "account_type"

        // Ownership
        case companyId = "company_id"
        case branchId = "branch_id"
        case vehicleId = "vehicle_id"
        case createdBy = "created_by"

        // Metadata
        case metadata

        // Timestamps
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case lastLogin = "last_login"

        // Other
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
