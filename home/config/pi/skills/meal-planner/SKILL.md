---
name: meal-planner
description: Plans flavorful, healthy meals from the personal recipe vault, proposes new recipes for approval, creates consolidated grocery lists, and adds approved items to the shared Apple Reminders Groceries list. Use for meal planning, choosing recipes, grocery preparation, recipe ratings, and food preference updates.
compatibility: macOS with Apple Reminders and access to /Users/jackson/vault/recipes
---

# Meal Planner

Use `/Users/jackson/vault/recipes` as the vault root. Read `config/preferences.md` before planning. Reusable templates are under `config/templates/`.

## Weekly Planning Workflow

1. Ask how many full dinners to cook and which dates need meals. Do not assume it is the same each week.
2. Ask about unusual schedule needs, guests, cravings, expiring ingredients, or budget constraints.
3. Read permanent recipe Markdown files in the vault root and recipe category folders such as `desserts/`. Exclude `config/`, `meal-plans/`, and `grocery-lists/`.
4. Build a draft plan that:
   - Targets four servings for dinner unless told otherwise.
   - Intentionally schedules leftovers for lunches or non-cooking nights.
   - Uses simple breakfasts and does not plan elaborate lunches by default.
   - Prioritizes flavorful, generally healthy meals rather than strict diet food.
   - Offers variety in proteins, vegetables, and cuisines.
   - Suggests dessert only occasionally, not every week.
5. Existing approved recipes may be selected directly. Present any new recipe suggestion and obtain approval before writing it into the vault.
6. Show the complete draft and ask for approval before creating the dated plan under `meal-plans/YYYY-MM-DD.md`, using `config/templates/meal-plan.md` as a guide. Create the output directory if needed.

## Grocery Workflow

1. Read every recipe used in the approved plan.
2. Scale quantities when planned servings differ from recipe servings.
3. Combine equivalent ingredients and quantities where practical. Do not combine meaningfully different forms, such as fresh and powdered garlic.
4. Organize items by Produce, Meat & Seafood, Dairy & Refrigerated, Bakery, Pantry, Frozen, and Other.
5. Ask which listed ingredients are already on hand. Remove those from the shopping section and record them under `Already on Hand`.
6. Save the dated list under `grocery-lists/YYYY-MM-DD.md`, using `config/templates/grocery-list.md` as a guide. Create the output directory if needed.
7. Display the exact reminders that will be created and explicitly ask for approval.
8. Only after approval, add each grocery item as a separate reminder to the existing shared list named `Groceries`:

```bash
~/.pi/agent/skills/meal-planner/scripts/add-to-reminders.sh Groceries \
  "2 bell peppers" \
  "1 lb lean ground beef"
```

9. Update the grocery file's Reminders Status with the date and number of items added.
10. Never delete, complete, rename, or modify existing reminders. Never add reminders without final approval.

## Preferences and Ratings

- When either person states a like or dislike, confirm it and update the corresponding section of `config/preferences.md`.
- After a new meal is cooked, ask each person for a 1–5 rating and short notes when appropriate.
- Add ratings to the dated meal plan. Use repeated positive or negative feedback in later selections.
- Do not infer an allergy from a dislike. Treat safety restrictions only as explicitly stated.

## Adding Recipes

Store approved recipes as lowercase hyphenated Markdown files in the vault root or an appropriate recipe category folder such as `desserts/`. Follow the existing YAML frontmatter and sections: `Ingredients`, `Instructions`, and `Notes`. Include `servings`, meal types, useful tags, and `approved: true`. Make ingredient quantities explicit enough to generate a grocery list.
