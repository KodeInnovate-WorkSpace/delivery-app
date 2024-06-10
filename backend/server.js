import express from 'express';
import axios from 'axios';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.post('/createOrder', async (req, res) => {
  const { cartTotal, orderId } = req.body;

  try {
    const response = await axios.post('https://sandbox.cashfree.com/pg/', {
      orderId: orderId,
      orderAmount: cartTotal,
      orderCurrency: 'INR',
      customerEmail: 'customer@example.com',
      customerPhone: '1234567890',
      returnUrl: 'https://your-return-url.com',
    }, {
      headers: {
        'Content-Type': 'application/json',
        'x-client-id': process.env.API_KEY,
        'x-client-secret': process.env.SECRET_KEY,
      },
    });

    console.log("Cashfree Response:", response.data); // Log the entire response data

    // Adjust destructuring according to the response data structure
    const { orderId: cfOrderId, paymentSessionId } = response.data;
    res.json({ orderId: cfOrderId, paymentSessionId });
  } catch (error) {
    res.status(500).send(error.message);
  }
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
