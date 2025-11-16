# Setup Instructions for DS-2002 Data Project 2

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Azure Databricks Setup](#azure-databricks-setup)
3. [Data Source Configuration](#data-source-configuration)
4. [File Upload Instructions](#file-upload-instructions)
5. [Notebook Execution Guide](#notebook-execution-guide)
6. [Verification Steps](#verification-steps)
7. [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Software/Accounts
- [ ] Azure Databricks account (Community Edition or paid)
- [ ] Web browser (Chrome, Firefox, or Edge recommended)
- [ ] GitHub account (for repository submission)
- [ ] Basic knowledge of Python, SQL, and Spark

### Optional (for full production setup)
- [ ] Azure MySQL Database
- [ ] MongoDB Atlas account
- [ ] Azure subscription

## Azure Databricks Setup

### Step 1: Create Databricks Workspace

#### Option A: Community Edition (Free)
1. Go to https://community.cloud.databricks.com/
2. Click "Sign Up"
3. Fill in registration details
4. Verify email address
5. Login to workspace

#### Option B: Azure Databricks (Paid)
1. Login to Azure Portal
2. Create new resource → Databricks
3. Configure workspace settings
4. Deploy workspace
5. Launch workspace

### Step 2: Create Compute Cluster

1. **Navigate to Compute** in left sidebar
2. **Click "Create Cluster"**
3. **Configure cluster:**
   - **Cluster name:** `ds2002-project`
   - **Cluster mode:** Single Node (for development)
   - **Databricks runtime:** 13.3 LTS (includes Apache Spark 3.4.1, Scala 2.12)
   - **Node type:** 
     - Community Edition: Default node
     - Azure: Standard_DS3_v2 (4 cores, 14 GB RAM)
   - **Terminate after:** 120 minutes of inactivity
4. **Click "Create Cluster"**
5. **Wait for cluster to start** (3-5 minutes)

### Step 3: Install Required Libraries

1. **Navigate to cluster** → Libraries tab
2. **Install the following libraries:**

   **For MongoDB (if using real MongoDB Atlas):**
   - Library Source: Maven
   - Coordinates: `org.mongodb.spark:mongo-spark-connector_2.12:10.1.1`
   - Click "Install"

   **For MySQL (if using real Azure MySQL):**
   - Library Source: Maven
   - Coordinates: `mysql:mysql-connector-java:8.0.33`
   - Click "Install"

3. **Wait for libraries to install** (Status: Installed)
4. **Restart cluster** if needed

## Data Source Configuration

### Option 1: Simulated Setup (Recommended for Quick Start)

**No external databases required!** The notebook includes sample data generation that simulates:
- Azure MySQL → Python-generated customer data
- MongoDB Atlas → JSON file for products
- CSV files → Store data

**You only need to:**
1. Upload CSV and JSON files to DBFS
2. Run the notebook as-is

### Option 2: Full Production Setup

#### A. Azure MySQL Setup

1. **Create Azure MySQL Server:**
   ```bash
   # Via Azure Portal
   - Navigate to "Azure Database for MySQL"
   - Click "Create"
   - Choose "Flexible Server"
   - Configure server name, region, credentials
   - Set firewall rules (allow Databricks IPs)
   ```

2. **Run SQL Script:**
   ```bash
   # Connect to MySQL
   mysql -h your-server.mysql.database.azure.com -u admin -p
   
   # Execute setup script
   source data/sql_scripts/01_create_customers_mysql.sql
   ```

3. **Update Notebook Connection:**
   ```python
   # In Cell 6, update:
   mysql_config = {
       "host": "your-server.mysql.database.azure.com",
       "user": "admin",
       "password": "YourPassword123!",
       "database": "ecommerce_source"
   }
   ```

#### B. MongoDB Atlas Setup

1. **Create MongoDB Atlas Account:**
   - Go to https://www.mongodb.com/cloud/atlas
   - Sign up for free tier
   - Create new cluster (M0 Free tier)

2. **Create Database and Collection:**
   ```javascript
   // In MongoDB Atlas web console
   use ecommerce
   db.createCollection("products")
   
   // Import products_mongodb.json
   mongoimport --uri "your-connection-string" \
               --collection products \
               --file products_mongodb.json \
               --jsonArray
   ```

3. **Configure Network Access:**
   - Add IP: 0.0.0.0/0 (allow from anywhere)
   - Or whitelist Databricks NAT IPs

4. **Update Notebook Connection:**
   ```python
   # In Cell 8, update:
   mongodb_uri = "mongodb+srv://username:password@cluster.mongodb.net/ecommerce"
   ```

## File Upload Instructions

### Step 1: Download Project Files

```bash
# Clone repository
git clone https://github.com/yourusername/ds2002-project.git
cd ds2002-project
```

### Step 2: Upload Files to DBFS

#### Method A: Using Databricks UI (Easiest)

1. **Navigate to Data** in left sidebar
2. **Click "Create Table"**
3. **Upload Files:**

   **Upload stores.csv:**
   - Click "Upload File"
   - Select `data/csv/stores.csv`
   - Target location: `/FileStore/tables/stores.csv`
   - Click "Create"

   **Upload products_mongodb.json:**
   - Click "Upload File"
   - Select `data/json_streaming/products_mongodb.json`
   - Target location: `/FileStore/tables/products_mongodb.json`
   - Click "Create"

   **Upload streaming batches:**
   - Click "Upload File"
   - Select `data/json_streaming/batch1_sales.json`
   - Target location: `/FileStore/streaming_sales/batch1_sales.json`
   - Repeat for batch2 and batch3

#### Method B: Using Databricks CLI

```bash
# Install Databricks CLI
pip install databricks-cli

# Configure authentication
databricks configure --token

# Upload files
databricks fs cp data/csv/stores.csv dbfs:/FileStore/tables/stores.csv
databricks fs cp data/json_streaming/products_mongodb.json dbfs:/FileStore/tables/products_mongodb.json

# Create streaming directory and upload batches
databricks fs mkdirs dbfs:/FileStore/streaming_sales/
databricks fs cp data/json_streaming/batch1_sales.json dbfs:/FileStore/streaming_sales/
databricks fs cp data/json_streaming/batch2_sales.json dbfs:/FileStore/streaming_sales/
databricks fs cp data/json_streaming/batch3_sales.json dbfs:/FileStore/streaming_sales/
```

#### Method C: Using Notebook Commands

```python
# In a Databricks notebook cell:

# Upload from local file system (if files are on Databricks workspace)
dbutils.fs.cp("file:/path/to/stores.csv", "dbfs:/FileStore/tables/stores.csv")
dbutils.fs.cp("file:/path/to/products_mongodb.json", "dbfs:/FileStore/tables/products_mongodb.json")

# Create streaming directory
dbutils.fs.mkdirs("dbfs:/FileStore/streaming_sales/")

# Verify uploads
display(dbutils.fs.ls("dbfs:/FileStore/tables/"))
display(dbutils.fs.ls("dbfs:/FileStore/streaming_sales/"))
```

### Step 3: Verify File Uploads

```python
# Run this in a notebook cell to verify:
print("Files in /FileStore/tables/:")
display(dbutils.fs.ls("/FileStore/tables/"))

print("\nFiles in /FileStore/streaming_sales/:")
display(dbutils.fs.ls("/FileStore/streaming_sales/"))

# Expected output:
# /FileStore/tables/stores.csv
# /FileStore/tables/products_mongodb.json
# /FileStore/streaming_sales/batch1_sales.json
# (batch2 and batch3 uploaded later during execution)
```

## Notebook Execution Guide

### Step 1: Import Notebook

1. **Navigate to Workspace** in left sidebar
2. **Right-click on your user folder**
3. **Select Import**
4. **Choose "File"**
5. **Select** `notebooks/DS2002_Complete_Data_Lakehouse.py`
6. **Click "Import"**

### Step 2: Attach Notebook to Cluster

1. **Open imported notebook**
2. **Click "Detached"** dropdown at top
3. **Select your cluster** (`ds2002-project`)
4. **Wait for cluster to attach** (green checkmark)

### Step 3: Execute Notebook Cells

**Follow this sequence carefully:**

#### Phase 1: Setup and Dimensions (Cells 1-7)
```
✅ Cell 1: Markdown - Project overview
✅ Cell 2: Import libraries and configuration
✅ Cell 3: Verify DBFS uploads
✅ Cell 4: Create Date dimension
✅ Cell 5-6: Load Customer dimension (Azure MySQL)
✅ Cell 7: Demonstrate incremental load
✅ Cell 8: Load Product dimension (MongoDB)
✅ Cell 9: Load Store dimension (CSV)
✅ Cell 10: Verify all dimensions
```

**Verify after Phase 1:**
```python
# Run this check:
spark.sql("SHOW TABLES").show()
# Should see: dim_date, dim_customer, dim_product, dim_store
```

#### Phase 2: Bronze Layer - First Batch (Cells 11-13)
```
✅ Cell 11: Prepare streaming directory
✅ Cell 12: Upload batch1_sales.json to /FileStore/streaming_sales/
✅ Cell 13: Configure and run Bronze ingestion
```

**Manual Action Required:**
- Before running Cell 13, upload `batch1_sales.json`
- Verify file exists: `dbutils.fs.ls("/FileStore/streaming_sales/")`

**Verify after Bronze:**
```python
spark.table("bronze_sales").count()  # Should be 30
```

#### Phase 3: Silver Layer (Cells 14-15)
```
✅ Cell 14: Configure Silver transformation
✅ Cell 15: Execute Silver processing (joins streaming with dimensions)
```

**Verify after Silver:**
```python
spark.table("silver_sales").count()  # Should be 30
display(spark.sql("""
    SELECT customer_name, product_name, store_name, net_amount
    FROM silver_sales
    LIMIT 5
"""))
```

#### Phase 4: Gold Layer (Cells 16-17)
```
✅ Cell 16: Configure Gold aggregations
✅ Cell 17: Execute Gold processing
```

**Verify after Gold:**
```python
spark.table("gold_sales_summary").count()  # Should show aggregated records
```

#### Phase 5: Second Batch (Cells 18-19)
```
✅ Cell 18: Upload batch2_sales.json
✅ Cell 19: Process through Bronze-Silver-Gold
```

**Manual Action Required:**
- Upload `batch2_sales.json` to `/FileStore/streaming_sales/`

**Verify after Batch 2:**
```python
spark.table("bronze_sales").count()  # Should be 60
spark.table("silver_sales").count()  # Should be 60
```

#### Phase 6: Third Batch (Cells 20-21)
```
✅ Cell 20: Upload batch3_sales.json
✅ Cell 21: Process through Bronze-Silver-Gold
```

**Manual Action Required:**
- Upload `batch3_sales.json` to `/FileStore/streaming_sales/`

**Verify after Batch 3:**
```python
spark.table("bronze_sales").count()  # Should be 93
spark.table("silver_sales").count()  # Should be 93
```

#### Phase 7: Analytics (Cells 22-29)
```
✅ Cell 22: Query 1 - Customer Segment Analysis
✅ Cell 23: Query 2 - Top Products
✅ Cell 24: Query 3 - Monthly Sales Trend
✅ Cell 25: Query 4 - Store Performance
✅ Cell 26: Query 5 - Customer Lifetime Value
✅ Cell 27: Query 6 - Discount Impact
✅ Cell 28: Project Summary
✅ Cell 29: Final Verification
```

### Step 4: Review Results

**Check Final Status:**
```python
# Run this comprehensive check:
print("=" * 80)
print("FINAL PROJECT STATUS")
print("=" * 80)

# Dimensions
print(f"dim_date: {spark.table('dim_date').count()} records")
print(f"dim_customer: {spark.table('dim_customer').count()} records (should be 25)")
print(f"dim_product: {spark.table('dim_product').count()} records (should be 15)")
print(f"dim_store: {spark.table('dim_store').count()} records (should be 15)")

# Facts
print(f"\nbronze_sales: {spark.table('bronze_sales').count()} records (should be 93)")
print(f"silver_sales: {spark.table('silver_sales').count()} records (should be 93)")
print(f"gold_sales_summary: {spark.table('gold_sales_summary').count()} records")

print("\n" + "=" * 80)
print("✅ ALL REQUIREMENTS MET - PROJECT COMPLETE!")
print("=" * 80)
```

## Verification Steps

### 1. Data Completeness Check

```sql
-- Verify all tables exist
SHOW TABLES;

-- Check dimension record counts
SELECT 'dim_date' as table_name, COUNT(*) as records FROM dim_date
UNION ALL
SELECT 'dim_customer', COUNT(*) FROM dim_customer
UNION ALL
SELECT 'dim_product', COUNT(*) FROM dim_product
UNION ALL
SELECT 'dim_store', COUNT(*) FROM dim_store
UNION ALL
SELECT 'bronze_sales', COUNT(*) FROM bronze_sales
UNION ALL
SELECT 'silver_sales', COUNT(*) FROM silver_sales
UNION ALL
SELECT 'gold_sales_summary', COUNT(*) FROM gold_sales_summary;
```

### 2. Data Quality Check

```sql
-- Check for NULL keys in dimensions
SELECT COUNT(*) as null_customer_ids 
FROM dim_customer 
WHERE customer_id IS NULL;  -- Should be 0

-- Verify foreign key integrity
SELECT COUNT(*) as orphaned_sales
FROM silver_sales s
LEFT JOIN dim_customer c ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL;  -- Should be 0

-- Check for negative amounts
SELECT COUNT(*) as negative_amounts
FROM silver_sales
WHERE net_amount < 0;  -- Should be 0
```

### 3. Business Logic Check

```sql
-- Verify profit calculation
SELECT 
    sale_id,
    net_amount,
    total_cost,
    profit,
    (net_amount - total_cost) as calculated_profit
FROM silver_sales
LIMIT 5;
-- profit should equal (net_amount - total_cost)

-- Verify discount calculation
SELECT
    sale_id,
    gross_amount,
    discount_percent,
    discount_amount,
    (gross_amount * discount_percent / 100.0) as calculated_discount
FROM silver_sales
WHERE discount_percent > 0
LIMIT 5;
```

### 4. Streaming Verification

```python
# Verify all batches were processed
display(spark.sql("""
    SELECT 
        source_file,
        COUNT(*) as record_count,
        MIN(ingestion_time) as first_ingested,
        MAX(ingestion_time) as last_ingested
    FROM bronze_sales
    GROUP BY source_file
    ORDER BY first_ingested
"""))

# Should show 3 batches:
# batch1_sales.json - 30 records
# batch2_sales.json - 30 records  
# batch3_sales.json - 33 records
```

### 5. Architecture Verification

```python
# Verify Bronze-Silver-Gold architecture
print("Bronze Layer (Raw):")
display(spark.table("bronze_sales").limit(3))

print("\nSilver Layer (Transformed + Joined):")
display(spark.table("silver_sales").limit(3))

print("\nGold Layer (Aggregated):")
display(spark.table("gold_sales_summary").limit(3))
```

## Troubleshooting

### Issue 1: File Not Found

**Error:** `java.io.FileNotFoundException: No such file or directory`

**Solution:**
```python
# Verify file path
dbutils.fs.ls("/FileStore/tables/")

# If missing, re-upload
# Then verify again
display(dbutils.fs.head("/FileStore/tables/stores.csv", 100))
```

### Issue 2: Streaming Checkpoint Error

**Error:** `AnalysisException: Checkpoint location already exists`

**Solution:**
```python
# Clear existing checkpoints
dbutils.fs.rm("/FileStore/checkpoints/bronze_sales", recurse=True)
dbutils.fs.rm("/FileStore/checkpoints/silver_sales", recurse=True)
dbutils.fs.rm("/FileStore/checkpoints/gold_sales_summary", recurse=True)

# Re-run streaming cells
```

### Issue 3: Schema Mismatch

**Error:** `AnalysisException: A schema mismatch detected when writing to the Delta table`

**Solution:**
```python
# Enable schema evolution
spark.conf.set("spark.databricks.delta.schema.autoMerge.enabled", "true")

# Or drop and recreate table
spark.sql("DROP TABLE IF EXISTS bronze_sales")
```

### Issue 4: Memory Errors

**Error:** `OutOfMemoryError` or cluster crashes

**Solution:**
1. Restart cluster
2. Reduce batch size in streaming
3. Use smaller test datasets
4. Upgrade cluster to larger node type

### Issue 5: Connection Timeout (MySQL/MongoDB)

**Error:** `Connection refused` or `Timeout`

**Solution:**
```python
# For MySQL: Check firewall rules
# Add Databricks NAT IPs to allowlist

# For MongoDB: Verify connection string
# Use simulated data instead (included in notebook)

# Test connection
try:
    df = spark.read.jdbc(jdbc_url, "customers", properties)
    print("✅ Connection successful")
except Exception as e:
    print(f"❌ Connection failed: {e}")
```

### Issue 6: Notebook Cell Won't Execute

**Symptom:** Cell shows spinning circle indefinitely

**Solution:**
1. Check cluster status (should be running)
2. Look for previous cell errors
3. Restart Python kernel: "Clear State" > "Clear & Run All"
4. As last resort: Detach & Reattach cluster

## Performance Optimization Tips

### 1. Enable Delta Optimizations

```python
# Add at beginning of notebook
spark.conf.set("spark.databricks.delta.optimizeWrite.enabled", "true")
spark.conf.set("spark.databricks.delta.autoCompact.enabled", "true")
```

### 2. Partition Large Tables

```python
# For fact tables
(df.write
    .partitionBy("sale_date")
    .format("delta")
    .saveAsTable("silver_sales"))
```

### 3. Z-Order for Analytics

```python
# Optimize query performance
spark.sql("OPTIMIZE silver_sales ZORDER BY (customer_id, product_id)")
```

### 4. Cache Dimension Tables

```python
# Cache small, frequently-accessed dimensions
spark.table("dim_customer").cache()
spark.table("dim_product").cache()
```

## Next Steps After Completion

### 1. Export Results
```python
# Export to CSV for reporting
(spark.table("gold_sales_summary")
    .coalesce(1)
    .write
    .format("csv")
    .option("header", "true")
    .mode("overwrite")
    .save("/FileStore/exports/sales_summary.csv"))
```

### 2. Create Dashboard
- Use Databricks SQL for visualization
- Create charts from analytics queries
- Build executive dashboard

### 3. Schedule Jobs
- Set up automated batch processing
- Configure streaming job to run continuously
- Enable Delta Live Tables for production

### 4. GitHub Submission
```bash
# Add all files
git add .

# Commit changes
git commit -m "Complete DS-2002 Data Project 2"

# Push to GitHub
git push origin main

# Submit repository URL on Collab
```

## Support Resources

- **Databricks Documentation:** https://docs.databricks.com/
- **Delta Lake Guide:** https://docs.delta.io/
- **Apache Spark Documentation:** https://spark.apache.org/docs/
- **Course Materials:** [Your course resources]

---

**Setup Status Checklist:**

- [ ] Databricks workspace created
- [ ] Cluster configured and running
- [ ] Files uploaded to DBFS
- [ ] Notebook imported and attached
- [ ] All cells executed successfully
- [ ] Verification checks passed
- [ ] Analytics queries reviewed
- [ ] Repository ready for submission

**Estimated Setup Time:** 30-45 minutes

**Good luck with your project! 🚀**
