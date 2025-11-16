# Quick Start Guide - DS-2002 Data Project 2

## 🚀 Get Running in 15 Minutes

### Step 1: Upload Files (5 minutes)

1. **Login to Databricks:** https://community.cloud.databricks.com/
2. **Start your cluster**
3. **Upload these 2 files to DBFS:**
   - `data/csv/stores.csv` → `/FileStore/tables/stores.csv`
   - `data/json_streaming/products_mongodb.json` → `/FileStore/tables/products_mongodb.json`

### Step 2: Import Notebook (2 minutes)

1. **Go to Workspace**
2. **Import** → `notebooks/DS2002_Complete_Data_Lakehouse.py`
3. **Attach to your cluster**

### Step 3: Run Cells 1-10 (5 minutes)

These create all dimension tables:
- ✅ Cell 1-3: Setup
- ✅ Cell 4: Date dimension
- ✅ Cell 5-7: Customer dimension (with incremental load demo)
- ✅ Cell 8: Product dimension
- ✅ Cell 9: Store dimension
- ✅ Cell 10: Verify dimensions

**Checkpoint:** You should see 4 dimension tables with data

### Step 4: First Streaming Batch (3 minutes)

1. **Upload** `batch1_sales.json` to `/FileStore/streaming_sales/`
2. **Run cells 11-17:** Bronze → Silver → Gold processing

**Checkpoint:** You should see 30 sales transactions in bronze/silver tables

### Step 5: Additional Batches (Optional)

Repeat for batch2 and batch3 to see streaming accumulation

### Step 6: View Analytics

**Run cells 18-24** to see business insights!

---

## 📋 Requirements Checklist

### Design Requirements
- [x] Date dimension
- [x] 3+ additional dimensions (Customer, Product, Store)
- [x] 1+ fact table (Sales)
- [x] Relational DB source (MySQL - simulated)
- [x] NoSQL DB source (MongoDB - JSON file)
- [x] File system source (CSV)
- [x] Static + real-time data (dimensions + streaming facts)
- [x] Business value queries (6 analytics queries)

### Functional Requirements
- [x] Batch execution (dimension loads)
- [x] Incremental load (5 new customers added)
- [x] Streaming with AutoLoader (3 JSON batches)
- [x] Bronze-Silver-Gold architecture
- [x] Stream-dimension joins (Silver layer)
- [x] Databricks notebook
- [x] GitHub repository

---

## 🎯 What You'll Deliver

1. **Working Data Lakehouse** with:
   - 4 dimension tables
   - 3 fact tables (Bronze, Silver, Gold)
   - 93 sales transactions processed

2. **Documentation** in notebook cells explaining:
   - What each section does
   - Why it's important
   - How it meets requirements

3. **Business Analytics** showing:
   - Customer segment insights
   - Product performance
   - Sales trends
   - Store benchmarking

---

## 💡 Pro Tips

1. **Read all markdown cells** - they explain everything
2. **Run cells in order** - dependencies matter
3. **Check outputs** - verify data after each phase
4. **Don't skip verification steps** - they catch issues early
5. **Ask for help** if stuck - the setup guide has troubleshooting

---

## 📊 Expected Results

After completion, you'll have:

| Table | Records | Purpose |
|-------|---------|---------|
| dim_date | 366 | Time dimension |
| dim_customer | 25 | Customer master |
| dim_product | 15 | Product catalog |
| dim_store | 15 | Store locations |
| bronze_sales | 93 | Raw transactions |
| silver_sales | 93 | Enriched transactions |
| gold_sales_summary | ~50 | Aggregated metrics |

---

## ✅ Success Criteria

You're done when:
1. All notebook cells execute without errors
2. All tables contain expected data
3. Analytics queries return meaningful results
4. You understand the architecture
5. Code is documented with markdown cells
6. Repository is ready for GitHub submission

---

## 🆘 Help Resources

- **Detailed Setup:** See `docs/SETUP_INSTRUCTIONS.md`
- **Architecture:** See `docs/ARCHITECTURE.md`
- **Full README:** See `README.md`
- **Databricks Docs:** https://docs.databricks.com/

---

**Time Investment:**
- Initial setup: 30 minutes
- Understanding code: 1 hour
- Running & testing: 30 minutes
- Documentation review: 30 minutes
- **Total: ~2.5 hours**

**Difficulty Level:** ⭐⭐⭐☆☆ (Intermediate)

Good luck! 🚀
