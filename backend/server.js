const express = require("express");
const crypto = require("crypto");
globalThis.crypto = crypto.webcrypto;
const { MongoClient, ObjectId } = require("mongodb");

const app = express();
const data = app.use(express.json());
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

app.post("/users", async (req, res) => {
    try {
        const user = req.body;

        const collection = client.db().collection("users");

        await collection.insertOne(user);

        res.json({ message: "User added successfully" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.put("/users/:id", async (req, res) => {
    try {
        const id = req.params.id;

        const collection = client.db().collection("users");

        const result = await collection.updateOne(
            { _id: new ObjectId(id) }, 
            { $set: req.body }
        );
        
        res.json({ message: "User updated", result });

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.delete("/users/:id", async (req, res) => {
    try {
        const id = req.params.id;

        const collection = client.db().collection("users");

        const result = await collection.deleteOne({
            _id: new ObjectId(id)
        });

        res.json({ message: "User deleted", result });

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.get("/users", async (req, res) => {
    try {
        const collection = client.db().collection("users");

        const users = await collection.find({}).toArray();

        res.json(users);

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

