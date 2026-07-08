
# DBMS Three-Schema Architecture

## What is Three-Schema Architecture?

The **Three-Schema Architecture** is a DBMS architecture that separates the database into three abstraction levels:

1. External Level (View Level)
2. Conceptual Level (Logical Level)
3. Internal Level (Physical Level)

Its primary objective is to achieve **Data Independence** while allowing multiple users to access the same database differently.

---

# Overall Architecture

```text
                     USERS / APPLICATIONS
      +-------------+-------------+-------------+
      |             |             |             |
      | Student     | Teacher     | Admin       |
      +------+------+------+------+------+------+
             |             |             |
             +-------------+-------------+
                           |
                           v

+------------------------------------------------------+
|              EXTERNAL LEVEL (VIEW LEVEL)             |
|------------------------------------------------------|
| Student View | Teacher View | Admin View | HR View   |
+------------------------------------------------------+
                           |
                           | Mapping
                           v
+------------------------------------------------------+
|          CONCEPTUAL LEVEL (LOGICAL LEVEL)            |
|------------------------------------------------------|
|                Entire Database Schema                |
|                                                      |
| Student      Course      Faculty      Result         |
|      \          |            /                      |
|       \---------Relationship----------------        |
+------------------------------------------------------+
                           |
                           | Mapping
                           v
+------------------------------------------------------+
|          INTERNAL LEVEL (PHYSICAL LEVEL)             |
|------------------------------------------------------|
| Files | Pages | Blocks | Indexes | B+ Trees | SSD    |
+------------------------------------------------------+
                           |
                           v
                  Physical Storage (Disk)
```

---

# 1. External Level (View Level)

## Architecture Diagram

```text
                 USERS

      +---------+---------+---------+
      | Student | Teacher |  Admin  |
      +----+----+----+----+----+----+
           |         |         |
           |         |         |
+----------v---------v---------v----------------+
|              EXTERNAL LEVEL                   |
|-----------------------------------------------|
| Student View                                  |
| Teacher View                                  |
| Admin View                                    |
| HR View                                       |
+-----------------------------------------------+
```

## Explanation

The External Level provides different views of the same database.

Each user accesses only the required information.

### Example

Student View

```
Roll No
Name
Marks
```

Teacher View

```
Roll No
Attendance
Marks
```

Admin View

```
Everything
```

---

# 2. Conceptual Level (Logical Level)

## Architecture Diagram

```text
                CONCEPTUAL LEVEL

             +----------------------+
             |      STUDENT         |
             +----------------------+
                     |
                     |
          +----------+----------+
          |                     |
          | Enrolled In         |
          |                     |
+---------v---------+    +------v-------+
|      COURSE       |    |   RESULT     |
+-------------------+    +--------------+
          |
          |
+---------v---------+
|     FACULTY       |
+-------------------+
```

## Explanation

The Conceptual Level represents the complete logical structure of the database.

It defines

- Tables
- Relationships
- Constraints
- Data Types

without worrying about physical storage.

---

# 3. Internal Level (Physical Level)

## Architecture Diagram

```text
                 INTERNAL LEVEL

          SQL Query
              |
              v
      +----------------+
      | Query Processor|
      +-------+--------+
              |
              v
      +----------------+
      | Index Manager  |
      +-------+--------+
              |
              v
      +----------------+
      | File Manager   |
      +-------+--------+
              |
              v
+--------------------------------------+
| Disk Storage                          |
|--------------------------------------|
| Block 1                              |
| Block 2                              |
| Block 3                              |
| Index Files                          |
| Data Files                           |
+--------------------------------------+
```

## Explanation

The Internal Level determines how data is actually stored.

It manages

- File Organization
- Indexing
- B+ Trees
- Hashing
- Record Placement
- Compression

---

# Complete ER-Style Flow

```text
                 USERS
                    |
        +-----------+-----------+
        |           |           |
        |           |           |
   Student      Teacher      Admin
        \           |          /
         \          |         /
          \         |        /
           +--------+-------+
                    |
                    v

         +----------------------+
         |   EXTERNAL LEVEL     |
         +----------------------+
                    |
                    |
             View Mapping
                    |
                    v

         +----------------------+
         | CONCEPTUAL LEVEL     |
         +----------------------+

      +-----------+      +-----------+
      | Student   |------| Course    |
      +-----------+      +-----------+
            |                  |
            |                  |
      +-----------+      +-----------+
      | Result    |------| Faculty   |
      +-----------+      +-----------+

                    |
             Schema Mapping
                    |
                    v

         +----------------------+
         |   INTERNAL LEVEL     |
         +----------------------+
                    |
       +------------+------------+
       |            |            |
       |            |            |
    Data Files   Indexes     Log Files
       |            |            |
       +------------+------------+
                    |
                    v
              Physical Disk
```

---

# Mapping Between Levels

```text
External Schema
      |
      | External/Conceptual Mapping
      |
      v
Conceptual Schema
      |
      | Conceptual/Internal Mapping
      |
      v
Internal Schema
```

---

# Data Independence

## Physical Data Independence

```text
Applications
      |
      v
Logical Schema
      |
      |
 Internal Storage Changes

 HDD
   ↓
 SSD

 B-Tree
   ↓
 Hash Index

No application changes required.
```

---

## Logical Data Independence

```text
Old Schema

Student
-------
ID
Name

↓

New Schema

Student
-------
ID
Name
Email
Phone

↓

Existing user views continue to work.
```

---

# Advantages

- ✔ Data Independence
- ✔ Multiple User Views
- ✔ Better Security
- ✔ Easier Maintenance
- ✔ Scalability
- ✔ Reduced Complexity
- ✔ Data Abstraction

---

# Disadvantages

- More complex implementation
- Higher development cost
- Slight performance overhead due to abstraction

---

# Interview Summary

| Level | Purpose | Example |
|--------|---------|---------|
| External | User-specific view | Student Portal |
| Conceptual | Complete logical design | Tables & Relationships |
| Internal | Physical storage | Files, Blocks, Indexes |

---

# Memory Trick

```text
Users
   ↓
Views
   ↓
Logic
   ↓
Storage

External
     ↓
Conceptual
     ↓
Internal
```

**Mnemonic:** **"View → Logic → Storage (VLS)"**

