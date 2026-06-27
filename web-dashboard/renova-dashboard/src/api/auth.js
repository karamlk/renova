import axios from "axios";
const API_URL = "http://127.0.0.1:8000/api";
const token = localStorage.getItem("token");
export async function loginRequest(email, password) {
  let response = await axios.post(`${API_URL}/login`, {
    email,
    password,
  });
  return response;
}

export async function getProfileRequest() {
  let response = await axios.get(`${API_URL}/user/profile`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });
  return response;
}
