// node server.js
const express = require("express");

const app = express()
const PORT = process.env.PORT || 5000;

// Performing Health Check
app.get("/health", (req, res) => {
    res.status(200).send("OK");
});

// Routing Basic API
app.get("/api", (req, res) => {
    res.json({ message: "Backend is running!" });
});

// Basic Port Listener
app.listen(PORT, () => {
    console.log('Server operating on port:', PORT );
});