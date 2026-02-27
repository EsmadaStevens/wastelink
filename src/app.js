const express = require('express');
const app = express();
const authRoutes = require('./auth/routes/authRoutes');
const wasteRoutes = require('./wastelogs/routes/wasteRoutes');
const pickupRoutes = require('./pickupRequest/routes/pickupRequestRoutes');
const testRoute = require("../src/routes/testRoute");


app.use(express.json());
//base url for auth routes
app.use('/api/auth', authRoutes);
//base url for waste log routes
app.use("/api/waste", wasteRoutes);
//base url for pickup request routes
app.use("/api/pickup", pickupRoutes);

app.use("/api", testRoute);



module.exports = app;
