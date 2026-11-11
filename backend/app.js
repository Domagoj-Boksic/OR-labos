const path = require("path");
const express = require("express");
const { Pool } = require("pg");
require("dotenv").config({ path: path.join(__dirname, ".env") });
const app = express();
const PORT = process.env.PORT || 3000;

const pool = new Pool();

app.use(express.json());
app.use(express.static(path.join(__dirname, "../public")));

// fetch the filtered data
app.get(`/api/manufacturers`, async (req, res) => {
  const { from, by } = req.query;

  // possible attributes
  const allowedFields = {
    name: "m.name",
    founded_year: "m.founded_year",
    headquarters_country: "m.headquarters_country",
    headquarters_city: "m.headquarters_city",
    est_value: "m.est_value",
    industry: "m.industry",
    is_public: "m.is_public",
    revenue_amount: "r.amount",
    revenue_year: "r.year",
    brand_name: "b.name",
    brand_founded: "b.founded_year"
  };

  try {
    // main sql
    let sql = `
        SELECT
          m.name,
          m.founded_year,
          m.headquarters_country,
          m.headquarters_city,
          m.est_value,
          m.industry,
          (m.is_public)::text AS is_public,
          r.amount AS revenue_amount,
          r.year AS revenue_year,
          b.name AS brand_name,
          b.founded_year AS brand_founded
        FROM manufacturer m
        JOIN brand b ON b.manufacturer_id = m.id
        JOIN revenue r ON r.manufacturer_id = m.id
      `;

    const values = [];

    if (by) {
      if (from === "all") {
        // search through every attribute
        sql += `
            WHERE
                m.name::text ILIKE $1 OR
                m.founded_year::text ILIKE $1 OR
                m.headquarters_country::text ILIKE $1 OR
                m.headquarters_city::text ILIKE $1 OR
                m.est_value::text ILIKE $1 OR
                m.industry::text ILIKE $1 OR
                m.is_public::text ILIKE $1 OR
                b.name::text ILIKE $1 OR
                b.founded_year::text ILIKE $1 OR
                r.amount::text ILIKE $1 OR
                r.year::text ILIKE $1
        `;
        values.push(`%${by}%`)
      } else {
        // search through chosen attribute
        const column = allowedFields[from];

        if (!column) {
          return res.status(400).json({
            message: "Invalid filter field",
          });
        }

        sql += ` WHERE ${column}::text ILIKE $1`;
        values.push(`%${by}%`);
      }
    }
    sql += ' ORDER BY m.name, b.name, r.year';
    const queryResult = await pool.query(sql, values);

    res.json(queryResult.rows);
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: "Internal Server Error" });
  }
});

app.listen(PORT, () => {
  console.log(`Server radi na http://localhost:${PORT}`);
});
