struct Model: Codable {
    let orderId: String
    let orderDate: String
    let customer: Customer
    let items: [Product]
    let shipping: Shipping
    let payment: Payment
    let subtotal: Double
    let tax: Double
    let total: Double
    let status: String

    struct Customer: Codable {
        let customerId: Int
        let name: String
        let email: String
    }

    struct Product: Codable {
        let productId: String
        let name: String
        let quantity: Int
        let price: Double
    }

    struct Shipping: Codable {
        let method: String
        let cost: Double
        let address: Address

        struct Address: Codable {
            let street: String
            let city: String
            let state: String
            let zipCode: String
        }
    }

    struct Payment: Codable {
        let method: String
        let last4: String
        let status: String
    }
}
