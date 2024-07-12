import { Form, Formik } from "formik"
import TextInput from "../components/TextInput";
import { useState } from "react";
import Cookies from 'js-cookie'
import { api } from "../../api/axios";
import { useNavigate } from 'react-router-dom';

export default function Profile(){
  const [apiErrors, setApiErrors] = useState([])
  const [deleteFormOpen, setDeleteFormOpen] = useState(false)
  const navigate = useNavigate();

  async function handlePasswordCheck(values, { setSubmitting }){
    const userData = {
      user: {
        password: values.password,
      }
    }
    try {
      await api.delete('/account', {
        data: userData,
      })
      Cookies.remove('token')
      Cookies.remove('user')
      setSubmitting(false)
      navigate('/sign_in', { state: { message: 'Account deleted with success.' } })
    } catch (error) {
      setApiErrors(error.response.data.message)
      setSubmitting(false)
    }
  }
  return(
    <div className="bg-white w-1/4 mx-auto py-10 rounded-lg border">
      <h1 className="text-2xl text-gray-700">Manage your account</h1>
      <div className="text-center mt-4">
        <button onClick={() => setDeleteFormOpen(true)} className="w-40 bg-red-600 text-white rounded-lg border hover:opacity-80 duration-300">Delete account</button>
      </div>
      {deleteFormOpen && 
        <div className="mt-10">
          <Formik
            onSubmit={handlePasswordCheck}
            initialValues={{ password: ""}}
            validate={(values) => {
              const errors = {};
              if (!values.password) {
                errors.password = "Required"
              } else if (values.password.length < 6){
                errors.password = "Must have at least 6 digits"
              }
              return errors
            }}>
              {({ isSubmitting }) => (
                <Form className="flex flex-col text-left">
                  <div className="flex flex-col items-center mb-4">
                    <h1 className='text-xl'>Confirm your password to delete your account</h1>
                  </div>
                  <div className="flex flex-wrap gap-5 justify-center">
                    <TextInput label="Password" name="password" type="password" placeholder="Type your password" />
                  </div>
                  <button className="mt-6 bg-red-600 text-white rounded-lg py-1 font-semibold hover:bg-opacity-75 hover:duration-300 w-40 mx-auto" type="submit" disabled={isSubmitting}>Confirm Deletion</button>
                  <p className="text-red-600 text-lg mt-4 text-center">{apiErrors}</p>
                </Form>
              )}
          </Formik>
        </div>
      }
    </div>
  )
}