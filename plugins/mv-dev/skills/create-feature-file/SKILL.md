---
description: Generate a Gherkin BDD file from a feature documented in Notion
---

# Create Feature File from Notion

Search for a feature documented in Notion, extract requirements, and generate a Gherkin (.feature) file with BDD/Cucumber scenarios.

## Step 1: Search for the feature in Notion

Use the Notion MCP to search for the feature page:

```
Search in Notion: "[feature name]"
```

**Example:** "Create Store Order module – Daily Menu for backoffice"

If there are multiple results, ask the user which is the correct one.

## Step 2: Read the feature content

Once the correct page is identified:

1. Read the complete page content
2. Read sub-pages if they exist (requirements, use cases, etc.)
3. Extract:
   - **Description**: What the feature does
   - **Actors**: Who uses the feature (e.g., admin, chef, user)
   - **Functional requirements**: What the system must do
   - **Use cases**: Main flows
   - **Acceptance criteria**: Success conditions
   - **Constraints**: Validations, limits

## Step 3: Generate the Gherkin file

Create file at: `features/[normalized-name].feature`

**Normalized name:** kebab-case, no accents, no spaces
- "Create Store Order module" → `create-store-order-module.feature`

### Gherkin file structure:

```gherkin
Feature: [Feature Name]
  As a [actor]
  I want to [objective]
  So that [benefit]

  Background:
    Given I am authenticated as [actor]
    And I have [role] permissions

  Scenario: [Main use case]
    Given [precondition]
    When [user action]
    Then [expected result]
    And [additional verifications]

  Scenario: [Alternative use case]
    Given [precondition]
    When [user action]
    Then [expected result]

  Scenario: [Error handling]
    Given [precondition]
    When [invalid action]
    Then [error message]
    And [system state does not change]

  Scenario Outline: [Multiple cases with data]
    Given <precondition>
    When <action>
    Then <result>

    Examples:
      | field1   | field2   | result       |
      | value1   | value2   | expected1    |
      | value3   | value4   | expected2    |
```

## Step 4: Rules for generating scenarios

### From Functional Requirements → Scenarios

For each functional requirement, create at least:
1. **Happy path scenario**: Successful flow
2. **Validation scenario**: Invalid data
3. **Permissions scenario**: User without access

### From Use Cases → Scenarios

Each documented use case → 1 Gherkin scenario

### From Acceptance Criteria → Verifications

Each criterion → 1 `Then` or `And` line

### Conversion examples:

**Requirement:** "The admin can create a daily menu with date and products"

**→ Scenario:**
```gherkin
Scenario: Admin creates daily menu successfully
  Given I am an authenticated administrator
  And I am on the menus page
  When I select the date "2026-02-15"
  And I add the products "Caesar Salad, Baked Chicken, Brown Rice"
  And I click "Save menu"
  Then I see the message "Menu created successfully"
  And the menu appears in the menu list
  And the date is "2026-02-15"
```

**Validation:** "The date cannot be in the past"

**→ Scenario:**
```gherkin
Scenario: Error when creating menu with past date
  Given I am an authenticated administrator
  And I am on the menus page
  When I select the date "2026-01-01"
  And I click "Save menu"
  Then I see the error "Date cannot be in the past"
  And the menu is not created
```

## Step 5: Create the file

```
Write file: features/[normalized-name].feature
```

Show the user:
- ✅ Created file path
- 📝 Number of scenarios generated
- 🔍 Summary of what the file covers

## Step 6: Additional suggestions

After creating the file, suggest:

1. **Review and adjust**: The file is a starting point
2. **Add more scenarios**: Specific edge cases
3. **Implement the steps**: Create step definitions in the testing framework
4. **Link with code**: Keep the .feature file updated with development

## Complete example

**Input:** `create-feature-file "Create Store Order module – Daily Menu for backoffice"`

**Output:**
```
✅ File created: features/create-store-order-module-daily-menu.feature
📝 6 scenarios generated:
   - Admin creates daily menu successfully
   - Admin edits existing menu
   - Error when creating menu with past date
   - Error without selected products
   - Admin views menus by date range
   - Admin deletes unused menu

🔍 Coverage:
   - Main use cases: 3/3
   - Validations: 2/2
   - Permissions: Verified for admin role
```

## Important notes

- **Language:** Gherkin in English
- **Descriptive names:** Scenarios must be self-explanatory
- **Given/When/Then:** Strictly follow this order
- **Multiple verifications:** Use `And` for additional verifications
- **Data tables:** Use `Scenario Outline` for similar cases with different data
- **Comments:** Add `#` to explain complex context
- **Tags:** Use `@tag` before the scenario to categorize (e.g., `@smoke`, `@regression`, `@admin`)

## Project configuration

Ensure the project has:

```
features/
├── [feature-name].feature    # Gherkin files
└── step_definitions/          # Step implementations
    └── [feature-name]Steps.ts
```

Recommended framework: **Cucumber.js** or **Jest-Cucumber**
