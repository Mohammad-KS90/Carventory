//
//  VODashboard.swift
//  Carventory
//
//  Created by Mohammad kh Suliman on 06/01/2026.
//

import SwiftUI
import MapKit

struct VehicleOwnerDashboardView: View {
    @EnvironmentObject var appState: AppState
    struct PlaceCategory {
        let key: String                        // Internal identifier
        let displayName: [String: String]      // Localized names by language code
        let mapTypes: [String: String]         // Map provider category mapping
    }

    let allCategories: [PlaceCategory] = [
        // Cars & Travel
        PlaceCategory(
            key: "car_service",
            displayName: ["en":"Car Service",
                          "ar":"خدمة سيارات",
                          "fr":"Service automobile",
                          "zh":"汽车服务",
                          "ja":"カーサービス",
                          "ko":"자동차 서비스",
                          "id":"Layanan Mobil",
                          "th":"บริการรถยนต์",
                          "vi":"Dịch vụ ô tô",
                          "hi":"कार सेवा"],
            mapTypes: ["google":"car_repair",
                       "amap":"汽车维修",
                       "osm":"car_repair"]
        ),
        PlaceCategory(
            key: "car_parts",
            displayName: ["en":"Car Parts",
                          "ar":"قطع غيار سيارات",
                          "fr":"Pièces de voiture",
                          "zh":"汽车零件",
                          "ja":"自動車部品",
                          "ko":"자동차 부품",
                          "id":"Suku Cadang Mobil",
                          "th":"ชิ้นส่วนรถยนต์",
                          "vi":"Phụ tùng ô tô",
                          "hi":"कार के पुर्जे"],
            mapTypes: ["google":"car_parts",
                       "amap":"汽车零件",
                       "osm":"car_parts"]
        ),
        PlaceCategory(
            key: "gas_station",
            displayName: ["en":"Gas Station",
                          "ar":"محطة وقود",
                          "fr":"Station-service",
                          "zh":"加油站",
                          "ja":"ガソリンスタンド",
                          "ko":"주유소",
                          "id":"Pom Bensin",
                          "th":"ปั๊มน้ำมัน",
                          "vi":"Trạm xăng",
                          "hi":"पेट्रोल पंप"],
            mapTypes: ["google":"gas_station",
                       "amap":"加油站",
                       "osm":"fuel"]
        ),

        // Food & Drink
        PlaceCategory(
            key: "restaurant",
            displayName: ["en":"Restaurant",
                          "ar":"مطعم",
                          "fr":"Restaurant",
                          "zh":"餐馆",
                          "ja":"レストラン",
                          "ko":"레스토랑",
                          "id":"Restoran",
                          "th":"ร้านอาหาร",
                          "vi":"Nhà hàng",
                          "hi":"रेस्तरां"],
            mapTypes: ["google":"restaurant",
                       "amap":"餐厅",
                       "osm":"restaurant"]
        ),
        PlaceCategory(
            key: "cafe",
            displayName: ["en":"Cafe",
                          "ar":"مقهى",
                          "fr":"Café",
                          "zh":"咖啡馆",
                          "ja":"カフェ",
                          "ko":"카페",
                          "id":"Kafe",
                          "th":"ร้านกาแฟ",
                          "vi":"Quán cà phê",
                          "hi":"कैफ़े"],
            mapTypes: ["google":"cafe",
                       "amap":"咖啡馆",
                       "osm":"cafe"]
        ),
        PlaceCategory(
            key: "bakery",
            displayName: ["en":"Bakery",
                          "ar":"مخبز",
                          "fr":"Boulangerie",
                          "zh":"面包店",
                          "ja":"ベーカリー",
                          "ko":"베이커리",
                          "id":"Toko roti",
                          "th":"ร้านขนมปัง",
                          "vi":"Tiệm bánh",
                          "hi":"बेकरी"],
            mapTypes: ["google":"bakery",
                       "amap":"面包店",
                       "osm":"bakery"]
        ),
//        PlaceCategory(
//            key: "bar",
//            displayName: ["en":"Bar","ar":"بار","fr":"Bar","zh":"酒吧","ja":"バー","ko":"바","id":"Bar","th":"บาร์","vi":"Quán bar","hi":"बार"],
//            mapTypes: ["google":"bar","amap":"酒吧","osm":"bar"]
//        ),

        // Hotels & Stay
        PlaceCategory(
            key: "hotel",
            displayName: ["en":"Hotel",
                          "ar":"فندق",
                          "fr":"Hôtel",
                          "zh":"酒店",
                          "ja":"ホテル",
                          "ko":"호텔",
                          "id":"Hotel",
                          "th":"โรงแรม",
                          "vi":"Khách sạn",
                          "hi":"होटल"],
            mapTypes: ["google":"lodging",
                       "amap":"酒店",
                       "osm":"hotel"]
        ),
        PlaceCategory(
            key: "hostel",
            displayName: ["en":"Hostel",
                          "ar":"نُزُل",
                          "fr":"Auberge",
                          "zh":"旅社",
                          "ja":"ホステル",
                          "ko":"호스텔",
                          "id":"Hostel",
                          "th":"โฮสเทล",
                          "vi":"Nhà nghỉ",
                          "hi":"छोटा होस्टल"],
            mapTypes: ["google":"lodging",
                       "amap":"旅社",
                       "osm":"hostel"]
        ),
        PlaceCategory(
            key: "resort",
            displayName: ["en":"Resort",
                          "ar":"منتجع",
                          "fr":"Station balnéaire",
                          "zh":"度假村",
                          "ja":"リゾート",
                          "ko":"리조트",
                          "id":"Resor",
                          "th":"รีสอร์ท",
                          "vi":"Khu nghỉ dưỡng",
                          "hi":"रिसॉर्ट"],
            mapTypes: ["google":"lodging",
                       "amap":"度假村",
                       "osm":"resort"]
        ),

        // Entertainment
        PlaceCategory(
            key: "cinema",
            displayName: ["en":"Cinema",
                          "ar":"سينما",
                          "fr":"Cinéma",
                          "zh":"电影院",
                          "ja":"映画館",
                          "ko":"영화관",
                          "id":"Bioskop",
                          "th":"โรงภาพยนตร์",
                          "vi":"Rạp chiếu phim",
                          "hi":"सिनेमा"],
            mapTypes: ["google":"movie_theater",
                       "amap":"电影院",
                       "osm":"cinema"]
        ),
        PlaceCategory(
            key: "amusement_park",
            displayName: ["en":"Amusement Park",
                          "ar":"مدينة ملاهي",
                          "fr":"Parc d'attractions",
                          "zh":"游乐园",
                          "ja":"遊園地",
                          "ko":"놀이공원",
                          "id":"Taman Hiburan",
                          "th":"สวนสนุก",
                          "vi":"Công viên giải trí",
                          "hi":"मनोरंजन पार्क"],
            mapTypes: ["google":"amusement_park",
                       "amap":"游乐园",
                       "osm":"amusement_park"]
        ),
        PlaceCategory(
            key: "zoo",
            displayName: ["en":"Zoo",
                          "ar":"حديقة الحيوان",
                          "fr":"Zoo",
                          "zh":"动物园",
                          "ja":"動物園",
                          "ko":"동물원",
                          "id":"Kebun Binatang",
                          "th":"สวนสัตว์",
                          "vi":"Sở thú",
                          "hi":"चिड़ियाघर"],
            mapTypes: ["google":"zoo",
                       "amap":"动物园",
                       "osm":"zoo"]
        ),
        PlaceCategory(
            key: "museum",
            displayName: ["en":"Museum",
                          "ar":"متحف",
                          "fr":"Musée",
                          "zh":"博物馆",
                          "ja":"博物館",
                          "ko":"박물관",
                          "id":"Museum",
                          "th":"พิพิธภัณฑ์",
                          "vi":"Bảo tàng",
                          "hi":"संग्रहालय"],
            mapTypes: ["google":"museum",
                       "amap":"博物馆",
                       "osm":"museum"]
        ),

        // Outdoors & Nature
        PlaceCategory(
            key: "park",
            displayName: ["en":"Park",
                          "ar":"منتزه",
                          "fr":"Parc",
                          "zh":"公园",
                          "ja":"公園",
                          "ko":"공원",
                          "id":"Taman",
                          "th":"สวนสาธารณะ",
                          "vi":"Công viên",
                          "hi":"पार्क"],
            mapTypes: ["google":"park",
                       "amap":"公园",
                       "osm":"park"]
        ),
        PlaceCategory(
            key: "beach",
            displayName: ["en":"Beach",
                          "ar":"شاطئ",
                          "fr":"Plage",
                          "zh":"海滩",
                          "ja":"ビーチ",
                          "ko":"해변",
                          "id":"Pantai",
                          "th":"ชายหาด",
                          "vi":"Bãi biển",
                          "hi":"समुद्र तट"],
            mapTypes: ["google":"beach",
                       "amap":"海滩",
                       "osm":"beach"]
        ),
        PlaceCategory(
            key: "hiking",
            displayName: ["en":"Hiking",
                          "ar":"مشي",
                          "fr":"Randonnée",
                          "zh":"徒步",
                          "ja":"ハイキング",
                          "ko":"하이킹",
                          "id":"Mendaki",
                          "th":"เดินป่า",
                          "vi":"Đi bộ đường dài",
                          "hi":"पैदल यात्रा"],
            mapTypes: ["google":"hiking",
                       "amap":"徒步",
                       "osm":"hiking"]
        ),

        // Fitness & Sports
        PlaceCategory(
            key: "gym",
            displayName: ["en":"Gym",
                          "ar":"صالة رياضية",
                          "fr":"Salle de sport",
                          "zh":"健身房",
                          "ja":"ジム",
                          "ko":"헬스장",
                          "id":"Gym",
                          "th":"ยิม",
                          "vi":"Phòng tập",
                          "hi":"जिम"],
            mapTypes: ["google":"gym",
                       "amap":"健身房",
                       "osm":"gym"]
        ),
        PlaceCategory(
            key: "swimming_pool",
            displayName: ["en":"Swimming Pool",
                          "ar":"مسبح",
                          "fr":"Piscine",
                          "zh":"游泳池",
                          "ja":"プール",
                          "ko":"수영장",
                          "id":"Kolam Renang",
                          "th":"สระว่ายน้ำ",
                          "vi":"Bể bơi",
                          "hi":"तैराकी पूल"],
            mapTypes: ["google":"swimming_pool",
                       "amap":"游泳池",
                       "osm":"swimming_pool"]
        ),

        // Kids & Family
        PlaceCategory(
            key: "playground",
            displayName: ["en":"Playground",
                          "ar":"ملعب",
                          "fr":"Terrain de jeu",
                          "zh":"儿童游乐场",
                          "ja":"遊び場",
                          "ko":"놀이터",
                          "id":"Taman Bermain",
                          "th":"สนามเด็กเล่น",
                          "vi":"Sân chơi",
                          "hi":"खेल का मैदान"],
            mapTypes: ["google":"playground",
                       "amap":"儿童游乐场",
                       "osm":"playground"]
        ),
        PlaceCategory(
            key: "children_museum",
            displayName: ["en":"Children Museum",
                          "ar":"متحف الأطفال",
                          "fr":"Musée pour enfants",
                          "zh":"儿童博物馆",
                          "ja":"子供博物館",
                          "ko":"어린이 박물관",
                          "id":"Museum Anak",
                          "th":"พิพิธภัณฑ์เด็ก",
                          "vi":"Bảo tàng trẻ em",
                          "hi":"बाल संग्रहालय"],
            mapTypes: ["google":"museum",
                       "amap":"儿童博物馆",
                       "osm":"museum"]
        ),

        // Shopping
        PlaceCategory(
            key: "shopping_mall",
            displayName: ["en":"Shopping Mall",
                          "ar":"مركز تسوق",
                          "fr":"Centre commercial",
                          "zh":"购物中心",
                          "ja":"ショッピングモール",
                          "ko":"쇼핑몰",
                          "id":"Mal",
                          "th":"ห้างสรรพสินค้า",
                          "vi":"Trung tâm mua sắm",
                          "hi":"शॉपिंग मॉल"],
            mapTypes: ["google":"shopping_mall",
                       "amap":"购物中心",
                       "osm":"mall"]
        ),
        PlaceCategory(
            key: "supermarket",
            displayName: ["en":"Supermarket",
                          "ar":"سوبر ماركت",
                          "fr":"Supermarché",
                          "zh":"超市",
                          "ja":"スーパーマーケット",
                          "ko":"슈퍼마켓",
                          "id":"Supermarket",
                          "th":"ซูเปอร์มาร์เก็ต",
                          "vi":"Siêu thị",
                          "hi":"सुपरमार्केट"],
            mapTypes: ["google":"supermarket",
                       "amap":"超市",
                       "osm":"supermarket"]
        ),
        PlaceCategory(
            key: "clothing_store",
            displayName: ["en":"Clothing Store",
                          "ar":"متجر ملابس",
                          "fr":"Magasin de vêtements",
                          "zh":"服装店",
                          "ja":"服屋",
                          "ko":"의류점",
                          "id":"Toko Pakaian",
                          "th":"ร้านเสื้อผ้า",
                          "vi":"Cửa hàng quần áo",
                          "hi":"कपड़ों की दुकान"],
            mapTypes: ["google":"clothing_store",
                       "amap":"服装店",
                       "osm":"clothes"]
        ),

        // Health & Wellness
        PlaceCategory(
            key: "hospital",
            displayName: ["en":"Hospital",
                          "ar":"مستشفى",
                          "fr":"Hôpital",
                          "zh":"医院",
                          "ja":"病院",
                          "ko":"병원",
                          "id":"Rumah Sakit",
                          "th":"โรงพยาบาล",
                          "vi":"Bệnh viện",
                          "hi":"अस्पताल"],
            mapTypes: ["google":"hospital",
                       "amap":"医院",
                       "osm":"hospital"]
        ),
        PlaceCategory(
            key: "pharmacy",
            displayName: ["en":"Pharmacy",
                          "ar":"صيدلية",
                          "fr":"Pharmacie",
                          "zh":"药店",
                          "ja":"薬局",
                          "ko":"약국",
                          "id":"Apotek",
                          "th":"ร้านขายยา",
                          "vi":"Hiệu thuốc",
                          "hi":"फार्मेसी"],
            mapTypes: ["google":"pharmacy",
                       "amap":"药店",
                       "osm":"pharmacy"]
        )
    ]
    
    // MARK: - Language selection (default to English)
    private var languageCode: String { appState.languageCode }

    // MARK: - Body
    var body: some View {

        let vehicle = appState.vehicle!
        let user = appState.user!

        ScrollView {
            VStack(spacing: 24) {

                // MARK: - Dashboard Header
                dashboardHeader

                // MARK: - User Info
                infoCard(
                    title: "My Information",
                    icon: "person.crop.circle.fill",
                    tint: .blue
                ) {

                    infoRow(
                        title: "Full Name",
                        value: user.fullName ?? "-",
                        icon: "person.fill"
                    )

                    infoRow(
                        title: "Username",
                        value: user.username ?? "-",
                        icon: "at"
                    )

                    infoRow(
                        title: "Email",
                        value: user.email ?? "-",
                        icon: "envelope.fill"
                    )

                    infoRow(
                        title: "Phone",
                        value: user.phone ?? "-",
                        icon: "phone.fill"
                    )

                    infoRow(
                        title: "Role",
                        value: user.role?.rawValue ?? "-",
                        icon: "person.badge.key.fill"
                    )

                    infoRow(
                        title: "Status",
                        value: user.status ?? "-",
                        icon: "checkmark.circle.fill"
                    )

                    infoRow(
                        title: "Account Type",
                        value: "\(user.accountType)",
                        icon: "building.2.fill"
                    )
                }

                // MARK: - Vehicle
                infoCard(
                    title: "My Vehicle",
                    icon: "car.fill",
                    tint: .indigo
                ) {

                    // Vehicle summary
                    vehicleSummary(vehicle: vehicle)

                    Divider()
                        .padding(.vertical, 4)

                    // Vehicle information
                    infoRow(
                        title: "Make",
                        value: vehicle.make,
                        icon: "car.fill"
                    )

                    infoRow(
                        title: "Model",
                        value: vehicle.model,
                        icon: "rectangle.fill"
                    )

                    infoRow(
                        title: "Year",
                        value: String(vehicle.year),
                        icon: "calendar"
                    )

                    infoRow(
                        title: "Type",
                        value: vehicle.vehicleType,
                        icon: "car.side.fill"
                    )

                    infoRow(
                        title: "Fuel Type",
                        value: vehicle.fuelType,
                        icon: "fuelpump.fill"
                    )

                    infoRow(
                        title: "Engine",
                        value: vehicle.engine,
                        icon: "engine.combustion.fill"
                    )

                    infoRow(
                        title: "Transmission",
                        value: vehicle.transmission.isEmpty
                            ? "-"
                            : vehicle.transmission,
                        icon: "gearshape.fill"
                    )

                    // VIN
                    vinView(vin: vehicle.vin)
                }

                // MARK: - Suggestions
                suggestionsSection

                // MARK: - Nearby Service
                nearbyServiceButton

                Spacer(minLength: 20)
            }
            .frame(maxWidth: 900)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Dashboard Header
    private var dashboardHeader: some View {

        VStack(spacing: 8) {

            Image(systemName: "car.circle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.blue)

            Text("Dashboard")
                .font(.system(size: 34, weight: .bold))

            Text("Manage your vehicle and discover nearby services")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 20)
        .padding(.bottom, 8)
    }

    // MARK: - Reusable Card
    @ViewBuilder
    private func infoCard<Content: View>(
        title: String,
        icon: String,
        tint: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {

        VStack(alignment: .leading, spacing: 18) {

            // Card Header
            HStack(spacing: 12) {

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(tint)
                    .frame(width: 42, height: 42)
                    .background(
                        tint.opacity(0.12),
                        in: RoundedRectangle(
                            cornerRadius: 12,
                            style: .continuous
                        )
                    )

                Text(title)
                    .font(.title3.weight(.bold))

                Spacer()
            }

            Divider()

            content()
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
            .fill(.regularMaterial)
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
            .strokeBorder(
                Color.primary.opacity(0.07),
                lineWidth: 1
            )
        }
        .shadow(
            color: Color.black.opacity(0.07),
            radius: 16,
            x: 0,
            y: 8
        )
    }

    // MARK: - Reusable Row
    @ViewBuilder
    private func infoRow(
        title: String,
        value: String,
        icon: String
    ) -> some View {

        HStack(alignment: .center, spacing: 12) {

            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 3) {

                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(value.isEmpty ? "-" : value)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .textSelection(.enabled)
            }

            Spacer(minLength: 10)
        }
        .padding(.vertical, 5)
    }

    // MARK: - Vehicle Summary
    @ViewBuilder
    private func vehicleSummary(vehicle: Vehicle) -> some View {

        HStack(spacing: 16) {

            Image(systemName: vehicleIcon(for: vehicle.vehicleType))
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
                .background(
                    LinearGradient(
                        colors: [.blue, .indigo],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 18,
                        style: .continuous
                    )
                )

            VStack(alignment: .leading, spacing: 5) {

                Text("\(vehicle.year) \(vehicle.make)")
                    .font(.title3.weight(.bold))

                Text(vehicle.model)
                    .font(.headline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 6) {

                    Image(systemName: "fuelpump.fill")

                    Text(vehicle.fuelType)
                }
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }

    // MARK: - Vehicle Icon
    private func vehicleIcon(for type: String) -> String {

        switch type.lowercased() {

        case "truck":
            return "truck.box.fill"

        case "motorcycle":
            return "motorcycle.fill"

        case "bus":
            return "bus.fill"

        case "van":
            return "car.side.fill"

        default:
            return "car.fill"
        }
    }

    // MARK: - VIN
    @ViewBuilder
    private func vinView(vin: String) -> some View{

        VStack(alignment: .leading, spacing: 8) {

            HStack(spacing: 8) {

                Image(systemName: "qrcode")
                    .foregroundStyle(.blue)

                Text("Vehicle Identification Number")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Spacer()
            }

            HStack {

                Text(vin.isEmpty ? "-" : vin)
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .textSelection(.enabled)

                Spacer()
            }
        }
        .padding(14)
        .background(
            Color.blue.opacity(0.07),
            in: RoundedRectangle(
                cornerRadius: 14,
                style: .continuous
            )
        )
    }

    // MARK: - Suggestions
    private var suggestionsSection: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack {

                Image(systemName: "sparkles")
                    .foregroundStyle(.orange)

                Text("Suggestions")
                    .font(.title2.weight(.bold))

                Spacer()
            }

            LazyVGrid(
                columns: [
                    GridItem(
                        .adaptive(minimum: 145),
                        spacing: 14
                    )
                ],
                spacing: 14
            ) {

                ForEach(allCategories, id: \.key) { category in

                    Button {
                        openSuggestion2(category: category)
                    } label: {

                        VStack(alignment: .leading, spacing: 12) {

                            Image(systemName: suggestionIcon(for: category))
                                .font(
                                    .system(
                                        size: 22,
                                        weight: .semibold
                                    )
                                )

                            Spacer(minLength: 4)

                            Text(
                                category.displayName[languageCode]
                                ?? category.displayName["en"]
                                ?? category.key
                            )
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)

                            HStack(spacing: 4) {

                                Text("Explore")

                                Image(systemName: "arrow.right")
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        }
                        .foregroundStyle(.primary)
                        .frame(
                            maxWidth: .infinity,
                            minHeight: 125,
                            alignment: .topLeading
                        )
                        .padding(16)
                        .background(.regularMaterial)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 20,
                                style: .continuous
                            )
                        )
                        .overlay {
                            RoundedRectangle(
                                cornerRadius: 20,
                                style: .continuous
                            )
                            .strokeBorder(
                                Color.primary.opacity(0.07),
                                lineWidth: 1
                            )
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Suggestion Icon
    private func suggestionIcon(
        for category: PlaceCategory
    ) -> String {

        switch category.key {

        case "car_service":
            return "wrench.and.screwdriver.fill"

        case "car_parts":
            return "shippingbox.fill"

        case "gas_station":
            return "fuelpump.fill"

        case "restaurant":
            return "fork.knife"

        case "cafe":
            return "cup.and.saucer.fill"

        case "bakery":
            return "birthday.cake.fill"

        case "hotel":
            return "bed.double.fill"

        case "hostel":
            return "person.2.fill"

        case "resort":
            return "sun.max.fill"

        case "cinema":
            return "film.fill"

        case "amusement_park":
            return "figure.2.and.child.holdinghands"

        case "zoo":
            return "pawprint.fill"

        case "museum":
            return "building.columns.fill"

        case "park":
            return "tree.fill"

        case "beach":
            return "beach.umbrella.fill"

        case "hiking":
            return "figure.hiking"

        case "gym":
            return "dumbbell.fill"

        case "swimming_pool":
            return "figure.pool.swim"

        case "playground":
            return "figure.play"

        case "children_museum":
            return "figure.2.and.child.holdinghands"

        case "shopping_mall":
            return "building.2.fill"

        case "supermarket":
            return "cart.fill"

        case "clothing_store":
            return "tshirt.fill"

        case "hospital":
            return "cross.case.fill"

        case "pharmacy":
            return "cross.fill"

        default:
            return "mappin.and.ellipse"
        }
    }

    // MARK: - Nearby Service
    private var nearbyServiceButton: some View {

        Button {
            openNearbyService()
        } label: {

            HStack(spacing: 14) {

                Image(systemName: "location.magnifyingglass")
                    .font(.system(size: 22, weight: .semibold))
                    .frame(width: 44, height: 44)
                    .background(
                        Color.white.opacity(0.16),
                        in: RoundedRectangle(
                            cornerRadius: 12,
                            style: .continuous
                        )
                    )

                VStack(alignment: .leading, spacing: 3) {

                    Text("Find Nearby Service")
                        .font(.headline)

                    Text("Find car services around you")
                        .font(.caption)
                        .opacity(0.85)
                }

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.headline)
            }
            .foregroundStyle(.white)
            .padding(16)
            .background {
                LinearGradient(
                    colors: [.blue, .indigo],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
            )
            .shadow(
                color: Color.blue.opacity(0.25),
                radius: 12,
                x: 0,
                y: 7
            )
        }
        .buttonStyle(.plain)
    }
    

    // MARK: - Open Suggestion in Maps
    private func openSuggestion(category: PlaceCategory, mapProvider: String = "google") {
        guard let user = appState.user else { return }

        // Age-based personalization
        var ageText = ""
        if let dobString = user.metadata?["dob"] as? String,
           let dob = ISO8601DateFormatter().date(from: dobString) {
            let age = Calendar.current.dateComponents([.year], from: dob, to: Date()).year ?? 0
            ageText = "\(age)-year-old"
        }

        // Vehicle info (only for vehicle services)
        var vehicleText = ""
        if let vehicle = appState.vehicle,
           ["car_service", "car_parts", "car_repair", "maintenance"].contains(category.key) {
            let make = vehicle.make
            let model = vehicle.model
            let year = vehicle.year != 0 ? String(vehicle.year) : ""
            vehicleText = "\(make) \(model) \(year)"
        }

        // Age/family hints for other categories
        var preferenceText = ""
        if !["car_service", "car_parts", "car_repair", "maintenance"].contains(category.key) {
            if !ageText.isEmpty {
                if category.key.contains("kids") || category.key.contains("playground") || category.key.contains("children") {
                    preferenceText = "for children"
                } else if Int(ageText.split(separator: "-").first ?? "0") ?? 0 < 18 {
                    preferenceText = "for teens"
                } else {
                    preferenceText = "for adults"
                }
            }
        }

        // Region
        let region = appState.vehicle?.countryCode ?? "JO"

        // Build query dynamically
        var query = category.mapTypes[mapProvider] ?? category.displayName[languageCode] ?? category.displayName["en"]!

        if !vehicleText.isEmpty { query += " " + vehicleText }
        if !preferenceText.isEmpty { query += " " + preferenceText }
        query += " near \(region)"

        // Encode & open Maps
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        if let url = URL(string: "http://maps.apple.com/?q=\(encodedQuery)") {
            UIApplication.shared.open(url)
        }
    }

    private func openSuggestion2(category: PlaceCategory, mapProvider: String = "GOOGLE") {
        guard let user = appState.user else { return }

        // Age-based personalization
        var ageText = ""
        if let dobString = user.metadata?["dob"] as? String,
           let dob = ISO8601DateFormatter().date(from: dobString) {
            let age = Calendar.current.dateComponents([.year], from: dob, to: Date()).year ?? 0
            ageText = "\(age)-year-old"
        }

        // Vehicle info (only for vehicle-related categories)
        var vehicleText = ""
        if let vehicle = appState.vehicle,
           ["car_service", "car_parts", "car_repair", "maintenance"].contains(category.key) {
            let make = vehicle.make
            let model = vehicle.model
            let year = vehicle.year != 0 ? String(vehicle.year) : ""
            vehicleText = "\(make) \(model) \(year)"
        }

        // Age/family hints for other categories
        var preferenceText = ""
        if !["car_service", "car_parts", "car_repair", "maintenance"].contains(category.key) {
            if !ageText.isEmpty {
                if category.key.contains("kids") || category.key.contains("playground") || category.key.contains("children") {
                    preferenceText = "for children"
                } else if Int(ageText.split(separator: "-").first ?? "0") ?? 0 < 18 {
                    preferenceText = "for teens"
                } else {
                    preferenceText = "for adults"
                }
            }
        }

        // Region
        let region = appState.vehicle?.countryCode ?? "JO"

        // Build the search query
        let baseQuery = category.mapTypes[mapProvider] ?? category.displayName[languageCode] ?? category.displayName["en"]!
        var fullQuery = baseQuery
        if !vehicleText.isEmpty { fullQuery += " " + vehicleText }
        if !preferenceText.isEmpty { fullQuery += " " + preferenceText }
        fullQuery += " near \(region)"

        // Encode the query
        let encodedQuery = fullQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? fullQuery

        // Generate URL based on map provider
        var urlString: String
        switch mapProvider.lowercased() {
        case "apple":
            urlString = "http://maps.apple.com/?q=\(encodedQuery)"
        case "google":
            urlString = "comgooglemaps://?q=\(encodedQuery)&center=\(region)"
            // Fallback to web if app is not installed
            if !UIApplication.shared.canOpenURL(URL(string: urlString)!) {
                urlString = "https://www.google.com/maps/search/?api=1&query=\(encodedQuery)"
            }
        case "amap":
            // Amap URL scheme: https://lbs.amap.com/api/uri-api/poi
            urlString = "iosamap://search?keywords=\(encodedQuery)&city=\(region)"
            // Fallback to web
            if !UIApplication.shared.canOpenURL(URL(string: urlString)!) {
                urlString = "https://www.amap.com/search?query=\(encodedQuery)"
            }
        case "here":
            // HERE Maps Web search
            urlString = "https://wego.here.com/search/\(encodedQuery)"
        default:
            urlString = "http://maps.apple.com/?q=\(encodedQuery)"
        }

        // Open the map
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

    // MARK: - Open Nearby Car Service (default)
    private func openNearbyService() {
        if let category = allCategories.first(where: { $0.key == "car_service" }) {
            openSuggestion(category: category)
        }
    }

}
