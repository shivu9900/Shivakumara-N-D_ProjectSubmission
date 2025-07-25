const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/api', (req, res) => {
    res.json({ message: "Hello from Node.js App!" });
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
