const express = require('express');
const app = express();
const mongoose = require('mongoose');
require('dotenv/config');

//Connect to DB
mongoose.connect(process.env.DB, { useUnifiedTopology: true , useNewUrlParser: true  }, ()=> {
  console.log('Connected to DB!');
});

//Middlewares
app.use(express.json());


//IMPORT ROUTES
const authRoute = require('./routes/auth');
app.use('/api/user', authRoute);   //Middleware

app.get('/', (req, res) => {
  res.send('Welcome');
})

const PORT = process.env.PORT || 5000;
app.listen(PORT, ()=>{
  console.log(`Server started at PORT ${PORT}`);
});