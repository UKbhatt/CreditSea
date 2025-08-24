const router = require('express').Router();
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const { v4: uuidv4 } = require('uuid');

const Otp = require('../models/Otp');
const User = require('../models/user');

const genOtp = () => '' + Math.floor(100000 + Math.random() * 900000);
const hash = (code) => crypto.createHmac('sha256', process.env.JWT_SECRET).update(code).digest('hex');

// mock SMS
async function sendSMS(to, body) {
  if (process.env.DEV_MODE === 'true') {
    console.log('[SMS MOCK]', to, body);
    return;
  }
  const client = require('twilio')(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);
  await client.messages.create({ to, from: process.env.TWILIO_FROM, body });
}

// send OTP
router.post('/send-otp', async (req, res) => {
  try {
    const { phone } = req.body;
    if (!phone) return res.status(400).json({ message: 'phone required' });

    const code = genOtp();
    await Otp.deleteMany({ phone });
    await Otp.create({ phone, codeHash: hash(code) });

    await sendSMS(phone, `Your CreditSea OTP is ${code}`);

    res.json({ success: true, devCode: process.env.DEV_MODE === 'true' ? code : undefined });
  } catch (e) {
    res.status(500).json({ message: 'error' });
  }
});

// verify OTP
router.post('/verify-otp', async (req, res) => {
  try {
    const { phone, code } = req.body;
    if (!phone || !code) return res.status(400).json({ message: 'phone & code required' });

    const rec = await Otp.findOne({ phone }).sort({ createdAt: -1 });
    if (!rec) return res.status(400).json({ message: 'otp expired' });
    if (rec.codeHash !== hash(code)) return res.status(400).json({ message: 'invalid otp' });

    let user = await User.findOne({ phone });
    if (!user) {
      user = await User.create({ userId: uuidv4(), phone });
    }

    await Otp.deleteMany({ phone });

    const token = jwt.sign({ id: user.userId, phone }, process.env.JWT_SECRET, { expiresIn: '7d' });
    res.json({ token, user });
  } catch (e) {
    res.status(500).json({ message: 'error' });
  }
});

module.exports = router;
