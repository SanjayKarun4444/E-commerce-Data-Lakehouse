# Data Lakehouse Architecture Diagram

```mermaid
graph TB
    subgraph "Data Sources"
        A1[Azure MySQL<br/>Customers Table<br/>Relational DB]
        A2[MongoDB Atlas<br/>Products Collection<br/>NoSQL DB]
        A3[DBFS CSV Files<br/>Stores Data<br/>File System]
        A4[JSON Streaming<br/>Sales Transactions<br/>Real-time Data]
    end
    
    subgraph "ETL Layer - Batch Processing"
        B1[Batch ETL Pipeline]
        A1 --> B1
        A2 --> B1
        A3 --> B1
    end
    
    subgraph "Dimensional Lakehouse - Star Schema"
        C1[dim_date<br/>366 records]
        C2[dim_customer<br/>25 records]
        C3[dim_product<br/>15 records]
        C4[dim_store<br/>15 records]
        B1 --> C1
        B1 --> C2
        B1 --> C3
        B1 --> C4
    end
    
    subgraph "Streaming Pipeline - Lambda Architecture"
        D1[BRONZE Layer<br/>Raw Ingestion<br/>AutoLoader]
        D2[SILVER Layer<br/>Transformation<br/>Stream-Static Join]
        D3[GOLD Layer<br/>Aggregation<br/>Business Metrics]
        
        A4 --> D1
        D1 --> D2
        D2 --> D3
        
        C1 -.Reference Data.-> D2
        C2 -.Reference Data.-> D2
        C3 -.Reference Data.-> D2
        C4 -.Reference Data.-> D2
    end
    
    subgraph "Analytics Layer"
        E1[Business Intelligence<br/>Queries & Reports]
        E2[Customer Segment<br/>Analysis]
        E3[Product Performance<br/>Metrics]
        E4[Sales Trends<br/>Forecasting]
        E5[Store Benchmarking]
        
        D3 --> E1
        C1 --> E1
        C2 --> E1
        C3 --> E1
        C4 --> E1
        
        E1 --> E2
        E1 --> E3
        E1 --> E4
        E1 --> E5
    end
    
    style A1 fill:#e1f5ff
    style A2 fill:#e1f5ff
    style A3 fill:#e1f5ff
    style A4 fill:#fff4e1
    style D1 fill:#cd7f32
    style D2 fill:#c0c0c0
    style D3 fill:#ffd700
    style E1 fill:#90ee90
```

## Data Flow Explanation

### 1. Source Systems (Top Layer)
- **Azure MySQL:** Relational database containing customer information
- **MongoDB Atlas:** NoSQL database with product catalog
- **DBFS CSV:** Cloud file storage for store data
- **JSON Streaming:** Real-time sales transaction files

### 2. Batch ETL Pipeline
- Extracts data from 3 different source types
- Transforms data into dimensional format
- Loads into dimension tables

### 3. Dimensional Lakehouse (Star Schema)
- **dim_date:** Time dimension for temporal analysis
- **dim_customer:** Customer master data
- **dim_product:** Product catalog
- **dim_store:** Store locations and details
- All dimensions use surrogate keys

### 4. Streaming Pipeline (Bronze-Silver-Gold)

#### Bronze Layer
- Raw data ingestion using Spark AutoLoader
- Minimal transformation
- Preserves original source format
- Adds metadata (ingestion time, source file)

#### Silver Layer
- Data cleansing and validation
- **Key Feature:** Joins streaming fact data with static dimension data
- Enrichment with business attributes
- Type conversions and calculations

#### Gold Layer
- Business-level aggregations
- Pre-computed metrics
- Optimized for query performance
- Analytics-ready datasets

### 5. Analytics Layer
- SQL queries for business intelligence
- Customer segmentation
- Product performance analysis
- Sales trend forecasting
- Store benchmarking

## Lambda Architecture Pattern

This implementation follows the Lambda architecture:

```
Batch Layer (Dimensions)
    ↓
    └─→ Serving Layer (Star Schema) ←─┐
                                       │
Speed Layer (Streaming Facts) ────────┘
```

- **Batch Layer:** Processes historical dimension data
- **Speed Layer:** Handles real-time transaction data
- **Serving Layer:** Unified query interface combining both

## Technology Stack

| Component | Technology |
|-----------|-----------|
| Compute | Azure Databricks |
| Storage | Delta Lake |
| Streaming | Spark Structured Streaming |
| Batch Processing | PySpark |
| Data Format | Parquet (via Delta) |
| Schema | Star Schema (Kimball) |
| Ingestion | AutoLoader |

## Key Design Decisions

1. **Star Schema:** Optimized for analytical queries
2. **Delta Lake:** ACID transactions, time travel, schema evolution
3. **Bronze-Silver-Gold:** Progressive data refinement
4. **Stream-Static Join:** Real-time enrichment with reference data
5. **Surrogate Keys:** Better performance and flexibility
