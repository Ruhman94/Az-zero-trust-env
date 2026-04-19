const express = require('express');
const cors = require('cors');
const { CosmosClient } = require('@azure/cosmos');

const app = express();
const port = process.env.PORT || 80;

// Application-layer CORS enforcement
app.use(cors()); 

// Initialize Cosmos Client securely via Environment Variables
const endpoint = process.env.COSMOS_ENDPOINT;
const key = process.env.COSMOS_KEY;
const client = new CosmosClient({ endpoint, key });

const database = client.database('ResumeStructure');
const container = database.container('VisitorCount');

app.get('/api/count', async (req, res) => {
    try {
        const counterId = '1'; 
        const { resource: item } = await container.item(counterId, counterId).read();

        let count = 0;

        if (!item) {
            count = 1;
            await container.items.create({ id: counterId, count: count });
        } else {
            count = item.count + 1;
            item.count = count;
            await container.item(counterId, counterId).replace(item);
        }

        res.status(200).json({ count: count });
    } catch (error) {
        console.error("Cosmos DB Error:", error);
        res.status(500).send("Error updating visitor count");
    }
});

app.listen(port, () => {
    console.log(`Resume API listening on port ${port}`);
});