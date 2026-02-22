require('dotenv').config();
const app = require('./app');

const PORT = process.env.PORT || 7000;
// const PORT = process.env.DB_PORT;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
