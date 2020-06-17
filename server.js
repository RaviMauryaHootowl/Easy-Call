const express = require('express');
const app = express();
const mongoose = require('mongoose');
require('dotenv/config');

//Connect to DB
mongoose.connect('mongodb+srv://ravimaurya027:ravimaurya027@cluster0-kvlzx.mongodb.net/<dbname>?retryWrites=true&w=majority', { useUnifiedTopology: true , useNewUrlParser: true  }, ()=> {
  console.log('Connected to DB!');
});

//Middlewares
app.use(express.json());

app.get('*', (req, res) => {
  res.send('Welcome');
})

//IMPORT ROUTES
const authRoute = require('./routes/auth');
app.use('/api/user', authRoute);   //Middleware

const port = process.env.PORT || 5000;
app.listen(PORT, ()=>{
  console.log(`Server started at PORT ${PORT}`);
});