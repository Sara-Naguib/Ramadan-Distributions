# Ramadan Distributions — Database Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Database Design](#database-design)
3. [Table Descriptions](#table-descriptions)
4. [Relationships & Business Rules](#relationships--business-rules)
5. [Technical Research](#technical-research)

---

## Project Overview

**Ramadan Distributions** is a humanitarian logistics system built for the Sharkia Governorate to manage food distribution during the holy month of Ramadan. The database tracks warehouses, food inventory, donations, beneficiaries, volunteers, and drivers — ensuring that the right food reaches the right families on time, with zero waste and zero duplication.

---

## Database Design

### Entity-Relationship Diagram
[You can see tables and ERD here](https://sara-naguib.github.io/Ramadan-Distributions/)


### Design Philosophy

- **Single source of truth for people:** All human actors (Admins, Volunteers, Drivers, Beneficiaries) share the `users_master` table with a `role` discriminator. Role-specific data lives in dedicated tables (`beneficiary_details`, `volunteer_skills`)
- **Strict referential integrity:** Every inventory item must belong to a warehouse (`ON DELETE RESTRICT`). Deleting a user cascades only where safe (e.g., beneficiary details), and sets NULL where a record should remain (e.g., warehouse supervisor)
- **Business rules enforced at the database level** via `CHECK` constraints, `UNIQUE` keys, and `TRIGGERS` — not left to application code

---

## Table Descriptions

### `users_master`
Central directory for all system users. The `role` ENUM (`Admin`, `Volunteer`, `Driver`, `Beneficiary`) controls access logic. Phone numbers are unique to prevent duplicate registrations.

### `warehouses`
Tracks every storage facility with live status (`Open`, `Full`, `Maintenance`) and links to a supervising admin via `supervisor_id`. Capacity is stored in kilograms.

### `food_categories`
Defines food types (`Dry`, `Fresh`, `Cooked`) and the `required_storage_temperature` to prevent spoilage. Drives the expiry-check trigger logic.

### `inventory_items`
Tracks individual food items with quantity, expiry date, and links to both a warehouse and a food category. The `expiry_date` column is indexed for fast lookups.

### `donations_log`
Records every donation with donor name, value, type (`Cash`/`Food`), and organization type (`Individual`, `Company`, `NGO`). Purely append-only — no foreign key to `users_master` to allow anonymous or external donors.

### `beneficiary_details`
Extends `users_master` for Beneficiaries only (enforced by trigger/application logic). Stores `poverty_score` (1–10), `family_members_count`, and `last_received_date` to enforce the 15-day re-delivery rule.

### `skills` & `volunteer_skills`
A many-to-many junction resolving volunteer-to-skill assignments. `volunteer_skills` carries `years_of_experience` as a relationship attribute. The composite unique key `(volunteer_id, skill_id)` prevents duplicate assignments.

### `training_sessions` & `driver_training`
`driver_training` is a many-to-many junction between drivers and sessions. It is the enforcement point for the "Safety First" prerequisite trigger on `vehicle_assignments`.

### `vehicle_assignments`
Records which driver is assigned to which vehicle. A trigger blocks assignment if the driver has not completed the "Safety First" training session.

---

## Relationships & Business Rules

| Rule | Implementation |
|---|---|
| An item must belong to a warehouse | `warehouse_id NOT NULL` + `FOREIGN KEY` with `ON DELETE RESTRICT` |
| Items expiring within 3 days cannot go to Dry Boxes | `BEFORE INSERT` trigger on `inventory_items` |
| A family cannot receive a box within 15 days | `BEFORE UPDATE` trigger on `beneficiary_details` |
| Only Beneficiary-role users get a `beneficiary_details` record | `FOREIGN KEY` to `users_master`; enforced by application layer |
| A volunteer can have many skills; a skill can belong to many volunteers | Junction table `volunteer_skills` |
| Drivers must complete "Safety First" before vehicle assignment | `BEFORE INSERT` trigger on `vehicle_assignments` |
| `poverty_score` must be between 1 and 10 | `CHECK (poverty_score BETWEEN 1 AND 10)` |
| `amount_value` must be positive | `CHECK (amount_value > 0)` |

---

## Technical Research

### 1. Database Indexing — Speeding Up Beneficiary Searches at Peak Hours (Before Iftar)

Before Iftar, staff run frequent queries filtering beneficiaries by **address, poverty score, and last received date**. Without indexes, MySQL performs a full table scan on every request — unacceptable at peak load.

**Indexes created:**

```sql
-- Speed up address-based filtering (example: all beneficiaries in Minya Al-Qamh)
CREATE INDEX idx_beneficiary_address ON users_master(address(50));

-- Speed up poverty score range filters
CREATE INDEX idx_poverty_score ON beneficiary_details(poverty_score);

-- Speed up 15-day eligibility checks
CREATE INDEX idx_last_received ON beneficiary_details(last_received_date);

-- Speed up expiry-based inventory lookups
CREATE INDEX idx_item_expiry ON inventory_items(expiry_date);

-- Composite index for warehouse + category queries
CREATE INDEX idx_item_warehouse_cat ON inventory_items(warehouse_id, category_id);

-- Speed up driver training session lookups
CREATE INDEX idx_driver_training_session ON driver_training(session_id);
```

- B-tree indexes allow MySQL to jump directly to matching rows instead of scanning the entire table. For the beneficiary query (address + poverty_score + last_received_date), the optimizer can use `idx_beneficiary_address` to narrow the candidate set dramatically before applying remaining filters. At peak hours with thousands of concurrent lookups, this reduces query time from seconds to milliseconds.

---

### 2. Triggers — Blocking an Expired Food Item from Being Shipped

A trigger is a stored procedure that fires automatically before or after a DML event (INSERT, UPDATE, DELETE). We use `BEFORE INSERT` triggers to intercept and reject bad data before it reaches the table.

**Trigger: Block dry-box assignment for near-expiry items**

```sql

CREATE TRIGGER check_drybox_expiry
BEFORE INSERT ON inventory_items
FOR EACH ROW
BEGIN
    DECLARE food_type VARCHAR(10);
    SELECT storage_type INTO food_type
    FROM food_categories
    WHERE category_id = NEW.category_id;

    IF food_type = 'Dry' AND NEW.expiry_date <= CURDATE() + INTERVAL 3 DAY THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Items expiring within 3 days cannot be assigned to Dry Boxes';
    END IF;
END 

```

- `BEFORE INSERT` fires before the row is written, allowing us to cancel the operation entirely.
- `SIGNAL SQLSTATE '45000'` raises a custom application error that propagates back to the caller.
- `NEW.category_id` / `NEW.expiry_date` reference the row being inserted.

**Additional triggers implemented:**
- `check_15_day_rule` — Prevents updating `last_received_date` on a beneficiary to a date within 15 days of the previous one.
- `check_driver_training` — Blocks inserting a `vehicle_assignments` row if the driver has no record in `driver_training` for the "Safety First" session.

---

### 3. Backup & Recovery — Protecting Donor Data from Server Crashes