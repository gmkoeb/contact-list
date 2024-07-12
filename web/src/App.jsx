import { createBrowserRouter, RouterProvider } from 'react-router-dom'
import Home from './pages/Home'
import Layout from './Layout'
import SignUp from './pages/SignUp'
import SignIn from './pages/SignIn'
import Cookies from 'js-cookie'
import { api } from '../api/axios';
import Profile from './pages/Profile'
import ProtectedRoutes from './ProtectedRoutes'

async function isAuthenticated() {
  const token = Cookies.get('token')

  if (!token) {
    return false
  }

  try {
    const response = await api.get('/check_session');

    return response.data.session === 'Authorized';
  } catch (error) {
    console.error('Error checking authentication:', error);
    return false;
  }
}

const router = createBrowserRouter([
  {
    path: '/',
    element: <Layout />,
    children: [
      { index: true, element: <Home /> },
      { path: '/sign_up', element: <SignUp /> },
      { path: '/sign_in', element: <SignIn /> }
    ],
  },
  {
    element: <ProtectedRoutes checkAuth={isAuthenticated}/>,
    children: [
      {path: '/profile', element: <Profile />}
    ]
  }
])

function App() {
  return (<RouterProvider router={router} />)
}

export default App