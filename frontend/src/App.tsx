import { useEffect, useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from './assets/vite.svg'
import heroImg from './assets/hero.png'
import './App.css'

import axios from 'axios';

function App() {
  const [count, setCount] = useState(0)

  useEffect(() => {
    axios.get('http://localhost:8000/health')
      .then(response => {
        console.log(response.data)
      })
      .catch(error => console.error(error));
  }, [])

  return (
    <>

    </>
  )
}

export default App
