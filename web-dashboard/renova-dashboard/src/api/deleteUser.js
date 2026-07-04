import api from "./axios";

export async function deleteUserRequest(id) {
  let response = await api.delete(`/admin/users/${id}`);
  return response;
}
