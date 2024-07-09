import { createBrowserRouter, RouterProvider } from 'react-router-dom'
import Home from './pages/Home'
import Layout from './Layout'
import SignUp from './pages/SignUp'
import SignIn from './pages/SignIn'

const router = createBrowserRouter([{
  path: '/',
  element: <Layout />,
  children: [
    { index: true, element: <Home /> },
    { path: '/sign_up', element: <SignUp /> },
    { path: '/sign_in', element: <SignIn /> }
  ],
}])

function App() {
  return (<RouterProvider router={router} />)
}

export default App