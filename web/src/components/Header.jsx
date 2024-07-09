import { NavLink } from "react-router-dom";

export default function Header(){
  return(
    <header className="mb-20">
      <nav className="flex justify-between items-center p-5 bg-slate-200">
        <div>
          <NavLink className={'text-3xl font-bold text-purple-600 mx-4'} to={'/'}>Contacts List</NavLink>
        </div>
        <div>
          <NavLink className={'px-5 py-2 rounded-lg mr-3 hover:bg-purple-600 hover:text-white hover:duration-300'} to={'/sign_up'}>Sign Up</NavLink>
        </div>
      </nav>
    </header>
  )
}