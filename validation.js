//Validation
const Joi = require('@hapi/joi');

const registerValidation = (userData) => {
  const schema = Joi.object({
    phone: Joi.number().min(1000000000).max(9999999999).required(),
    nameTag: Joi.string().min(2).max(12).required(),
    password: Joi.string().min(6).required()
  });
  return schema.validate(userData);
}

const loginValidation = (userData) => {
  const schema = Joi.object({
    nameTag: Joi.string().min(2).max(12).required(),
    password: Joi.string().min(6).required()
  });
  return schema.validate(userData);
}

module.exports.registerValidation = registerValidation;
module.exports.loginValidation = loginValidation;