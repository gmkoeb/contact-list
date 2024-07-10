import { useEffect, useState } from "react"
import Cookies from 'js-cookie'
import { checkSession } from "../lib/checkSession"
import { Link } from "react-router-dom"
import { Plus, X } from "lucide-react"
import { Form, Formik } from "formik";
import TextInput from "../components/TextInput"
import { api } from "../../api/axios"

export default function Home(){
  const [isLoggedIn, setIsLoggedIn] = useState(false)
  const [formOpen, setFormOpen] = useState(false)
  const [contacts, setContacts] = useState([])
  const [apiErrors, setApiErrors] = useState([])

  async function handleSubmit(values, { setSubmitting }){
    const contactData = {
      contact: {
        name: values.name,
        registration_number: values.registration_number,
        phone: values.phone,
        address: values.address,
        zip_code: values.zip_code,
        latitude: values.latitude,
        longitude: values.longitude
      }
    }

    try {
      const response = await api.post('/contacts', contactData)
      setSubmitting(false)
    } catch (error) {
      setApiErrors(error.response.data.message)
      setSubmitting(false)
    }
  }

  useEffect(() =>{
    if (Cookies.get('token')) {
      checkSession(setIsLoggedIn)
    }
  }, [])

  return(
    <>
      {isLoggedIn ? (
        <div>
          {contacts.length === 0 ? (
            <div className="text-center">
              <h2 className="text-xl">Your contact list is empty</h2>
              <button onClick={() => setFormOpen(true)} className="flex mx-auto gap-2 text-lg items-center bg-purple-600 text-white rounded-lg mt-3 px-4 py-1 hover:opacity-80 duration-200">Add a contact <Plus /></button>
            </div>
          ): (
            <>
              <div className="text-center">
                <h2 className="text-xl">My contacts</h2>
                <button onClick={() => setFormOpen(true)} className="flex mx-auto gap-2 text-lg items-center bg-purple-600 text-white rounded-lg mt-3 px-4 py-1 hover:opacity-80 duration-200">Add a contact <Plus /></button>
              </div>
            </>
          )}
          {formOpen && (
            <>
              <Formik
                onSubmit={handleSubmit}
                initialValues={{ name: "", registration_number: "", phone: "", address: "", zip_code: "", latitude: 0, longitude: 0}}
                validate={(values) => {
                  const errors = {};
                  if (!values.name) {
                    errors.name = "Required"
                  }

                  if (!values.registration_number) {
                    errors.registration_number = 'Required';
                  } 

                  if(!values.phone){
                    errors.phone = 'Required'
                  }

                  if(!values.address){
                    errors.address = 'Required'
                  }

                  if(!values.zip_code){
                    errors.zip_code = 'Required'
                  }

                  if(!values.latitude){
                    errors.latitude = 'Required'
                  }

                  if(!values.longitude){
                    errors.longitude = 'Required'
                  }
                  return errors
                }}>
                  {({ isSubmitting }) => (
                    <Form className="flex flex-col w-[50vw] -translate-x-1/2 right-1/2 left-1/2 border border-gray-800 bg-white rounded-md mt-10 items-center py-10 text-left gap-3 absolute">
                      <h1 className='text-center text-2xl mb-4'>Add contact</h1>
                      <div className="flex flex-wrap gap-5 justify-center">
                        <TextInput label="Name" name="name" type="name" placeholder="Contact name" />
                        <TextInput label="Registration Number" name="registration_number" type="registration_number" placeholder="Contact registration number" />
                        <TextInput label="Phone" name="phone" type="phone" placeholder="Contact phone" />
                        <TextInput label="Address" name="address" type="address" placeholder="Contact address" />
                        <TextInput label="Zip code" name="zip_code" type="zip_code" placeholder="Contact zip code" />
                        <TextInput label="Latitude" name="latitude" type="latitude" placeholder="Contact latitude" />
                        <TextInput label="Longitude" name="longitude" type="longitude" placeholder="Contact longitude" />
                      </div>
                      <button className="mt-6 bg-purple-600 text-white rounded-lg py-1 font-semibold hover:bg-opacity-75 hover:duration-300 w-72" type="submit" disabled={isSubmitting}>Add contact</button>
                      <button onClick={() => setFormOpen(false)} className="bg-red-600 w-40 text-white rounded-lg py-1 hover:bg-opacity-75 hover:duration-300">Cancel</button>
                      <p className="text-red-600 text-lg mt-4">{apiErrors}</p>
                    </Form>
                )}
              </Formik>
            </>
          )}
        </div>
      ) : (
        <div className="text-center">
          <h2 className="font-bold text-xl">To view and manage your contact list, please <Link className="text-blue-600" to={'/sign_in'}>sign in</Link>.</h2>
          <p className="mt-2">Don't have an account? Create one <Link to={'/sign_up'} className="text-blue-600">here</Link></p>
        </div>
      )}
    </>
  )
}