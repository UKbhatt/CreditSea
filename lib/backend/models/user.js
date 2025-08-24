const { Schema, model } = require('mongoose');

const UserSchema = new Schema({
  userId: { type: String, required: true, unique: true },
  phone: { type: String, required: true, unique: true },
  firstName: String,
  lastName: String,
  gender: String,
  dob: Date,
  maritalStatus: { type: String, enum: ['Married', 'Unmarried'] },
  email: String,
  panCard: String,
  purposeOfLoan: String,
  createdAt: { type: Date, default: Date.now }
});

module.exports = model('User', UserSchema);
