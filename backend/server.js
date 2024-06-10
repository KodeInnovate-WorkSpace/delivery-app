const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

// Load env
dotenv.config();

//console.log(process.env); // Debugging line to log all environment variables

const app = express();
const port = 3000;

// Middleware
app.use(cors());

let key = process.env.API_KEY;
let secret = process.env.SECRET_KEY;

app.get("/", (req, res) => {
  if (key && secret) {
    res.send("API_KEY and SECRET retrieved!");
//    console.log(`API_KEY = ${key} and SECRET = ${secret}`);
  } else {
    res.send("API_KEY or SECRET not found!");
//    console.log(`API_KEY = ${key} and SECRET = ${secret}`);
  }
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
