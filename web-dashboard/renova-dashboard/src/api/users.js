import axios from "axios";
const API_URL = "http://127.0.0.1:8000/api";
const token = localStorage.getItem("token");

export async function getUsersRequest() {
  let response = await axios.get(`${API_URL}/users`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });
  return response;
}
