const express = require('express');
const cors = require('cors');
const { CosmosClient } = require('@azure/cosmos');
const rateLimit = require('express-rate-limit'); // ADDED: Import the rate limiter

const app = express();
const port = process.env.PORT || 80;

// ADDED: Trust the Azure Container Apps reverse proxy
// Ensures the rate limiter reads the actual visitor's IP, not the Azure load balancer's IP
app.set('trust proxy', 1); 

// ENHANCED: Application-layer CORS enforcement (Defense in Depth)
const corsOptions = {
    origin: ['https://aalmohaimeed.com', 'https://www.aalmohaimeed.com'],
    methods: 'GET,OPTIONS',
    optionsSuccessStatus: 200
};
app.use(cors(corsOptions)); 

// ADDED: Zero-Trust Rate Limiter Configuration
const apiLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes timeframe
    max: 10, // Limit each IP to 10 requests per 15 minutes
    message: { error: "Rate limit exceeded. Please try again later." },
    standardHeaders: true, 
    legacyHeaders: false, 
});

// Apply the rate limiter specifically to the API route
app.use('/api/', apiLimiter);

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