const form = document.getElementById("filterForm");
const searchInput = document.getElementById("userInput");
const fieldSelect = document.getElementById("attr");

// filtered data
let currentData = [];

// export of filtered data
function download(filename, content, mime) {
  const blob = new Blob([content], { type: mime });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = filename;
  a.click();
  URL.revokeObjectURL(url);
}

function exportJSON() {
  if (!currentData || currentData.length === 0) return;

  const manufacturers = new Map();

  for (const item of currentData) {
    if (!manufacturers.has(item.name)) {
      manufacturers.set(item.name, {
        name: item.name,
        founded_year: Number(item.founded_year),
        headquarters_country: item.headquarters_country,
        headquarters_city: item.headquarters_city,
        est_value: Number(item.est_value),
        industry: item.industry,
        is_public: item.is_public === "true",
        revenue: [],
        brands: [],
      });
    }

    const manufacturer = manufacturers.get(item.name);

    // Avoid duplicate revenue entries
    if (
      !manufacturer.revenue.some(
        (r) => r.year === Number(item.revenue_year)
      )
    ) {
      manufacturer.revenue.push({
        amount: Number(item.revenue_amount),
        year: Number(item.revenue_year),
      });
    }

    // Avoid duplicate brands
    if (!manufacturer.brands.some((b) => b.name === item.brand_name)) {
      manufacturer.brands.push({
        name: item.brand_name,
        founded: Number(item.brand_founded),
      });
    }
  }

  const formatData = Array.from(manufacturers.values());
  download(
    "currentData.json",
    JSON.stringify(formatData, null, 2),
    "application/json",
  );
}

function exportCSV() {
  if (currentData.length === 0) return;
  const headers = Object.keys(currentData[0]);
  const lines = [
    headers.join(","),
    ...currentData.map((r) => headers.map((h) => r[h]).join(",")),
  ];
  download("currentData.csv", lines.join("\n"), "text/csv;charset=utf-8");
}

document.getElementById("csvExport").addEventListener("click", exportCSV);
document.getElementById("jsonExport").addEventListener("click", exportJSON);

// build table with filtered data
function buildTable(data) {
  // table element
  let resTable = document.getElementById("resTable");

  // table columns
  const COLUMNS = [
    "name",
    "founded_year",
    "headquarters_country",
    "headquarters_city",
    "est_value",
    "industry",
    "is_public",
    "revenue_amount",
    "revenue_year",
    "brand_name",
    "brand_founded",
  ];

  // Remove previous results, keeping the header
  resTable
    .querySelectorAll("tr:not(:first-child)")
    .forEach((row) => row.remove());

  // for each item create a row  
  for (const item of data) {
    let tr = document.createElement("tr");
    for (const column of COLUMNS) {
      // for each column fill the connected data
      let td = document.createElement("td");
      td.textContent = item[column] ?? "";
      tr.appendChild(td);
    }
    resTable.appendChild(tr);
  }
  return;
}

// when submited fetch the filtered data
form.addEventListener("submit", async (event) => {
  event.preventDefault();
  const query = new URLSearchParams({
    from: fieldSelect.value,
    by: searchInput.value,
  });

  const response = await fetch(`/api/manufacturers?${query}`);

  if (!response.ok) return;

  const data = await response.json();

  buildTable(data);
  currentData = data;
});

// table with all data
async function loadInitialTable() {
  try {
    const response = await fetch("/api/manufacturers?from=all");

    if (!response.ok) {
      throw new Error("Failed to load manufacturers");
    }

    const data = await response.json();
    currentData = data;

    buildTable(data);
  } catch (error) {
    console.error("Error loading initial table:", error);
  }
}

document.addEventListener("DOMContentLoaded", () => {
  loadInitialTable();
});
