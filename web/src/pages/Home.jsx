import { useEffect, useState, React } from "react"
import Cookies from 'js-cookie'
import { checkSession } from "../lib/checkSession"
import { Link } from "react-router-dom"
import { HelpCircle, Pencil, Trash2, UserRoundPlus } from "lucide-react"
import { Form, Formik } from "formik";
import TextInput from "../components/TextInput"
import { api } from "../../api/axios"
import { Tooltip } from 'react-tooltip'
import { GoogleMap, MarkerF, useLoadScript } from "@react-google-maps/api";
import { validateCPF } from "../lib/validateCPF"

const mapContainerStyle = {
  width: '25vw',
  height: '50vh',
}

const center = {
  lat: -25.4284,
  lng: -49,
}

export default function Home(){
  const { loadError } = useLoadScript({
    googleMapsApiKey: import.meta.env.VITE_GOOGLE_API_KEY,
  })

  if (loadError) {
    return <div>Error loading maps</div>;
  }

  const [isLoggedIn, setIsLoggedIn] = useState(false)
  const [createFormOpen, setCreateFormOpen] = useState(false)
  const [updateFormOpen, setUpdateFormOpen] = useState(false)
  const [helperFormOpen, setHelperFormOpen] = useState(false)
  const [contacts, setContacts] = useState([])
  const [apiErrors, setApiErrors] = useState([])
  const [suggestions, setSuggestions] = useState(null)
  const [filteredContacts, setFilteredContacts] = useState([])
  const [contact, setContact] = useState(null)
  const [suggestion, setSuggestion] = useState({address: '', zip_code: ''})
  const [searchQuery, setSearchQuery] = useState('')
  const [suggestionsNotFound, setSuggestionsNotFound] = useState('')

  const [currentPage, setCurrentPage] = useState(1)
  const contactsPerPage = 5
  const pageNumbers = []
  const indexOfLastContact = currentPage * contactsPerPage;
  const indexOfFirstContact = indexOfLastContact - contactsPerPage;
  const currentContacts = contacts.slice(indexOfFirstContact, indexOfLastContact)

  for (let i = 1; i <= Math.ceil(contacts.length / contactsPerPage); i++) {
    pageNumbers.push(i)
  }

  const paginate = (pageNumber) => setCurrentPage(pageNumber);
  async function handleContactCreation(values, { setSubmitting }){
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
      setApiErrors([])
      getContacts()
      setSuggestion({address: '', zip_code: ''})
      setCreateFormOpen(false)
    } catch (error) {
      console.log(error)
      setApiErrors(error.response.data.message)
      setSubmitting(false)
    }
  }

  async function handleContactUpdate(values, { setSubmitting }){
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
      await api.patch(`/contacts/${contact.id}`, contactData)
      setSubmitting(false)
      getContacts()
      setContact(null)
      setUpdateFormOpen(false)
    } catch (error) {
      console.log(error)
      setApiErrors(error.response.data.message)
      setSubmitting(false)
    }
  }
  
  async function handleHelperFormSubmit(values, { setSubmitting }){
    try {
      const response = await api.get(`/address_helper/${values.uf}/${values.city}/${values.address}`)
      setSubmitting(false)
      if (response.data.suggestions.length === 0) {
        setSuggestionsNotFound("Couldn't find any address with the specified information.")
      }
      setSuggestions(response.data.suggestions)
    } catch (error) {
      setApiErrors(error)
      setSubmitting(false)
    }
  }

  async function getContacts(){
    const response = await api.get('/contacts')
    setContacts(response.data.contacts)
    setFilteredContacts(response.data.contacts)
  }

  async function handleDelete(id){
    await api.delete(`/contacts/${id}`)
    getContacts()
  }

  async function handleOpenUpdateForm(id){
    setUpdateFormOpen(true)
    const response = await api.get(`/contacts/${id}`)
    setContact(response.data.contact)
  }

  function handleChange(event){
    const selectedIndex = event.target.value
    const selectedSuggestion = suggestions[selectedIndex]
    if (selectedSuggestion) {
      setSuggestion({
        address: `${selectedSuggestion.logradouro} - ${selectedSuggestion.bairro}, ${selectedSuggestion.localidade} - ${selectedSuggestion.uf}`,
        zip_code: selectedSuggestion.cep
      })
      setHelperFormOpen(false)
    }
  }

  async function handleContactClick(id){
    const response = await api.get(`/contacts/${id}`)
    setContact(response.data.contact)
  }

  useEffect(() =>{
    if (Cookies.get('token')) {
      checkSession(setIsLoggedIn)
      getContacts()
    }
  }, [])

  useEffect(() => {
    setContacts(() => 
      filteredContacts.filter(contact => 
        contact.name.toLowerCase().includes(searchQuery.toLowerCase()) || 
        contact.registration_number.includes(searchQuery)
      )
    )
  }, [searchQuery, filteredContacts])

  useEffect(() => {
    setSuggestions([])
    setSuggestionsNotFound('')
  }, [helperFormOpen])

  useEffect(() => {
    setSuggestion({address: '', zip_code: ''})
    setApiErrors([])
  }, [createFormOpen])

  useEffect(() => {
    setContact(null)
  }, [updateFormOpen])

  return(
    <>
      {isLoggedIn ? (
        <div>
          {contacts.length === 0 && !searchQuery ? (
            <div className="text-center flex flex-col items-center">
              <h2 className="text-xl">Your contact list is empty</h2>
              <button onClick={() => setCreateFormOpen(true)} 
                      className="flex gap-2 text-lg items-center bg-purple-600 text-white rounded-lg mt-3 px-4 py-1 hover:opacity-80 duration-200 w-46">
                Add a contact<UserRoundPlus width={20} height={24}/>
              </button>
            </div>
          ) : (
            <div>
              <div className="relative flex flex-col items-start mx-auto w-[75%]">
                <h2 className="text-3xl w-full text-left font-bold text-gray-500">Contacts</h2>
                <div className="flex w-full items-center mt-4">
                  <button
                    onClick={() => setCreateFormOpen(true)}
                    className="flex gap-2 text-lg items-center bg-purple-600 text-white rounded-lg px-4 py-1 mr-4 hover:opacity-80 duration-200 border border-gray-600"
                  >
                    Add <UserRoundPlus width={20} height={24} />
                  </button>
                  <div className="flex flex-col">
                    <label className="hidden" htmlFor='contactSearch'>Search</label>
                    <input className="py-1 pl-2 w-64 border-2 rounded-lg" type="text" placeholder="Search for a contact" onChange={(event) => setSearchQuery(event.target.value)} />
                  </div>
              </div>
                {searchQuery &&
                  <p>Found {contacts.length} {contacts.length === 1 ? 'result' : 'results'} for: "{searchQuery}"</p>
                }
              </div>
              {contacts.length > 0 &&
                <>
                  <div className="flex mt-4 justify-center">
                    <table className="w-1/2 h-[50vh]">
                      <thead className="rounded-t-3xl bg-gray-200">
                        <tr className="text-gray-600">
                          <th className="py-2">Name</th>
                          <th>Registration Number</th>
                          <th>Phone</th>
                          <th>Address</th>
                          <th>Zip Code</th>
                          <th></th>
                          <th></th>
                        </tr>
                      </thead>
                      <tbody>
                        {currentContacts.map(contact => (
                          <tr onClick={() => handleContactClick(contact.id)} className="cursor-pointer" key={contact.id}>
                            <td>{contact.name}</td>
                            <td>{contact.registration_number}</td>
                            <td>{contact.phone}</td>
                            <td>{contact.address}</td>
                            <td>{contact.zip_code}</td>
                            <td><Pencil onClick={() => handleOpenUpdateForm(contact.id)} height={24} width={20} className="cursor-pointer"/></td>
                            <td><Trash2 onClick={() => handleDelete(contact.id)} height={24} width={20} className="cursor-pointer"/></td>
                          </tr>
                        ))}
                        <tr>
                          <td colSpan="7" className="border bg-gray-200 align-middle">
                            <div className="flex justify-center">
                              <nav>
                                <ul className="flex list-none">
                                  {pageNumbers.map(number => (
                                    <li key={number} className={`mx-1 rounded ${currentPage === number ? 'font-bold bg-gray-300' : ''}`}>
                                      <button
                                        onClick={() => paginate(number)}
                                        className="px-3 py-2 rounded duration-300 hover:bg-gray-300"
                                      >
                                        {number}
                                      </button>
                                    </li>
                                  ))}
                                </ul>
                              </nav>
                            </div>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <div>
                      <div>
                        <GoogleMap
                          id="map"
                          mapContainerStyle={mapContainerStyle}
                          zoom={10}
                          center={center}
                        >
                          <MarkerF position={{lat: contact?.latitude || 0, lng: contact?.longitude || 0}} />
                        </GoogleMap>
                      </div>
                    </div>
                  </div>
                </>
              }
            </div>
          )}

          {createFormOpen && (
            <div className="fixed inset-0 flex items-center justify-center bg-gray-800 bg-opacity-50">
              <Formik
                enableReinitialize={true}
                onSubmit={handleContactCreation}
                initialValues={{ name: "", registration_number: "", phone: "", address: suggestion.address, zip_code: suggestion.zip_code, latitude: 0, longitude: 0}}
                validate={(values) => {
                  const errors = {};
                  if (!values.name) {
                    errors.name = "Required"
                  }

                  if (!values.registration_number) {
                    errors.registration_number = 'Required';
                  } else if (!validateCPF(values.registration_number)){
                    errors.registration_number = 'Invalid registration number';
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
                      <div className="flex items-center gap-3 mb-4">
                        <h1 className='text-2xl'>Add contact</h1>
                       
                      </div>
                      <div className="flex flex-wrap gap-5 justify-center">
                        <TextInput label="Name" name="name" type="name" placeholder="Contact name" />
                        <TextInput label="Registration Number" name="registration_number" type="registration_number" placeholder="Contact registration number" />
                        <TextInput label="Phone" name="phone" type="phone" placeholder="Contact phone" />
                        <TextInput label="Address" name="address" type="address" placeholder="Contact address" />
                        <TextInput label={ 
                          <div className="flex gap-1 items-center">
                            <p>Zip Code</p>
                            <HelpCircle data-tooltip-id="helper" data-tooltip-content="Auto fill helper" onClick={() => setHelperFormOpen(true)} className="cursor-pointer" height={24} width={24} />
                            <Tooltip id="helper" /> 
                          </div>
                        } name="zip_code" type="zip_code" placeholder="Contact zip code" />
                        <TextInput label="Latitude" name="latitude" type="latitude" placeholder="Contact latitude" />
                        <TextInput label="Longitude" name="longitude" type="longitude" placeholder="Contact longitude" />
                      </div>
                      <button className="mt-6 bg-purple-600 text-white rounded-lg py-1 font-semibold hover:bg-opacity-75 hover:duration-300 w-72" type="submit" disabled={isSubmitting}>Add contact</button>
                      <button onClick={() => setCreateFormOpen(false)} className="bg-red-600 w-40 text-white rounded-lg py-1 hover:bg-opacity-75 hover:duration-300">Cancel</button>
                      <p className="text-red-600 text-lg mt-4">{apiErrors}</p>
                    </Form>
                )}
              </Formik>
            </div>
          )}

          {updateFormOpen && contact && (
            <div className="fixed inset-0 flex items-center justify-center bg-gray-800 bg-opacity-50">
              <Formik
                onSubmit={handleContactUpdate}
                initialValues={{ name: contact.name, registration_number: contact.registration_number, 
                                 phone: contact.phone, address: contact.address, zip_code: contact.zip_code, 
                                 latitude: contact.latitude, longitude: contact.longitude}}
                validate={(values) => {
                  const errors = {};
                  if (!values.name) {
                    errors.name = "Required"
                  }

                  if (!values.registration_number) {
                    errors.registration_number = 'Required';
                  } else if (!validateCPF(values.registration_number)){
                    errors.registration_number = 'Invalid registration number';
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
                      <h1 className='text-center text-2xl mb-4'>Edit contact</h1>
                      <div className="flex flex-wrap gap-5 justify-center">
                        <TextInput label="Name" name="name" type="name" placeholder="Contact name" />
                        <TextInput label="Registration Number" name="registration_number" type="registration_number" placeholder="Contact registration number" />
                        <TextInput label="Phone" name="phone" type="phone" placeholder="Contact phone" />
                        <TextInput label="Address" name="address" type="address" placeholder="Contact address" />
                        <TextInput label="Zip code" name="zip_code" type="zip_code" placeholder="Contact zip code" />
                        <TextInput label="Latitude" name="latitude" type="latitude" placeholder="Contact latitude" />
                        <TextInput label="Longitude" name="longitude" type="longitude" placeholder="Contact longitude" />
                      </div>
                      <button className="mt-6 bg-purple-600 text-white rounded-lg py-1 font-semibold hover:bg-opacity-75 hover:duration-300 w-72" type="submit" disabled={isSubmitting}>Update</button>
                      <button onClick={() =>setUpdateFormOpen(false)} className="bg-red-600 w-40 text-white rounded-lg py-1 hover:bg-opacity-75 hover:duration-300">Cancel</button>
                      <p className="text-red-600 text-lg mt-4">{apiErrors}</p>
                    </Form>
                )}
              </Formik>
            </div>
          )}

          {helperFormOpen && (
            <div className="fixed inset-0 flex items-center justify-center bg-gray-800 bg-opacity-50">
              <Formik
                onSubmit={handleHelperFormSubmit}
                initialValues={{ uf: "", city: "", address: ""}}
                validate={(values) => {
                  const errors = {};
                  if (!values.uf) {
                    errors.uf = "Required"
                  } else if (values.uf.length > 2 || values.uf.length < 2){
                    errors.uf = "Invalid UF"
                  }

                  if (!values.city) {
                    errors.city = 'Required';
                  } 

                  if(!values.address){
                    errors.address = 'Required'
                  } else if (values.address.length < 3){
                    errors.address = 'Must have at least 3 digits'
                  }
                  return errors
                }}>
                  {({ isSubmitting }) => (
                    <Form className="flex flex-col w-[30rem] border border-gray-800 bg-white rounded-md items-center py-5 text-left gap-3">
                      <div className="flex flex-col items-center gap-3 mb-4">
                        <h1 className='text-2xl'>Helper Form for Address Completion</h1>
                      </div>
                      <div className="flex flex-wrap gap-5 justify-center">
                        <TextInput label="UF" name="uf" type="uf" placeholder="State acronym" />
                        <TextInput label="City" name="city" type="city" placeholder="City" />
                        <TextInput label="Address" name="address" type="address" placeholder="Part of address (street)" />
                      </div>
                      {suggestions.length > 0 ? (
                        <>
                          <h2 className="text-center font-semibold text-lg">Suggestions</h2>
                          <select
                            className="w-96 bg-slate-100 rounded-lg p-1"
                            name="suggestions"
                            id="suggestions"
                            onChange={event => handleChange(event)}
                          >
                            <option value="">Select an address</option>
                            {suggestions.map((suggestion, index) => (
                              <option key={index} 
                                      value={index}>
                                {suggestion.logradouro}, {suggestion.bairro}. {suggestion.cep}
                              </option>
                            ))}
                          </select>
                        </>
                      ) : (
                        <>
                          <p>{suggestionsNotFound}</p>
                        </>
                      )}
                      <button className="mt-6 bg-purple-600 text-white rounded-lg py-1 font-semibold hover:bg-opacity-75 hover:duration-300 w-72" type="submit" disabled={isSubmitting}>Submit</button>
                      <button onClick={() => setHelperFormOpen(false)} className="bg-red-600 w-40 text-white rounded-lg py-1 hover:bg-opacity-75 hover:duration-300">Cancel</button>
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