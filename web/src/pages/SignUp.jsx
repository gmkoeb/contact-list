import { useState } from 'react'
import { Formik, Form } from 'formik'
import TextInput from '../components/TextInput'
import { api } from '../../api/axios'
import { useNavigate } from 'react-router-dom'

export default function SignUp() {
  const [error, setError] = useState('')
  const navigate = useNavigate()

  return (
    <Formik
      onSubmit={(values, { setSubmitting }) => {
        const userData = {
          user: {
            name: values.name,
            email: values.email,
            password: values.password
          }
        }
        api.post('/signup', userData)
          .then(() => {
            setSubmitting(false);
            navigate('/sign_in');
          })
          .catch(error => {
            setError(error.response.data.status["message"]);
            setSubmitting(false);
          })
      }}
      initialValues={{ name: "", email: "", password: "", confirm_password: "" }}
      validate={(values) => {
        const errors = {};
        if (!values.name) {
          errors.name = "Required"
        }

        if (!values.password) {
          errors.password = "Required"
        }

        if (!values.confirm_password) {
          errors.confirm_password = "Required";
        } else if (values.confirm_password !== values.password) {
          errors.confirm_password = "Passwords must match"
        }

        if (!values.email) {
          errors.email = 'Required';
        } else if (!/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.test(values.email)) {
          errors.email = 'Invalid email address';
        }
        return errors;
      }}
    >
      {({ isSubmitting }) => (
        <Form
          className="flex flex-col w-96 mx-auto border border-gray-800 bg-white rounded-md mt-10 items-center py-10 text-left gap-3">

          <h1 className='text-center text-2xl mb-4'>Sign Up</h1>

          <TextInput label="Name" name="name" type="text" placeholder="Enter your name" />
          <TextInput label="Email" name="email" type="email" placeholder="Enter your email address" />
          <TextInput label="Password (min 6 characters)" name="password" type="password" placeholder="Enter your password" />
          <TextInput label="Confirm Password" name="confirm_password" type="password" placeholder="Confirm password" />

          <button className="mt-6 bg-purple-600 text-white rounded-lg py-1 font-semibold hover:bg-opacity-75 hover:duration-300 w-[75%]" type="submit" disabled={isSubmitting}>
            Sign Up
          </button>
          <p className='text-red-600 text-center px-2'>{error}</p>
        </Form>
      )}
    </Formik>
  );
}