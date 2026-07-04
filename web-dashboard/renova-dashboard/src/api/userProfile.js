import api from "./axios";

export async function getUserProfileRequest(id) {
  let response = await api.get(`/admin/users/${id}`);
  return response;
}
