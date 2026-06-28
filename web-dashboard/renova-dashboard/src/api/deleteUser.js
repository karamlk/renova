import axios from "axios";
const API_URL = "http://127.0.0.1:8000/api";

export async function deleteUserRequest(id) {
  const token = localStorage.getItem("token");
  let response = await axios.delete(`${API_URL}/users/${id}`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });
  return response;
}
