import { api } from '../../api/axios'

export async function checkSession(setIsLoggedIn){
  const response = await api.get('/check_session')

  if (response.data.session === 'Authorized'){
    setIsLoggedIn(true)
  } else {
    setIsLoggedIn(false)
  }
}
