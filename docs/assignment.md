# Kiosk Quest (Speed Run) 🍔⚡
**60‑Minute RubyOnRails Take‑Home Exercise**

Thanks for your interest! This short, fun, time-boxed exercise is designed to assess how you design, code, and test a small Ruby on Rails service.

---

## 🎯 Goal

Implement **one HTTP endpoint** that creates a kiosk order, calculates totals + a discount, and returns a prep‑time estimate.

Time expectation: **~60 minutes**

---

## 🛠️ Constraints

- Ruby **3.0+**
- Rails **7+**
- **Rspec** required
- Deliverable: repo or zip + this README

---

## 📦 The Exercise

Create an HTTP service with one route:

### `POST /order`

#### Request body
```json
{
  "items": [
    {"item_id": 1, "qty": 2},
    {"item_id": 2, "qty": 1},
    {"item_id": 3, "qty": 1}    
  ]
}
```

---

## 🍟 Menu (hard‑code this)

Use exactly this menu in your code:

| item_id | name         | price_cents | prep_seconds |
|--------:|--------------|-------------:|---------------:|
| 1 | Cheeseburger | 899 | 90 |
| 2 | Fries        | 399 | 60 |
| 3 | Milkshake    | 499 | 75 |
| 4 | Salad        | 699 | 45 |
| 5 | Nuggets      | 599 | 80 |

---

## 📤 Response format

Return JSON with:

- `subtotal_cents`
- `discount_cents`
- `total_cents`
- `estimated_prep_seconds`
- `prep_schedule` (**new**)

Example (values will vary):
```json
{
  "subtotal_cents": 2297,
  "discount_cents": 230,
  "total_cents": 2067,
  "estimated_prep_seconds": 180,
  "prep_schedule": [
    [1, 180],
    [2, 135]
  ]
}
```

---

## 📐 Rules

### Pricing
- `subtotal_cents = sum(price_cents * qty)`
- If subtotal **>= 2000 cents**, apply **10% discount** (round to nearest cent)
- `total_cents = subtotal_cents - discount_cents`

### Prep Time — “Boss Battle” ⏱️

The kitchen has **2 parallel prep stations**.

For each line item:
```
line_prep = prep_seconds * qty
```

Assign each `line_prep` to the station with the **lowest current load** (greedy).  
Use the **request order**.

```
estimated_prep_seconds = max(station_1_load, station_2_load)
```

---

### 1) Return a **sorted** prep breakdown
Include `prep_schedule` in the response as a list of `(station_id, total_prep_seconds)` pairs:
- The list must be **sorted in descending order** by `total_prep_seconds`
- Sorting must be done programmatically (not hardcoded)

Example:
```json
"prep_schedule": [
  [1, 180],
  [2, 135]
]
```

---

## 🚨 Validation & Errors

Return **HTTP 400** with a helpful message if:

- `items` is missing or empty
- any `qty` is not a positive integer
- any `item_id` does not exist

---

## 🧪 Tests (minimum)

Using Rspec, include:

1. **Unit test** for the prep‑time function  
2. **API test** for successful order creation (including `prep_schedule` ordering)  
3. *(Optional bonus)* API test validating a 400 error

---

## 📄 README must include

- How to run the service
- How to run tests

---

## ✅ What we evaluate

- Code clarity and structure
- Correct business logic
- Error handling
- Test quality
- Proper uses list sorting
- Pragmatic decisions under time pressure

Good luck — and have fun 🚀
