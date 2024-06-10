import express from 'express';
import cors from 'cors';
import axios from 'axios';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

// Create Express app
const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Cashfree credentials
const API_KEY = process.env.API_KEY;
const SECRET_KEY = process.env.SECRET_KEY;

// Create order endpoint
app.post('/createOrder', async (req, res) => {
  const { orderId, orderAmount, customerDetails } = req.body;

  try {
    const response = await axios.post(
      'https://sandbox.cashfree.com/pg/orders',
      {
        order_id: orderId,
        order_amount: orderAmount,
        order_currency: 'INR',
        customer_details: customerDetails,
        order_meta: {
          return_url: 'https://your-return-url.com?order_id={order_id}',
          notify_url: 'https://your-notify-url.com',
          payment_methods: 'cc,dc,upi',
        },
      },
      {
        headers: {
          'Content-Type': 'application/json',
          'x-client-id': API_KEY,
          'x-client-secret': SECRET_KEY,
        },
      }
    );

    res.json(response.data);
  } catch (error) {
    console.error('Error creating order:', error.response.data);
    res.status(500).json({ error: 'Error creating order' });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
