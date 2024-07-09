import { Form, Formik } from "formik";
import TextInput from "../components/TextInput";
import { api } from "../../api/axios";
import Cookies from 'js-cookie'
import { Link, useNavigate } from "react-router-dom";
import { useState } from "react";

export default function SignIn(){
  const navigate = useNavigate()
  const [error, setError] = useState('')

  async function handleSubmit(values, { setSubmitting }){
    const userData = {
      user: {
        email: values.email,
        password: values.password
      }
    }

    try {
      const response = await api.post('/login', userData)
      const token = response.data.status.data.Authorization.token
      Cookies.set('token', token, { expires: 1 })
      Cookies.set('user', response.data.status.data.user.name, { expires: 1 })
      setSubmitting(false)
      navigate('/')
      window.location.reload()
    } catch (error) {
      setError(error.response.data)
      setSubmitting(false)
    }
  }

  return (
    <>
      <Formik
      onSubmit={handleSubmit}
      initialValues={{ email: "", password: "" }}
      validate={(values) => {
        const errors = {};
        if (!values.password) {
          errors.password = "Required"
        }

        if (!values.email) {
          errors.email = 'Required';
        } else if (!/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.test(values.email)) {
          errors.email = 'Invalid email address'
        }
        return errors
      }}>
        {({ isSubmitting }) => (
        <Form className="flex flex-col w-96 mx-auto border border-gray-800 bg-white rounded-md mt-10 items-center py-10 text-left gap-3">
          <h1 className='text-center text-2xl mb-4'>Login</h1>
          <TextInput label="Email" name="email" type="email" placeholder="Enter your email" />
          <TextInput label="Password" name="password" type="password" placeholder="Enter your password" />
          <button className="mt-6 bg-purple-600 text-white rounded-lg py-1 font-semibold hover:bg-opacity-75 hover:duration-300 w-72" type="submit" disabled={isSubmitting}>Login</button>
          <p className="text-red-600 text-lg mt-4">{error}</p>
          <Link to={'/sign_up'} className="text-blue-600 mt-2 hover:bg-gray-200 rounded-md px-3 duration-300">Don't have an account? Sign up here</Link>
        </Form>
        )}
      </Formik>
    </>
  )
}
