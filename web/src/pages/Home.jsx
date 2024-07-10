import { useEffect, useState } from "react"
import Cookies from 'js-cookie'
import { checkSession } from "../lib/checkSession"
import { Link } from "react-router-dom"
import { Trash2, UserRoundPlus } from "lucide-react"
import { Form, Formik } from "formik";
import TextInput from "../components/TextInput"
import { api } from "../../api/axios"

export default function Home(){
  const [isLoggedIn, setIsLoggedIn] = useState(false)
  const [formOpen, setFormOpen] = useState(false)
  const [contacts, setContacts] = useState([])
  const [apiErrors, setApiErrors] = useState([])
  const [contactDetails, setContactDetails] = useState(false)

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
      await api.post('/contacts', contactData)
      setSubmitting(false)
      getContacts()
      setFormOpen(false)
    } catch (error) {
      setApiErrors(error.response.data.message)
      setSubmitting(false)
    }
  }

  async function getContacts(){
    const response = await api.get('/contacts')
    setContacts(response.data.contacts)
  }

  async function handleDelete(id){
    await api.delete(`/contacts/${id}`)
    getContacts()
  }

  useEffect(() =>{
    if (Cookies.get('token')) {
      checkSession(setIsLoggedIn)
      getContacts()
    }
  }, [])

  return(
    <>
      {isLoggedIn ? (
        <div className="relative">
          {contacts.length === 0 ? (
            <div className="text-center flex flex-col items-center">
              <h2 className="text-xl">Your contact list is empty</h2>
              <button onClick={() => setFormOpen(true)} 
                      className="flex gap-2 text-lg items-center bg-purple-600 text-white rounded-lg mt-3 px-4 py-1 hover:opacity-80 duration-200 w-46">
                Add a contact<UserRoundPlus width={20} height={24}/>
              </button>
            </div>
          ): (
            <div>
              <div className="flex flex-col justify-center items-center">
                <h2 className="text-3xl text-left w-1/2 font-bold text-gray-500">Contacts</h2>
              </div>
              <div className="w-1/2 mx-auto flex">
                <button
                  onClick={() => setFormOpen(true)}
                  className="flex gap-2 text-lg items-center bg-purple-600 text-white rounded-lg px-4 py-1 mt-4 mr-4 hover:opacity-80 duration-200 border border-gray-600"
                >
                  Add <UserRoundPlus width={20} height={24} />
                </button>
              </div>
              <table className="w-1/2 mx-auto mt-4">
                <thead className="rounded-t-3xl bg-gray-200">
                  <tr className="text-gray-600">
                    <th className="py-2">Name</th>
                    <th>Registration Number</th>
                    <th>Phone</th>
                    <th>Address</th>
                    <th>Zip Code</th>
                  </tr>
                </thead>
                <tbody>
                  {contacts.map(contact => (
                    <tr key={contact.id}>
                      <td>{contact.name}</td>
                      <td>{contact.registration_number}</td>
                      <td>{contact.phone}</td>
                      <td>{contact.address}</td>
                      <td>{contact.zip_code}</td>
                      <td><Trash2 onClick={() => handleDelete(contact.id)} color="#dc2626" height={24} width={20} className="cursor-pointer"/></td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
          {formOpen && (
            <div className="fixed inset-0 flex items-center justify-center bg-gray-800 bg-opacity-50">
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
                    <Form className="flex flex-col w-1/2 border border-gray-800 bg-white rounded-md items-center py-10 text-left gap-3">
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
            </div>
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