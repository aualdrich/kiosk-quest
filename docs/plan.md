## Tasks

Vertical Slice 1: Create and return basic order info
[x]. Create and seed MenuItem
[x] Create Order and OrderItems models
[ ] Create OrderPlacementService
[ ] Create the order controller (/order route) and wire it up to return available info.

Vertical Slice 2: Add validations
[ ] Items must be present
[ ] Qty must be positive
[ ] item_ids must exist

Vertical Slice 3: Add discount logic
[ ] If subtotal >= 2000 cents, apply 10% discount to order total
[ ] Ensure we store the discount amount as a column in the orders table.

Vertical Slice 4: Prep Calculation
TODO:

Vertical Slice 5: Quality of Life Improvements
[ ] linter
[ ] bundle security
[ ] audit db query quality, security

