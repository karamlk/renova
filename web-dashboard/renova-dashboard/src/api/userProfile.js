import axios from "axios";
const API_URL = "http://127.0.0.1:8000/api";

export async function getUserProfileRequest(id) {
  const token = localStorage.getItem("token");
  let response = await axios.get(`${API_URL}/users/${id}`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });
  return response;
}
