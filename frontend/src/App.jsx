import { useState } from "react";
import "./App.css";
import Login from "./pages/Login";
import Dashboard from "./pages/Dashboard";

 

function App() { 

 

  const [token,setToken] = 

  useState( 

    localStorage.getItem("token") 

  ); 

 

  return ( 

 

    <> 

      { 

        token 

        ? 

        <Dashboard setToken={setToken}/> 

        : 

        <Login setToken={setToken}/> 

      } 

    </> 

 

  ); 

 

} 

 

export default App; 