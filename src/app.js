const express = require('express');
const app = express();
const authRoutes = require('./auth/routes/authRoutes');
const testRoute = require("../src/routes/testRoute");


app.use(express.json());

app.use('/api/auth', authRoutes);

app.use("/api", testRoute);



module.exports = app;
