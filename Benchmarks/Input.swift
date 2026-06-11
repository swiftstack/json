let input = """
{
  "orderId": "ORD-2025-12345",
  "orderDate": "2025-01-15T10:30:00Z",
  "customer": {
    "customerId": 5678,
    "name": "Michael Chen",
    "email": "michael.chen@example.com"
  },
  "items": [
    {
      "productId": "PROD-001",
      "name": "Wireless Mouse",
      "quantity": 2,
      "price": 29.99
    },
    {
      "productId": "PROD-002",
      "name": "USB Cable",
      "quantity": 3,
      "price": 9.99
    }
  ],
  "shipping": {
    "method": "Express",
    "cost": 15.00,
    "address": {
      "street": "789 Pine Street",
      "city": "Seattle",
      "state": "WA",
      "zipCode": "98101"
    }
  },
  "payment": {
    "method": "credit_card",
    "last4": "4242",
    "status": "paid"
  },
  "subtotal": 89.95,
  "tax": 8.10,
  "total": 113.05,
  "status": "processing"
}
"""
