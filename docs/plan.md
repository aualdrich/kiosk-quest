## Tasks

Vertical Slice 1: Create and return basic order info
[x]. Create and seed MenuItem
[x] Create Order and OrderItems models
[x] Create OrderPlacementService
[x] Create the order controller (/order route) and wire it up to return available info.

Vertical Slice 2: Add validations
[x] Items must be present
[x] Qty must be positive
[x] item_ids must exist

Vertical Slice 3: Add discount logic
[x] If subtotal >= 2000 cents, apply 10% discount to order total
[x] Ensure we store the discount amount as a column in the orders table.

Vertical Slice 4: Prep Calculation
[x] Create prep calculation service
[x] Wire it into the order placement service
[x] Add the estimation and prep_schedule to the response

Vertical Slice 5: Quality of Life Improvements
[ ] linter
[ ] bundle security
[ ] audit db query quality, security

