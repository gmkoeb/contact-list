import { NavLink } from "react-router-dom";
import { checkSession } from "../lib/checkSession";
import { useState, useEffect } from "react";
import Cookies from 'js-cookie'
import { api } from "../../api/axios";

export default function Header(){
  const [isLoggedIn, setIsLoggedIn] = useState(false)

  async function handleLogout(){
    await api.delete('/logout')
    Cookies.remove('token')
    Cookies.remove('user')
    window.location.reload()
  }

  useEffect(() => {
    if (Cookies.get('token')) {
      checkSession(setIsLoggedIn)
    }
  }, [])

  return(
    <header className="mb-20">
      <nav className="flex justify-between items-center p-3 bg-white shadow-sm">
        <div>
          <NavLink className={'text-3xl font-bold text-purple-600 mx-4'} to={'/'}>Contacts List</NavLink>
        </div>
        { isLoggedIn ? (
          <div className="flex items-center gap-4">
            <div>
              <h5 className="font-semibold text-purple-600 text-md">{Cookies.get('user')}</h5>
            </div>
            <button onClick={handleLogout} className="px-4 py-1 rounded-lg mr-3 text-white bg-red-600 hover:duration-300">Sign Out</button>
          </div>
        ) : (
        <div>
          <NavLink className={'px-5 py-2 rounded-lg mr-3 hover:bg-purple-600 hover:text-white hover:duration-300'} to={'/sign_up'}>Sign Up</NavLink>
          <NavLink className={'px-5 py-2 rounded-lg mr-3 bg-purple-600 text-white hover:opacity-80 hover:duration-300'} to={'/sign_in'}>Sign In</NavLink>
        </div>
        )}
      </nav>
    </header>
  )
}