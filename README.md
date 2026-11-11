# OR-labos
Laboratijske vježbe iz kolegija Otvoreno Računarstvo na FER-u

Description of dataset<br>
Car manufacturers, brands they own, make and sell, and their revenue across the years

## Metadata

| Property | Value |
|---|---|
| Dataset name | Car Manufacturers |
| Author | Domagoj Bokšić |
| Version | 2.0 |
| License | Creative Commons CC0 1.0 Universal |
| Language of the data | english |
| Formats | CSV, JSON (plus SQL database dump) |
| Date created | 30. 10. 2026. |
| Last updated | 11. 10. 2026. |
| Number of manufacturers | 12 |
| Number of brands | 37 |
| Number of revenue records | 36 (3 years per manufacturer) |
| Number of rows in the CSV | 111 (one row per combination of brand and revenue year) |
| Currency unit | billions of US dollars (USD) |

## Files

| File | Description |
|---|---|
| `carManufacturers.csv` | Data as a flat (CSV) table |
| `carManufacturers.json` | Data in a hierarchical (JSON) structure |
| `dump.sql` | Database dump (tables, data and export views) |
| `LICENSE` | License text |
| `schema.json` | JSON Schema describing the structure of the JSON file |
| `index.html` | Home page with metadata and description of the dataset |
| `datatable.html` | Table view of the data with the ability to filter it and export the filtered state |
| `backend/app.js` | Node.js server handling access to the database and sending information to the frontend |
| `public/frontend/datatableService.js` | Client-side code: fetch API, building the table and data export |
| `site.css` | Style for the website |
| `backend/.env.example` | Template for the database settings the server needs |

## Attribute description

### CSV (`carManufacturers.csv`, 11 columns)

| Column | Type | Description |
|---|---|---|
| `name` | text | Manufacturer name (e.g. Toyota) |
| `founded_year` | integer | Year the manufacturer was founded |
| `headquarters_country` | text | Country where the headquarters is located |
| `headquarters_city` | text | City where the headquarters is located |
| `est_value` | decimal number | Estimated value of the manufacturer (market capitalization) in billions of USD |
| `industry` | text | Industry the manufacturer belongs to (always `Automotive` in this dataset) |
| `is_public` | boolean | `true` if the company is publicly listed on a stock exchange, otherwise `false` |
| `revenue_amount` | decimal number | Total annual revenue of the manufacturer in billions of USD |
| `revenue_year` | integer | Year the revenue refers to |
| `brand_name` | text | Name of a brand produced by the manufacturer |
| `brand_founded` | integer | Year the brand was founded |

### JSON (`carManufacturers.json`, array of 12 objects)

| Key | Type | Description |
|---|---|---|
| `name` | string | Manufacturer name |
| `founded_year` | integer | Year the manufacturer was founded |
| `headquarters_country` | string | Country of the headquarters |
| `headquarters_city` | string | City of the headquarters |
| `est_value` | number | Estimated value (market capitalization) in billions of USD |
| `industry` | string | Industry |
| `is_public` | boolean | Whether the company is publicly listed on a stock exchange |
| `revenue` | array | Array of objects with annual revenue |
| `revenue[].amount` | number | Annual revenue in billions of USD |
| `revenue[].year` | integer | Year of the revenue |
| `brands` | array | Array of objects with the manufacturer's brands |
| `brands[].name` | string | Brand name |
| `brands[].founded` | integer | Year the brand was founded |

## Running the application

1. Create a PostgreSQL database and load the dump: `psql -d <database> -f dump.sql`
2. In `backend/`, copy `.env.example` to `.env` and fill in your database settings information
3. Install dependencies: `npm start`
4. Start the server: `npm start`
5. Open http://localhost:`PORT`

Data sources<br>
- https://companiesmarketcap.com/
- https://alansfactoryoutlet.com/