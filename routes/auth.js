const router = require('express').Router();
const User = require('../model/users');
const {registerValidation, loginValidation } = require('../validation');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

router.post('/register', async (req, res) => {
  // Validate before storing in DB
  const {error} = registerValidation(req.body);
  if(error) return res.status(400).json({error : error.details[0].message});

  //Check if the phone number is aRlready registered
  const phoneExist = await User.findOne({"phone" : req.body.phone});
  if(phoneExist) return res.status(400).json({error : "Phone number is already registered."});

  //Check if the Name tag is already taken.
  const nameTagExist = await User.findOne({"nameTag" : req.body.nameTag});
  if(nameTagExist) return res.status(400).json({error : "This Name Tag is already Taken."});
  // Hash the password
  const salt = await bcrypt.genSalt(10);
  const hashedPass = await bcrypt.hash(req.body.password, salt);

  // Create new user and save to DB
  const user = new User({
    phone : req.body.phone,
    nameTag : req.body.nameTag,
    password : hashedPass
  });

  try{
    const savedUser = await user.save();
    res.send(savedUser);
  }catch(err){
    res.status(400).send(err);
  }
});

router.post('/login', async (req, res) => {
  // Login Validation
  const {error} = loginValidation(req.body);
  if(error) return res.status(400).send(error.details[0].message);

  //Check if the name tag is registered
  const user = await User.findOne({"nameTag" : req.body.nameTag});
  if(!user) return res.status(400).send("This Name Tag does not exists");

  const validPass = await bcrypt.compare(req.body.password, user.password);
  if(!validPass) return res.status(400).send("Wrong Password"); 

  //Create and give a token
  const token = jwt.sign({_id: user._id}, 'thisisarandomtokenstring');
  res.header('auth-token', token).send({user, token});
});

router.get('/find', async (req, res) => {
  // find the user
  const user = await User.findOne({"nameTag" : req.query.nameTag});
  if(!user) res.status(400).json({error : 'User does not exists.'});

  res.send(user);
});


module.exports = router;