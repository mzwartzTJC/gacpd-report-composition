// frontend/src/App.js
import React, { useEffect, useState } from 'react';
import axios from 'axios';

function App() {
  const [message, setMessage] = useState('');

  useEffect(() => {
    axios.get('http://localhost:5000/api/message')
      .then(res => setMessage(res.data))
      .catch(err => console.error(err));
  }, []);

  return <div>{message}</div>;
}

export default App;