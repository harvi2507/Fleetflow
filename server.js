const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static("public"));

/* ---------- DATABASE CONNECTION ---------- */
const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "your_password",
  database: "fleet_db"
});

db.connect(err => {
  if (err) {
    console.error("❌ Database connection failed:", err);
    return;
  }
  console.log("✅ MySQL Connected");
});

/* ---------- VEHICLES ---------- */
app.get("/api/vehicles", (req, res) => {
  db.query("SELECT * FROM vehicles", (err, rows) => {
    if (err) return res.status(500).json(err);
    res.json(rows);
  });
});

app.post("/api/vehicles", (req, res) => {
  const { vehicle_number, disc_plate, load_capacity, vehicle_type } = req.body;
  const sql = `
    INSERT INTO vehicles 
    (vehicle_number, disc_plate, load_capacity, vehicle_type, status)
    VALUES (?, ?, ?, ?, 'Available')
  `;
  db.query(sql, [vehicle_number, disc_plate, load_capacity, vehicle_type],
    (err, result) => {
      if (err) return res.status(500).json(err);
      res.json({ id: result.insertId, ...req.body, status: "Available" });
    }
  );
});

app.delete("/api/vehicles/:id", (req, res) => {
  db.query("DELETE FROM vehicles WHERE id=?", [req.params.id], () => {
    res.sendStatus(200);
  });
});

/* ---------- DRIVERS ---------- */
app.get("/api/drivers", (req, res) => {
  db.query("SELECT * FROM drivers", (err, rows) => {
    if (err) return res.status(500).json(err);
    res.json(rows);
  });
});

app.post("/api/drivers", (req, res) => {
  const { name, license, expiry, trips, performance, status } = req.body;
  db.query(
    "INSERT INTO drivers VALUES (NULL,?,?,?,?,?,?)",
    [name, license, expiry, trips, performance, status],
    (err, result) => {
      if (err) return res.status(500).json(err);
      res.json({ id: result.insertId, ...req.body });
    }
  );
});

app.delete("/api/drivers/:id", (req, res) => {
  db.query("DELETE FROM drivers WHERE id=?", [req.params.id], () => {
    res.sendStatus(200);
  });
});

/* ---------- MAINTENANCE ---------- */
app.get("/api/maintenance", (req, res) => {
  db.query("SELECT * FROM maintenance", (err, rows) => {
    if (err) return res.status(500).json(err);
    res.json(rows);
  });
});

app.post("/api/maintenance", (req, res) => {
  const { vehicle, service, description, cost } = req.body;
  db.query(
    "INSERT INTO maintenance VALUES (NULL,?,?,?,?)",
    [vehicle, service, description, cost],
    (err, result) => {
      if (err) return res.status(500).json(err);
      res.json({ id: result.insertId, ...req.body });
    }
  );
});

/* ---------- FUEL ---------- */
app.get("/api/fuel", (req, res) => {
  db.query("SELECT * FROM fuel", (err, rows) => {
    if (err) return res.status(500).json(err);
    res.json(rows);
  });
});

app.post("/api/fuel", (req, res) => {
  const { vehicle_id, litres, cost_per_litre, date } = req.body;
  db.query(
    "INSERT INTO fuel VALUES (NULL,?,?,?,?)",
    [vehicle_id, litres, cost_per_litre, date],
    (err, result) => {
      if (err) return res.status(500).json(err);
      res.json({ id: result.insertId, ...req.body });
    }
  );
});

/* ---------- TRIPS ---------- */
app.get("/api/trips", (req, res) => {
  db.query("SELECT * FROM trips", (err, rows) => {
    if (err) return res.status(500).json(err);
    res.json(rows);
  });
});

app.post("/api/trips", (req, res) => {
  const { vehicle, origin, destination, distance, weight, notes } = req.body;
  db.query(
    "INSERT INTO trips VALUES (NULL,?,?,?,?,?, 'Dispatched')",
    [vehicle, origin, destination, distance, weight, notes],
    (err, result) => {
      if (err) return res.status(500).json(err);
      res.json({ id: result.insertId, ...req.body, status: "Dispatched" });
    }
  );
});

/* ---------- SERVER ---------- */
app.listen(5000, () => {
  console.log("🚀 Server running on http://localhost:5000");
});