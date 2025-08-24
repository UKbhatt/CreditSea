const { Schema, model } = require('mongoose');

const OtpSchema = new Schema({
  phone: { type: String, required: true },
  codeHash: { type: String, required: true },
  createdAt: { type: Date, default: Date.now, expires: 300 } 
});

module.exports = model('Otp', OtpSchema);
