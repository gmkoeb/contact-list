import axios from "axios"
import Cookies from 'js-cookie'

export const api = axios.create({
    baseURL: 'http://localhost:3000'
})

if (Cookies.get('token')) {
    api.defaults.headers.common = {
        'Authorization': `Bearer ${Cookies.get('token')}`
    }
}