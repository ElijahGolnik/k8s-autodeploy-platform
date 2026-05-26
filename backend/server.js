const express = require("express");
const crypto = require("crypto");
globalThis.crypto = crypto.webcrypto;
const { MongoClient } = require("mongodb");

const app = express();
const PORT = process.env.PORT || 5000;
const MONGO_URI = process.env.MONGO_URI;

// Create client
const client = new MongoClient(MONGO_URI);

// Health route
app.get("/health", (req, res) => {
    res.status(200).send("OK");
});

// DB test route
app.get("/db", async (req, res) => {
    try {
        const databases = await client.db().admin().listDatabases();
        res.json(databases);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Basic API route
app.get("/api", (req, res) => {
    res.json({ message: "Backend is running!" });
});

// STARTUP LOGIC (this is the important part)
async function startServer() {
    try {
        await client.connect();
        console.log("Connected to MongoDB");

        app.listen(PORT, () => {
            console.log(`Server running on port ${PORT}`);
        });

    } catch (error) {
        console.error("Failed to start server:", error);
    }
}

startServer();